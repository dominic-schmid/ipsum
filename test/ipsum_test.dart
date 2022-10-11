import 'package:flutter_test/flutter_test.dart';

import 'package:ipsum/ipsum.dart';

void main() {
  test('Receive 10 words', () {
    String words = Ipsum().words(10);
    expect(10, words.split(' ').length);
  });
}
