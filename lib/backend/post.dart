import 'package:intl/intl.dart';
import 'package:html2md/html2md.dart' as html2md;
import 'package:mime/mime.dart';

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

  const Post({
    required this.id,
    required this.username,
    this.userid,
    required this.title,
    required this.content,
    required this.timestamp,
    this.attachment,
    required this.replyCount,
    required this.pinned,
  });

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
    final quoteLinkFormat = RegExp(r'\[[^\s\]]+\]\([^\s\)]*\)');
    final markdownLinkFormat = RegExp(r'\[[^\]]*\]\([^\)]*\)');
    final linkFormat =
        RegExp(r'((https?|ftp):\/\/)?([\w-]{1,256}\.)+\w{2,256}([^\s\]]+)?\/?');

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

    final standardisedImageRule = html2md.Rule(
      'standardImage',
      filterFn: (node) {
        return node.nodeName == 'img';
      },
      replacement: (content, node) {
        final String alt = node.getAttribute('alt') ?? '';
        String src = node.getAttribute('alt') ?? '';
        if (src.startsWith('//')) {
          src = 'https:$src';
        } else if (src.startsWith('/')) {
          src = 'https://boards.4chan.org$src';
        }
        return '<img src="$src" alt="$alt">';
      },
    );

    final standardisedLinkRule = html2md.Rule(
      'standardLink',
      filterFn: (node) {
        return node.nodeName == 'a';
      },
      replacement: (content, node) {
        final String label = node.textContent;
        String href = node.getAttribute('href') ?? '';
        if (href.startsWith('//')) {
          href = 'https:$href';
        } else if (href.startsWith('/')) {
          href = 'https://boards.4chan.org$href';
        }
        return '[$label]($href)';
      },
    );

    String markdownContent = html2md
        .convert(
          json['com'] ?? '',
          rules: [
            deadLinkRule,
            standardisedImageRule,
            standardisedLinkRule,
          ],
        )
        .trim()
        .replaceAllMapped(
          quoteLinkFormat,
          (match) {
            return '$zeroSpace${match.group(0)}';
          },
        );

    List<String> markdownLinks = markdownLinkFormat
        .allMatches(markdownContent)
        .map((match) => match[0] ?? '')
        .toList();

    List<String> portions = markdownContent.split(markdownLinkFormat);

    String content = '';

    for (var i = 0; i < portions.length; i++) {
      /* add portions not containing markdown links after linking the urls */
      content = content +
          portions[i].replaceAllMapped(linkFormat, (match) {
            final String url = match[0] ?? '';
            final List<String> urlPortions = url.split('/');
            /* ignore file names */
            if (urlPortions.length == 1) {
              final String? mimeType = lookupMimeType(urlPortions[0]);
              if (mimeType != null) {
                return url;
              }
            }
            /* ignore numbers seperated by / (frontslash) */
            if (urlPortions.every((portion) => num.tryParse(portion) != null)) {
              return url;
            }
            /* urls without protocol specified at the beginning */
            if (!url.startsWith('https://') &&
                !url.startsWith('http://') &&
                !url.startsWith('ftp://')) {
              return '[$url](https://$url)';
            }
            return '[$url]($url)';
          });
      /* join with the markdowned links */
      if (i < markdownLinks.length) {
        content = content + markdownLinks[i];
      }
    }

    return Post(
        id: json['no'] as int,
        username: json['name'] ?? 'Anonymous',
        userid: json['id'] as String?,
        title: html2md.convert(json['sub'] ?? '').trim(),
        content: content,
        timestamp: timestamp,
        attachment: filename.isNotEmpty && extension.isNotEmpty
            ? filename + extension
            : null,
        replyCount: json['replies'] ?? 0,
        pinned: (json['sticky'] ?? 0) != 0);
  }
}
