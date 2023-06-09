import 'package:channeler/backend/board.dart';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

Map<String, String> url = {'boards': 'https://a.4cdn.org/boards.json'};

class Backend {
  late List<Board> boards = [];
  Future<List<Board>> fetchBoards() async {
    try {
      if (boards.isEmpty) {
        final response = await http.get(Uri.parse(url['boards']!),
            headers: {'Accept': 'application/json'});
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
}
