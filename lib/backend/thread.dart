import 'dart:convert';

import 'package:channeler/backend/post.dart';

class Thread {
  final Post post;
  final List<Post> replies;

  const Thread({required this.post, required this.replies});

  factory Thread.fromJson(Map<String, dynamic> json) {
    final posts = json['posts'] as List<dynamic>;
    final post = posts[0] as Map<String, dynamic>;
    final replies = posts.sublist(1);
    return Thread(
        post: Post.fromJson(post),
        replies: replies
            .map((json) => Post.fromJson(json as Map<String, dynamic>))
            .toList());
  }
}

List<Thread> parseThreads(String responseBody) {
  final des = jsonDecode(responseBody) as Map<String, dynamic>;
  final threads = des['threads'] as List<dynamic>;
  return threads
      .map((json) => Thread.fromJson(json as Map<String, dynamic>))
      .toList();
}
