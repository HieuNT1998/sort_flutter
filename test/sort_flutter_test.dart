import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sort_flutter/sort_flutter.dart';

void main() {
  const MethodChannel channel = MethodChannel('sort_flutter');

  TestWidgetsFlutterBinding.ensureInitialized();

  setUp(() {
    channel.setMockMethodCallHandler((MethodCall methodCall) async {
      return '42';
    });
  });

  tearDown(() {
    channel.setMockMethodCallHandler(null);
  });
}
