import 'dart:math';

import 'package:channeler/backend/board.dart';
import 'package:channeler/backend/thread.dart';
import 'package:http/http.dart' as http;
import 'package:channeler/backend/api_endpoint.dart';
import 'package:channeler/backend/backend.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test("API Testing", () {
    final api = ApiEndpoint.for4chan();
    final boardsUri = api.getBoardsUri();
    expect(boardsUri.toString(), "https://a.4cdn.org/boards.json");
    final pageUri = api.getPageUri("g", 1);
    expect(pageUri.toString(), "https://a.4cdn.org/g/1.json");
  });

  test("Parsing Boards", () async {
    final api = ApiEndpoint.for4chan();

    final response = await http
        .get(api.getBoardsUri(), headers: {'Accept': 'application/json'});
    if (response.statusCode == 200) {
      final boards = parseBoards(response.body);
      assert(boards.isNotEmpty);
    } else {
      return Future.error('Failed to fetch boards');
    }
  });

  test("Parsing Threads", () async {
    final api = ApiEndpoint.for4chan();

    final response = await http
        .get(api.getPageUri("g", 1), headers: {'Accept': 'application/json'});
    if (response.statusCode == 200) {
      final threads = parseThreads(response.body);
      assert(threads.isNotEmpty);
    } else {
      return Future.error('Failed to fetch boards');
    }
  });

  test("Backend Testing", () async {
    final backend = Backend();
    final boards = await backend.fetchBoards();
    final selectedBoard = boards[Random().nextInt(boards.length)];
    final threads = await backend.fetchPage(selectedBoard.name, 1);
    assert(threads.isNotEmpty);
  });
}
