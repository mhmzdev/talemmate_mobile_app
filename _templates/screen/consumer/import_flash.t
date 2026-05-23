---
inject: true
before: part
to: "lib/ui/screens/<%= h.changeCase.snake(name) %>/<%= h.changeCase.snake(name) %>.dart"
skip_if: taleemmate/utils/flash.dart
---
import 'package:taleemmate/utils/flash.dart';
