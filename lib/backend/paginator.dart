abstract interface class Paginator {
  String getBoardName();
  int getMaxPages();
  List<int> getPage(int pageNum);
}

class CatalogPaginator implements Paginator {
  final String boardName;
  List<int> threads = [];
  int pageSize = 10;

  CatalogPaginator({required this.boardName});

  void refreshFromThreadListJson(List<dynamic> threadListJson) {
    threads = threadListJson
        .map((pageJson) {
          final page = pageJson as Map<String, dynamic>;
          final pageThreads = page['threads'] as List<dynamic>;
          return pageThreads.map((json) {
            final entry = json as Map<String, dynamic>;
            return entry['no'] as int;
          });
        })
        .toList()
        .expand((element) => element)
        .toList();
  }

  @override
  int getMaxPages() {
    var pagecount = threads.length / pageSize;
    return pagecount.ceil();
  }

  @override
  String getBoardName() {
    return boardName;
  }

  @override
  List<int> getPage(int pageNum) {
    final start = (pageNum - 1) * pageSize;
    int end = start + pageSize;
    if (end > threads.length) {
      end = threads.length;
    }

    return threads.sublist(start, end);
  }
}

class ThreadPaginator implements Paginator {
  final String boardName;
  final int id;
  List<int> threads = [];
  int pageSize = 10;

  ThreadPaginator({required this.boardName, required this.id});

  void refreshFromThreadJson(Map<String, dynamic> threadJson) {
    List<dynamic> posts = threadJson['posts'] as List<dynamic>;
    threads = posts.map((postJson) {
      final post = postJson as Map<String, dynamic>;
      return post['no'] as int;
    }).toList();
  }

  @override
  String getBoardName() {
    return boardName;
  }

  @override
  int getMaxPages() {
    var pagecount = threads.length / pageSize;
    return pagecount.floor();
  }

  @override
  List<int> getPage(int pageNum) {
    final start = (pageNum - 1) * pageSize;
    int end = start + pageSize;
    if (end > threads.length) {
      end = threads.length;
    }

    return threads.sublist(start, end);
  }
}
