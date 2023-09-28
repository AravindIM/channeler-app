import 'package:channeler/backend/board.dart';
import 'package:channeler/backend/paginator.dart';
import 'package:channeler/backend/session.dart';
import 'package:http/http.dart' as http;
import 'package:channeler/backend/api_endpoint.dart';
import 'package:channeler/backend/backend.dart' as backend;
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
    CatalogPaginator cataloguePaginator = CatalogPaginator(boardName: "g");

    backend.refreshPaginator(session, cataloguePaginator);

    final cid = cataloguePaginator.getPage(1)[0];

    backend.fetchPost(session, cataloguePaginator.getBoardName(), cid);
  });

  test("Parsing Threads", () async {
    CatalogPaginator cataloguePaginator = CatalogPaginator(boardName: "g");

    backend.refreshPaginator(session, cataloguePaginator);

    final cid = cataloguePaginator.getPage(1)[0];

    ThreadPaginator threadPaginator = ThreadPaginator(boardName: "g", id: cid);

    backend.refreshPaginator(session, threadPaginator);

    final tid = threadPaginator.getPage(1)[0];

    backend.fetchPost(session, threadPaginator.getBoardName(), tid);
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
