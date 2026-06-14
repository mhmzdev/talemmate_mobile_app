// ignore_for_file: unused_element

part of 'quotes_repo.dart';

class _QuotesMocks {
  static Future<List> today() {
    return Future.value([
      {
        'q': 'Anger begins with folly, and ends with repentance.',
        'a': 'Beverly Sills',
        'i': 'https://zenquotes.io/img/beverly-sills.jpg',
        'h':
            '<blockquote>&ldquo;Anger begins with folly, and ends with repentance.&rdquo; &mdash; <footer>Beverly Sills</footer></blockquote>',
        'date': '2026-06-14',
      },
    ]);
  }
}
