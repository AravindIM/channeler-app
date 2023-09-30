import 'package:channeler/backend/post.dart';

abstract interface class Paginator {
  String getBoardName();
  int getPageSize();
  List<Post> getNextPage();
}

class CatalogPaginator implements Paginator {
  final String boardName;
  Iterator<List<Post>> pages = <List<Post>>[].iterator;
  int pageSize = 10;

  CatalogPaginator({required this.boardName});

  Iterable<List<Post>> generatePage(List<dynamic> catalogJson) sync* {
    List<Post> page = [];
    for (var pageJson in catalogJson) {
      final pageMap = pageJson as Map<String, dynamic>;
      final threadList = pageMap['threads'] as List<dynamic>;
      for (var post in threadList) {
        page.add(Post.fromJson(post));
        if (page.length >= pageSize) {
          yield page;
          page = [];
        }
      }
    }
    if (page.isNotEmpty) {
      yield page;
    }
  }

  void refreshFromCatalogJson(List<dynamic> catalogJson) {
    pages = generatePage(catalogJson).iterator;
  }

  @override
  List<Post> getNextPage() {
    if (pages.moveNext()) {
      return pages.current;
    } else {
      return [];
    }
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
  Iterator<List<Post>> pages = <List<Post>>[].iterator;
  int pageSize = 10;

  ThreadPaginator({required this.boardName, required this.id});

  Iterable<List<Post>> generatePosts(Map<String, dynamic> threadJson) sync* {
    List<Post> page = [];
    List<dynamic> posts = threadJson['posts'] as List<dynamic>;
    for (var postJson in posts) {
      final post = postJson as Map<String, dynamic>;
      page.add(Post.fromJson(post));
      if (page.length >= pageSize) {
        yield page;
        page = [];
      }
    }
    if (page.isNotEmpty) {
      yield page;
    }
  }

  void refreshFromThreadJson(Map<String, dynamic> catalogJson) {
    pages = generatePosts(catalogJson).iterator;
  }

  @override
  List<Post> getNextPage() {
    if (pages.moveNext()) {
      return pages.current;
    } else {
      return [];
    }
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
