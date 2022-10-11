library ipsum;

import 'dart:io';
import 'dart:convert';
import 'dart:math';

/// A helper class for the lorem ipsum generation.
/// It reads lines from a [file] and randomly selects the needed output from it.
///
/// You can set whether or not the first words should be `Lorem ipsum dolor sit amet` with [startWithLorem]
///
/// By default, sentences and paragraphs are delimited with `{".", "?", "!"}`. Change these with [sentenceDelimiters]
///
/// You can also provide an [encoding] which will be used when opening the file for the initial read
class Ipsum {
  final List<String> _lorem = ["Lorem", "ipsum", "dolor", "sit", "amet"];

  /// Contains all the lines read from the [file] on creation of the [Ipsum] object
  Iterable<String> _lines = [];

  /// Defaults to `utf8`
  final Encoding encoding;

  /// Defaults to `false`
  final bool startWithLorem;

  /// By default, sentences and paragraphs are delimited with `{".", "?", "!"}`.
  Set<String> sentenceDelimiters = {};

  Ipsum({
    this.startWithLorem = false,
    this.encoding = utf8,
    File? file,
    Set<String>? sentenceDelimiters,
  }) {
    this.sentenceDelimiters = sentenceDelimiters ?? {".", "?", "!"};

    /// Reads the given number of words from the specified open file.
    file ??= File.fromUri(Uri.parse('package:ipsum/lib/assets/definibus.txt'));
    _lines = file.readAsLinesSync(encoding: encoding).map((e) => e.trim());
  }

  /// Prepares and cleans up the given string
  String _prepString(String s, {bool delimit = true}) {
    if (s.length <= 1) return s;

    // replace any double-spaces with single ones
    String result = s.trim().replaceAll("  ", " ");
    // capitalise the first letter of the string
    result = result.replaceRange(0, 1, result[0].toUpperCase());
    // ensure a sentence delimiter at the end of the string
    if (!sentenceDelimiters.contains(result[result.length - 1]) && delimit) {
      result = result.substring(0, result.length - 1) +
          sentenceDelimiters
              .elementAt(Random().nextInt(sentenceDelimiters.length));
    }
    return result;
  }

  /// Read [count] words from the specified file
  ///
  /// If [startWithLorem] is set to `true`, the first words will be replaced
  ///
  /// The words are not delimited
  String words([int count = 100]) {
    final List<String> result = [];

    while (result.length < count) {
      String line = _lines.elementAt(Random().nextInt(_lines.length));
      // trim and remove empty words
      Iterable<String> words =
          line.split(" ").map((e) => e.trim()).where((word) => word.isNotEmpty);

      if (result.length + words.length > count) {
        result.addAll(words.take(count - result.length));
      } else {
        result.addAll(words);
      }
    }

    /// replace as many first chars as possible with the defined lorem ones
    if (startWithLorem) {
      int until = result.length < _lorem.length ? result.length : _lorem.length;
      result.replaceRange(
        0,
        until,
        _lorem.take(until),
      );
    }

    return _prepString(result.join(" "), delimit: false);
  }

  /// Read [count] sentences from the specified file
  ///
  /// If [startWithLorem] is set to `true`, the first words will be replaced
  ///
  /// The sentences are delimited using a random of the specified [sentenceDelimiters]
  String sentences([int count = 5]) {
    final List<String> result = [];
    String curSentence = "";

    while (result.length < count) {
      String line = _lines.elementAt(Random().nextInt(_lines.length)).trim();
      if (line.isEmpty) continue;

      for (String c in line.split('')) {
        curSentence += c;
        if (sentenceDelimiters.contains(c)) {
          result.add(_prepString(curSentence));
          curSentence = "";
          if (result.length >= count) break;
        }
      }
    }

    /// replace as many first words of the sentence as possible with the defined lorem ones
    if (startWithLorem && result.isNotEmpty) {
      List<String> firstWords = result.first.split(' ');
      firstWords.replaceRange(
        0,
        result.length < _lorem.length ? result.length : _lorem.length,
        _lorem,
      );
      result.first = firstWords.join(" ");
    }

    return result.join(" ");
  }

  /// Read [count] paragraphs from the specified file
  ///
  /// If [startWithLorem] is set to `true`, the first words will be replaced
  ///
  /// The paragraphs are delimited using a random of the specified [sentenceDelimiters]
  String paragraphs([int count = 3]) {
    final List<String> result = [];
    String curParagraph = "";
    String lastLine = "";

    while (result.length < count) {
      String line = _lines.elementAt(Random().nextInt(_lines.length)).trim();

      // if we've hit the end of a paragraph
      if (lastLine.length > 1 && line.isEmpty /*line == "\n"*/) {
        result.add(_prepString(curParagraph));
        curParagraph = "";
      } else if (line.length > 1) {
        // if we're still building the current paragraph
        /// replace as many first words of the paragraph as possible with the defined lorem ones, but only if this is the first paragraph
        if (startWithLorem && result.isEmpty && curParagraph.isEmpty) {
          List<String> firstWords = line.split(' ');
          firstWords.replaceRange(
            0,
            line.length < _lorem.length ? line.length : _lorem.length,
            _lorem,
          );
          line = firstWords.join(" ");
        }
        curParagraph += line;
      }

      lastLine = line;
    }

    return result.join("\n\n");
  }
}
