import 'package:regexpattern/regexpattern.dart';
import 'package:markdown/markdown.dart' as md;

class AutoLinker extends md.InlineSyntax {
  AutoLinker() : super(RegexPattern.uri);

  @override
  bool onMatch(md.InlineParser parser, Match match) {
    final String? url = match[0];
    if (url != null) {
      parser.addNode(md.Element.text('a', url));
    }
    return true;
  }
}
