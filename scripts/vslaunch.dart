// ignore_for_file: avoid_print

import 'dart:convert';
import 'dart:io';

import 'utils.dart' as utils;

const List<String> excludedPlatforms = ['linux', 'windows', 'macos', 'chrome', 'edge'];

void main(List<String> args) async {
  final result =
      await Process.run(
        'flutter',
        ['devices'],
        runInShell: Platform.isWindows,
      ).catchError((err) {
        print(err.toString());
        return err;
      });
  final List<String> raw = result.stdout.split('\n');
  final splitter = Platform.isWindows ? 'â€¢' : '•';

  final filteredDevices = raw
      .map((String unparsed) => unparsed.split(splitter))
      .toList()
      .where((subList) => subList.length > 1)
      .where((subList) => !excludedPlatforms.contains(subList[1].trim()));

  final deviceList = filteredDevices.toList();

  Map<String, dynamic> configFor(
    List<String> array, {
    required String name,
    required String program,
  }) {
    return <String, dynamic>{
      'name': name,
      'deviceId': array[1].trim(),
      'type': 'dart',
      'request': 'launch',
      'program': program,
      'args': ['--flavor', 'stage'],
    };
  }

  // Normal launch — one per device.
  final runConfigs = deviceList
      .map((array) => configFor(array, name: array[0].trim(), program: 'lib/main.dart'))
      .toList();

  // Driver-enabled launch — `test_driver/app.dart` calls
  // enableFlutterDriverExtension() so the Dart MCP server can drive the app
  // (tap/type/navigate). Debug only; never used by release builds.
  final driverConfigs = deviceList
      .map(
        (array) => configFor(
          array,
          name: 'Driver (MCP) — ${array[0].trim()}',
          program: 'test_driver/app.dart',
        ),
      )
      .toList();

  final newConfig = <String, dynamic>{
    'version': '1.0.0',
    'configurations': ([
      {
        'name': 'Flutter',
        'request': 'launch',
        'type': 'dart',
      },
      ...runConfigs,
      ...driverConfigs,
    ]),
    'compounds': [
      {
        'name': 'current',
        'configurations': runConfigs.map((obj) => obj['name']).toList(),
      },
    ],
  };

  utils.mkDir('.vscode');
  final vsConfig = File('.vscode/launch.json');
  // final encoded = json.encode(newConfig);
  const jsonEncoder = JsonEncoder.withIndent('  ');
  final newJson = jsonEncoder.convert(newConfig);

  vsConfig.writeAsStringSync(newJson);

  print('Generated ${runConfigs.length} run + ${driverConfigs.length} driver config(s).');
}
