import 'package:channeler/backend/backend.dart';
import 'package:channeler/backend/board.dart';
import 'package:channeler/backend/thread.dart';
import 'package:channeler/widgets/feed/feed_card.dart';
import 'package:flutter/material.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';

class Feed extends StatefulWidget {
  const Feed({super.key, required this.backend, required this.board});
  final Backend backend;
  final Board board;

  @override
  State<Feed> createState() => _FeedState();
}

class _FeedState extends State<Feed> {
  final PagingController<int, Thread> _pagingController =
      PagingController(firstPageKey: 1);

  @override
  void initState() {
    _pagingController.addPageRequestListener((pageKey) {
      _fetchPage(widget.backend, widget.board.name, pageKey);
    });
    super.initState();
  }

  Future<void> _fetchPage(
      Backend backend, String boardName, int pageKey) async {
    try {
      final Board board = backend.findBoardByName(boardName);
      final List<Thread> newItems = await backend.fetchPage(boardName, pageKey);
      final isLastPage =
          newItems.length < board.threadsPerPage || pageKey == board.pages;
      if (isLastPage) {
        _pagingController.appendLastPage(newItems);
      } else {
        final nextPageKey = pageKey + 1;
        _pagingController.appendPage(newItems, nextPageKey);
      }
    } catch (error) {
      _pagingController.error = error;
    }
  }

  @override
  void didUpdateWidget(Feed oldWidget) {
    _pagingController.refresh();
    super.didUpdateWidget(oldWidget);
  }

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: () => Future.sync(() => _pagingController.refresh()),
      child: PagedListView<int, Thread>(
        padding: EdgeInsets.zero,
        pagingController: _pagingController,
        builderDelegate: PagedChildBuilderDelegate(
          itemBuilder: (context, Thread item, index) {
            return FeedCard(thread: item, board: widget.board);
          },
        ),
      ),
    );
  }

  @override
  void dispose() {
    _pagingController.dispose();
    super.dispose();
  }
}
