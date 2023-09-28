import 'package:channeler/backend/api_endpoint.dart';
import 'package:channeler/backend/backend.dart';
import 'package:channeler/backend/board.dart';

class Session {
  final ApiEndpoint api;
  List<Board> boards = [];

  Session({required this.api});

  Future<List<Board>> getBoards() async {
    if (boards.isEmpty) {
      try {
        boards = await fetchBoards(this);
      } catch (e) {
        Future.error(e.toString());
      }
    }
    return boards;
  }

  Board findBoardByName(String name) {
    final board = boards.firstWhere((board) => board.name == name);
    return board;
  }
}
