import 'dart:convert';

import 'package:channeler/backend/board.dart';
import 'package:channeler/backend/paginator.dart';
import 'package:channeler/backend/post.dart';
import 'package:channeler/backend/session.dart';
import 'package:http/http.dart' as http;
import 'package:channeler/backend/api_endpoint.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  final session = Session(api: ApiEndpoint.for4chan());

  test("API Uri Generation", () {
    final api = session.api;
    final boardsUri = api.getBoardsUri();
    expect(boardsUri.toString(), "https://a.4cdn.org/boards.json");
    final threadListUri = api.getThreadListUri("g");
    expect(threadListUri.toString(), "https://a.4cdn.org/g/threads.json");
    final threadUri = api.getThreadUri("g", 1);
    expect(threadUri.toString(), "https://a.4cdn.org/g/thread/1.json");
  });

  test("Parsing Boards", () async {
    final api = session.api;

    final response = await http
        .get(api.getBoardsUri(), headers: {'Accept': 'application/json'});
    if (response.statusCode == 200) {
      final boards = parseBoards(response.body);
      assert(boards.isNotEmpty);
    } else {
      return Future.error('Failed to parse boards!');
    }
  });

  test("Parsing Catalog", () async {
    final api = session.api;

    final response = await http
        .get(api.getCatalogUri("g"), headers: {'Accept': 'application/json'});
    if (response.statusCode == 200) {
      final catalogJson = jsonDecode(response.body);

      final CatalogPaginator cpager = CatalogPaginator(boardName: "g");
      cpager.refreshFromCatalogJson(catalogJson);

      List<Post> cpage = cpager.getNextPage().toList();
      assert(cpage.isNotEmpty);

      cpage = cpager.getNextPage().toList();
      assert(cpage.isNotEmpty);

      cpage = cpager.getNextPage().toList();
      assert(cpage.isNotEmpty);
    } else {
      return Future.error('Failed to fetch catalog!');
    }
  });

  test("Parsing Threads", () async {
    final api = session.api;
    int id;

    final response = await http
        .get(api.getCatalogUri("g"), headers: {'Accept': 'application/json'});
    if (response.statusCode == 200) {
      final catalogJson = jsonDecode(response.body);

      CatalogPaginator cpager = CatalogPaginator(boardName: "g");
      cpager.refreshFromCatalogJson(catalogJson);

      List<Post> cpage = cpager.getNextPage().toList();
      assert(cpage.isNotEmpty);
      id = cpage[0].id;
    } else {
      return Future.error('Failed to fetch catalog!');
    }

    final response2 = await http.get(api.getThreadUri("g", id),
        headers: {'Accept': 'application/json'});
    if (response.statusCode == 200) {
      final threadJson = jsonDecode(response2.body);

      ThreadPaginator tpager = ThreadPaginator(boardName: "g", id: id);
      tpager.refreshFromThreadJson(threadJson);

      List<Post> tpage = tpager.getNextPage().toList();
      assert(tpage.isNotEmpty);
    } else {
      return Future.error('Failed to parse boards!');
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
