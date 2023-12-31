import 'package:cinemapedia/presentation/providers/providers.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final initialLoadingProvider = Provider<bool>((ref) {
  final step1 = ref.watch(topRatedMoviesProvider).isEmpty;
  final step2 = ref.watch(upcomingMoviesProvider).isEmpty;
  final step3 = ref.watch(nowPlayinMoviesProvider).isEmpty;

  if (step1 || step2 || step3) return true;

  return false;
});
