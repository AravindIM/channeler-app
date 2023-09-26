import 'dart:convert';

import 'package:channeler/backend/api_endpoint.dart';
import 'package:channeler/backend/board.dart';
import 'package:channeler/backend/post.dart';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

class Backend {
  List<Board> boards = [];
  List<dynamic> pageList = [];
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

  Future<Post> fetchPost(String boardName, int id) async {
    try {
      final response = await http.get(api.getThreadUri(boardName, id),
          headers: {'Accept': 'application/json'});
      if (response.statusCode == 200) {
        final thread = jsonDecode(response.body) as Map<String, dynamic>;
        return compute(Post.fromThreadJson, thread);
      } else {
        return Future.error('Failed to fetch thread');
      }
    } catch (e) {
      return Future.error(e.toString());
    }
  }

  List<int> getThreadList(List<dynamic> pages, int pageNum) {
    final page = pages[pageNum] as Map<String, dynamic>;
    final threadList = page['threads'] as List<dynamic>;

    return threadList.map((json) {
      final entry = json as Map<String, dynamic>;
      return entry['no'] as int;
    }).toList();
  }

  Future<List<Post>> fetchPage(String boardName, int pageNum) async {
    try {
      if (pageList.isEmpty || pageNum == 0) {
        final response = await http.get(api.getThreadListUri(boardName),
            headers: {'Accept': 'application/json'});
        if (response.statusCode == 200) {
          pageList = jsonDecode(response.body) as List<dynamic>;
          // threads = await compute(parseThreads, response.body);
        } else {
          return Future.error('Failed to fetch page');
        }
      }
      final threadList = getThreadList(pageList, pageNum);
      return Future.wait(
          threadList.map((id) async => await fetchPost(boardName, id)));
    } catch (e) {
      return Future.error(e.toString());
    }
  }
}
