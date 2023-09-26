import 'dart:convert';

import 'package:channeler/backend/board.dart';
import 'package:channeler/backend/post.dart';
import 'package:http/http.dart' as http;
import 'package:channeler/backend/api_endpoint.dart';
import 'package:channeler/backend/backend.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test("API Uri Generation", () {
    final api = ApiEndpoint.for4chan();
    final boardsUri = api.getBoardsUri();
    expect(boardsUri.toString(), "https://a.4cdn.org/boards.json");
    final threadListUri = api.getThreadListUri("g");
    expect(threadListUri.toString(), "https://a.4cdn.org/g/threads.json");
    final threadUri = api.getThreadUri("g", 1);
    expect(threadUri.toString(), "https://a.4cdn.org/g/thread/1.json");
  });

  test("Parsing Boards", () async {
    final api = ApiEndpoint.for4chan();

    final response = await http
        .get(api.getBoardsUri(), headers: {'Accept': 'application/json'});
    if (response.statusCode == 200) {
      final boards = parseBoards(response.body);
      assert(boards.isNotEmpty);
    } else {
      return Future.error('Failed to parse boards!');
    }
  });

  test("Parsing Threads", () async {
    final api = ApiEndpoint.for4chan();
    final backend = Backend();

    final response = await http.get(api.getThreadListUri("g"),
        headers: {'Accept': 'application/json'});
    if (response.statusCode == 200) {
      final pages = jsonDecode(response.body) as List<dynamic>;
      final threadList = backend.getThreadList(pages, 0);
      assert(threadList.isNotEmpty);

      final response2 = await http.get(api.getThreadUri("g", threadList[0]),
          headers: {'Accept': 'application/json'});

      if (response2.statusCode == 200) {
        final json = jsonDecode(response2.body) as Map<String, dynamic>;
        final _ = Post.fromThreadJson(json);
      } else {
        return Future.error('Failed to parse thread!');
      }
    } else {
      return Future.error('Failed to parse threads list!');
    }
  });

  test("Parsing Page", () async {
    final backend = Backend();
    try {
      final threads = await backend.fetchPage("g", 0);
      assert(threads.isNotEmpty);
    } catch (e) {
      return Future.error(
          'Failed to parse page for board /g/: ${e.toString()}');
    }
  });

  // test("Parsing Pages", () async {
  //   final backend = Backend();
  //   final boards = await backend.fetchBoards();
  //   for (final board in boards) {
  //     try {
  //       final threads = await backend.fetchPage(board.name, 0);
  //       assert(threads.isNotEmpty);
  //     } catch (e) {
  //       return Future.error(
  //           'Failed to parse page for board /${board.name}/: ${e.toString()}');
  //     }
  //   }
  // });
}
