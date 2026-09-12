import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// --- 1. APP ENTRY POINT ---
void main() {
  // ProviderScope is mandatory for Riverpod to function
  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Mission Stats',
      theme: ThemeData(
        colorSchemeSeed: Colors.teal, 
        useMaterial3: true,
      ),
      home: const StatsPage(), 
    );
  }
}

// --- 2. ASYNC NOTIFIER & PROVIDER ---
class StatsNotifier extends AsyncNotifier<List<String>> {
  @override
  Future<List<String>> build() async {
    // 2-second loading simulation
    await Future.delayed(const Duration(seconds: 2));

    // ~30% failure simulation
    final random = Random().nextDouble();
    if (random < 0.3) {
      throw Exception('Server overloaded. Target missed.');
    }

    // Success state data
    return [
      'Accuracy: 98.5%',
      'Targets Eliminated: 14',
      'Remaining Time: 02:45',
    ];
  }
}

final statsProvider = AsyncNotifierProvider<StatsNotifier, List<String>>(
  StatsNotifier.new,
);

// --- 3. UI (STATS PAGE) ---
class StatsPage extends ConsumerWidget {
  const StatsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final asyncStats = ref.watch(statsProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Mission Statistics')),
      body: asyncStats.when(
        loading: () => const Center(
          child: CircularProgressIndicator(),
        ),
        error: (error, stackTrace) => Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('Mission Failed: $error'),
              const SizedBox(height: 16),
              FilledButton(
                onPressed: () => ref.invalidate(statsProvider),
                child: const Text('Retry Mission'),
              ),
            ],
          ),
        ),
        data: (stats) => ListView.builder(
          itemCount: stats.length,
          itemBuilder: (context, index) {
            return ListTile(
              leading: const Icon(Icons.track_changes, color: Colors.teal),
              title: Text(stats[index]),
            );
          },
        ),
      ),
    );
  }
}