import 'package:intl/intl.dart';

class Post {
  final int id;
  final String username;
  final String? userid;
  final String? title;
  final String? content;
  final DateTime creationTime;
  final String? attachment;
  final String? attachmentExtension;
  final int replyCount;

  const Post(
      {required this.id,
      required this.username,
      required this.userid,
      required this.title,
      required this.content,
      required this.creationTime,
      required this.attachment,
      required this.attachmentExtension,
      required this.replyCount});

  factory Post.fromJson(Map<String, dynamic> json) {
    const dateFormatString = "MM/dd/yy(E)HH:mm:ss";
    final dateFormat = DateFormat(dateFormatString);
    return Post(
        id: json['no'] as int,
        username: json['name'] as String,
        userid: json['id'] as String?,
        title: json['sub'] as String?,
        content: json['com'] as String?,
        creationTime: dateFormat.parse(json['now']), //convert to DateTime
        attachment: json['filename'] as String?,
        attachmentExtension: json['ext'] as String?,
        replyCount: json['replies'] ?? 0);
  }
}
