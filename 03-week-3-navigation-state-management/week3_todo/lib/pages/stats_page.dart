import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// --- ASYNC NOTIFIER & PROVIDER ---
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

// --- UI (STATS PAGE) ---
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