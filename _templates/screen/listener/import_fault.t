---
inject: true
before: part
to: "lib/ui/screens/<%= h.changeCase.snake(name) %>/<%= h.changeCase.snake(name) %>.dart"
skip_if: taleemmate/services/fault/faults.dart
---
import 'package:taleemmate/services/fault/faults.dart';
