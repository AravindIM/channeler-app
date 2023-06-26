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
  final int replyCount;
  final bool pinned;

  const Post(
      {required this.id,
      required this.username,
      this.userid,
      required this.title,
      required this.content,
      required this.timestamp,
      this.attachment,
      required this.replyCount,
      required this.pinned});

  factory Post.fromJson(Map<String, dynamic> json) {
    const dateFormatString1 = "MM/dd/yy(E)HH:mm:ss";
    const dateFormatString2 = "MM/dd/yy(E)HH:mm";

    final dateFormat1 = DateFormat(dateFormatString1);
    final dateFormat2 = DateFormat(dateFormatString2);
    DateTime timestamp;

    try {
      timestamp = dateFormat1.parse(json['now']);
    } catch (e) {
      timestamp = dateFormat2.parse(json['now']);
    }

    final String filename = '${json['tim']}'.trim();
    final String extension = json['ext'] ?? '';

    const zeroSpace = '\u200B';
    final autoUrlFormat = RegExp(
        r"(?<!\]\()(?<!https:\/\/)(?<!http:\/\/)(?<!ftp:\/\/)\b((https?|ftp):\/\/)?([\w-]{1,256}\.)+\w{2,256}([^\s\]]+)?\b(?!\]\()");
    final quoteLinkFormat = RegExp(r"\[[^\s\]]+\]\([^\s\)]*\)");

    final deadLinkRule = html2md.Rule(
      'deadlink',
      filterFn: (node) {
        if (node.nodeName == 'span' && node.className == 'deadlink') {
          return true;
        }
        return false;
      },
      replacement: (content, node) {
        final String deadLink = node.textContent;
        return '[~~$deadLink~~]()';
      },
    );

    return Post(
        id: json['no'] as int,
        username: json['name'] ?? 'Anonymous',
        userid: json['id'] as String?,
        title: html2md.convert(json['sub'] ?? '').trim(),
        content: html2md
            .convert(json['com'] ?? '', rules: [deadLinkRule])
            .trim()
            .replaceAllMapped(autoUrlFormat, (match) {
              final urlMatch = match.group(0) ?? '';
              if (!urlMatch.startsWith('http://') &&
                  !urlMatch.startsWith('https://') &&
                  !urlMatch.startsWith('ftp://')) {
                return '[$urlMatch](https://$urlMatch)';
              } else {
                return '[$urlMatch]($urlMatch)';
              }
            })
            .replaceAllMapped(quoteLinkFormat, (match) {
              return '$zeroSpace${match.group(0)}';
            }),
        timestamp: timestamp,
        attachment: filename.isNotEmpty && extension.isNotEmpty
            ? filename + extension
            : null,
        replyCount: json['replies'] ?? 0,
        pinned: (json['sticky'] ?? 0) != 0);
  }
}
