import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mission_stats/main.dart'; 

void main() {
  test('StatsNotifier initial state is loading and completes properly', () async {
    // 1. Initialize the Riverpod environment for testing
    final container = ProviderContainer();
    addTearDown(container.dispose); 

    // 2. Synchronously check the initial state is loading
    expect(
      container.read(statsProvider),
      const AsyncValue<List<String>>.loading(),
    );

    // 3. Await the future to test the resolution (Success or Error)
    try {
      final result = await container.read(statsProvider.future);
      expect(result.length, 3);
      expect(result, isA<List<String>>());
    } catch (e) {
      expect(e, isA<Exception>());
      expect(e.toString(), contains('Server overloaded'));
    }
  });
}