class ApiEndpoint {
  final String boards;
  final String page;
  final String attachment;
  final String thread;

  const ApiEndpoint(
      {required this.boards,
      required this.page,
      required this.attachment,
      required this.thread});

  factory ApiEndpoint.for4chan() {
    return const ApiEndpoint(
        boards: 'https://a.4cdn.org/boards.json',
        page: 'https://a.4cdn.org/{board}/{page}.json',
        attachment: 'https://i.4cdn.org/{board}/{filename}{ext}',
        thread: 'https://a.4cdn.org/{board}/thread/{id}.json');
  }

  Uri getBoardsUri() {
    return Uri.parse(boards);
  }

  Uri getPageUri(String board, int page) {
    return Uri.parse(this
        .page
        .replaceAll('{board}', board)
        .replaceAll('{page}', page.toString()));
  }

  Uri getAttachment(String board, String filename, String ext) {
    return Uri.parse(attachment
        .replaceAll('{board}', board)
        .replaceAll('{filename}', filename)
        .replaceAll('{ext}', ext));
  }

  Uri getThreadUri(String board, String id) {
    return Uri.parse(
        thread.replaceAll('{board}', board).replaceAll('{id}', id));
  }
}
