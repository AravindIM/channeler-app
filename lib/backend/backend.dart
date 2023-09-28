import 'dart:convert';

import 'package:channeler/backend/board.dart';
import 'package:channeler/backend/paginator.dart';
import 'package:channeler/backend/post.dart';
import 'package:channeler/backend/session.dart';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

Future<List<Board>> fetchBoards(Session session) async {
  List<Board> boards;
  try {
    final response = await http.get(session.api.getBoardsUri(),
        headers: {'Accept': 'application/json'});
    if (response.statusCode == 200) {
      boards = await compute(parseBoards, response.body);
    } else {
      return Future.error('Failed to fetch boards');
    }
    return boards;
  } catch (e) {
    return Future.error(e.toString());
  }
}

Board findBoardByName(List<Board> boards, String name) {
  final board = boards.firstWhere((board) => board.name == name);
  return board;
}

Future<Post> fetchPost(Session session, String boardName, int id) async {
  try {
    final response = await http.get(session.api.getThreadUri(boardName, id),
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

Future<void> refreshPaginator(Session session, Paginator paginator) async {
  if (paginator is CatalogPaginator) {
    await refreshCatalogPaginator(session, paginator);
  } else if (paginator is ThreadPaginator) {
    await refreshThreadPaginator(session, paginator);
  }
}

Future<void> refreshCatalogPaginator(
    Session session, CatalogPaginator paginator) async {
  try {
    final response = await http.get(
        session.api.getThreadListUri(paginator.boardName),
        headers: {'Accept': 'application/json'});
    if (response.statusCode == 200) {
      final threadListJson = jsonDecode(response.body) as List<dynamic>;
      paginator.refreshFromThreadListJson(threadListJson);
    } else {
      return Future.error('Failed to fetch paginator');
    }
  } catch (e) {
    return Future.error(e.toString());
  }
}

Future<void> refreshThreadPaginator(
    Session session, ThreadPaginator paginator) async {
  try {
    final response = await http.get(
        session.api.getThreadUri(paginator.boardName, paginator.id),
        headers: {'Accept': 'application/json'});
    if (response.statusCode == 200) {
      final threadJson = jsonDecode(response.body) as Map<String, dynamic>;
      paginator.refreshFromThreadJson(threadJson);
    } else {
      return Future.error('Failed to fetch paginator');
    }
  } catch (e) {
    return Future.error(e.toString());
  }
}

Future<List<Post>> fetchPage(
    Session session, Paginator paginator, int pageNum) async {
  if (pageNum == 1) {
    await refreshPaginator(session, paginator);
  }
  List<int> threads = paginator.getPage(pageNum);
  return Future.wait(threads.map(
      (thread) async => fetchPost(session, paginator.getBoardName(), thread)));
}
