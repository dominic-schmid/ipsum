This package will generate [Lorem ipsum](https://en.wikipedia.org/wiki/Lorem_ipsum) text for your applications.
By default, it takes its source text from Cicero's [De finibus bonorum et malorum](https://en.wikipedia.org/wiki/De_finibus_bonorum_et_malorum), but you can specify your own source text if you want.

You can select:

- words
- sentences
- paragraphs

Since this uses the base dart libraries it should also work on every platform.

## Features

You can `enable` and `disable` the first 5 words being "Lorem ipsum dolor sit amet" by toggling `startWithLorem` (defaults to `false`).

You can also pass a custom set of delimiters to delimit sentences and paragraphs (defaults to `. ? !`).

## Usage

```dart
import 'package:ipsum/ipsum.dart';

// Create an instance
Ipsum lip = Ipsum();

String words = lip.words(4);
/// Illaeffectrix beatae vitae sapientia

String sentences = lip.sentences(1);
/// Igitur, inquam, res tamdissimiles eodem nomine appellas?

String paragraphs = lip.paragraphs(1);
/// Utilitatem referantur, virum bonum non posse reperiri deque his rebus satis multa in nostris ...

```

## Credits

This package was inspired by the python library [lipsum](https://github.com/thanethomson/lipsum).
