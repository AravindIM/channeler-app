import 'package:channeler/backend/api_endpoint.dart';
import 'package:channeler/backend/board.dart';
import 'package:channeler/backend/thread.dart';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

class Backend {
  List<Board> boards = [];
  final ApiEndpoint api = ApiEndpoint.for4chan();

  Future<List<Board>> fetchBoards() async {
    try {
      if (boards.isEmpty) {
        final response = await http
            .get(api.getBoardsUri(), headers: {'Accept': 'application/json'});
        if (response.statusCode == 200) {
          boards = await compute(parseBoards, response.body);
        } else {
          return Future.error('Failed to fetch boards');
        }
      }
      return boards;
    } catch (e) {
      return Future.error(e.toString());
    }
  }

  Board findBoardByName(String name) {
    final board = boards.firstWhere((board) => board.name == name);
    return board;
  }

  Future<List<Thread>> fetchThread(String boardName, String id) async {
    List<Thread> threads = [];
    try {
      final response = await http.get(api.getThreadUri(boardName, id),
          headers: {'Accept': 'application/json'});
      if (response.statusCode == 200) {
        threads = await compute(parseThreads, response.body);
      } else {
        return Future.error('Failed to fetch thread');
      }
      return threads;
    } catch (e) {
      return Future.error(e.toString());
    }
  }

  Future<List<Thread>> fetchPage(String boardName, int page) async {
    List<Thread> threads = [];
    try {
      final response = await http.get(api.getPageUri(boardName, page),
          headers: {'Accept': 'application/json'});
      if (response.statusCode == 200) {
        threads = await compute(parseThreads, response.body);
      } else {
        return Future.error('Failed to fetch page');
      }
      return threads;
    } catch (e) {
      return Future.error(e.toString());
    }
  }
}
