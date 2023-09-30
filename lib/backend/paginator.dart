import 'package:channeler/backend/post.dart';
import 'package:flutter/foundation.dart';

abstract interface class Paginator {
  String getBoardName();
  int getPageSize();
  Future<List<Post>> getNextPage();
}

class CatalogPaginator implements Paginator {
  final String boardName;
  Stream<Post> pages = const Stream<Post>.empty().asBroadcastStream();
  int pageSize = 10;

  CatalogPaginator({required this.boardName});

  Stream<Post> generatePosts(List<dynamic> catalogJson) async* {
    final List<dynamic> threadList = await compute(
        (_) => catalogJson
            .map((pageJson) {
              final page = pageJson as Map<String, dynamic>;
              final threadList = page['threads'] as List<dynamic>;
              return threadList;
            })
            .expand((thread) => thread)
            .toList(),
        "");
    final List<Post> postList = await compute(
        (_) => threadList.map((postJson) => Post.fromJson(postJson)).toList(),
        "");
    for (var post in postList) {
      yield post;
    }
  }

  void refreshFromCatalogJson(List<dynamic> catalogJson) {
    pages = generatePosts(catalogJson).asBroadcastStream();
  }

  @override
  Future<List<Post>> getNextPage() async {
    return pages.take(pageSize).toList();
  }

  @override
  String getBoardName() {
    return boardName;
  }

  @override
  int getPageSize() {
    return pageSize;
  }
}

class ThreadPaginator implements Paginator {
  final String boardName;
  final int id;
  Stream<Post> pages = const Stream<Post>.empty().asBroadcastStream();
  int pageSize = 10;

  ThreadPaginator({required this.boardName, required this.id});

  Stream<Post> generatePosts(Map<String, dynamic> threadJson) async* {
    List<dynamic> postsJson = threadJson['posts'] as List<dynamic>;
    final List<Post> postList = await compute(
        (_) => postsJson.map((postJson) => Post.fromJson(postJson)).toList(),
        "");
    for (var post in postList) {
      yield post;
    }
  }

  void refreshFromThreadJson(Map<String, dynamic> catalogJson) {
    pages = generatePosts(catalogJson).asBroadcastStream();
  }

  @override
  Future<List<Post>> getNextPage() async {
    return pages.take(pageSize).toList();
  }

  @override
  String getBoardName() {
    return boardName;
  }

  @override
  int getPageSize() {
    return pageSize;
  }
}
