import 'package:intl/intl.dart';
import 'package:html2md/html2md.dart' as html2md;

class Post {
  final int id;
  final String username;
  final String? userid;
  final String title;
  final String content;
  final DateTime timestamp;
  final String? attachment;
  final String? attachmentExtension;
  final int replyCount;
  final bool pinned;

  const Post(
      {required this.id,
      required this.username,
      required this.userid,
      required this.title,
      required this.content,
      required this.timestamp,
      required this.attachment,
      required this.attachmentExtension,
      required this.replyCount,
      required this.pinned});

  factory Post.fromJson(Map<String, dynamic> json) {
    const dateFormatString = "MM/dd/yy(E)HH:mm:ss";
    final dateFormat = DateFormat(dateFormatString);
    return Post(
        id: json['no'] as int,
        username: json['name'] as String,
        userid: json['id'] as String?,
        title: html2md.convert(json['sub'] ?? ''),
        content: html2md.convert(json['com'] ?? ''),
        timestamp: dateFormat.parse(json['now']), //convert to DateTime
        attachment: json['filename'] as String?,
        attachmentExtension: json['ext'] as String?,
        replyCount: json['replies'] ?? 0,
        pinned: (json['sticky'] ?? 0) != 0);
  }
}
