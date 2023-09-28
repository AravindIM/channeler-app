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

    /* zero-width space used for enforcing links to be part of parent quote block */
    const zeroWidthSpace = '\u200B';

    /* Regex formats for search replacement in the content */
    final markdownLinkFormat = RegExp(r'\[[^\]]*\]\([^\)]*\)');
    final linkFormat =
        RegExp(r'((https?|ftp):\/\/)?([\w-]{1,256}\.)+\w{2,256}([^\s\]]+)?\/?');
    final nonUrlNumberFormat = RegExp(r'^[^A-Za-z]+$');

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

    String markdownContent = html2md.convert(
      json['com'] ?? '',
      rules: [
        deadLinkRule,
        standardisedImageRule,
        standardisedLinkRule,
      ],
    ).trim();

    List<String> markdownLinks = markdownLinkFormat
        .allMatches(markdownContent)
        .map((match) => match[0] ?? '')
        .toList();

    List<String> contentPortions = markdownContent.split(markdownLinkFormat);

    String content = '';

    for (var i = 0; i < contentPortions.length; i++) {
      /* add portions not containing markdown links after linking the urls */
      content = content +
          contentPortions[i].replaceAllMapped(linkFormat, (match) {
            final String matchedText = match[0] ?? '';
            final List<String> urlPortions = matchedText.split('/');
            /* ignore file names */
            if (urlPortions.length == 1) {
              final String? mimeType = lookupMimeType(urlPortions[0]);
              if (mimeType != null) {
                return matchedText;
              }
            }
            /* ignore numbers seperated by special characters */
            if (nonUrlNumberFormat.hasMatch(matchedText)) {
              return matchedText;
            }
            /* urls without protocol specified at the beginning */
            if (!matchedText.startsWith('https://') &&
                !matchedText.startsWith('http://') &&
                !matchedText.startsWith('ftp://')) {
              return '$zeroWidthSpace[$matchedText](https://$matchedText)';
            }
            return '$zeroWidthSpace[$matchedText]($matchedText)';
          });
      /* join with the markdowned links */
      if (i < markdownLinks.length) {
        content = content + zeroWidthSpace + markdownLinks[i];
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

  factory Post.fromThreadJson(Map<String, dynamic> json) {
    final posts = json['posts'] as List<dynamic>;
    final firstPost = posts[0] as Map<String, dynamic>;
    return Post.fromJson(firstPost);
  }
}
