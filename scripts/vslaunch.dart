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

  final devices = filteredDevices.map((array) {
    final name = array[0].trim();
    final deviceId = array[1].trim();
    final obj = <String, dynamic>{
      'name': name,
      'deviceId': deviceId,
      'type': 'dart',
      'request': 'launch',
      'program': 'lib/main.dart',
      'args': ['--flavor', 'stage'],
    };

    return obj;
  });

  final newConfig = <String, dynamic>{
    'version': '1.0.0',
    'configurations': ([
      {
        'name': 'Flutter',
        'request': 'launch',
        'type': 'dart',
      },
      ...devices,
    ]),
    'compounds': [
      {
        'name': 'current',
        'configurations': devices.map((obj) => obj['name']).toList(),
      },
    ],
  };

  utils.mkDir('.vscode');
  final vsConfig = File('.vscode/launch.json');
  // final encoded = json.encode(newConfig);
  const jsonEncoder = JsonEncoder.withIndent('  ');
  final newJson = jsonEncoder.convert(newConfig);

  vsConfig.writeAsStringSync(newJson);

  print(devices.toString());
}
