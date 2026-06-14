part of 'api.dart';

final class URLs {
  static String get base {
    if (AppFlavor.isStage) {
      return 'https://zenquotes.io/api';

      /// This is just for demonstration when there are multiple environments of
      /// the same API (e.g. staging, production, etc.)
      // return 'https://staging.zenquotes.io/api';
    }

    return 'https://zenquotes.io/api';
  }
}
