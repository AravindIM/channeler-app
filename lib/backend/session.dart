import 'package:channeler/backend/api_endpoint.dart';
import 'package:channeler/backend/backend.dart';
import 'package:channeler/backend/board.dart';
import 'package:flutter/material.dart';

class Session {
  final ApiEndpoint api;
  List<Board> boards = [];
  PageStorageBucket appBucket = PageStorageBucket();
  PageStorageBucket pageBucket = PageStorageBucket();

  Session({required this.api});

  Future<List<Board>> getBoards() async {
    try {
      if (boards.isEmpty) {
        boards = await fetchBoards(this);
      }
      return boards;
    } catch (e) {
      return Future.error(e.toString());
    }
  }

  void resetPageBucket() {
    pageBucket = PageStorageBucket();
  }

  Board findBoardByName(String name) {
    final board = boards.firstWhere((board) => board.name == name);
    return board;
  }
}
