import 'package:flutter/foundation.dart';

import '../models/practice_context.dart';

class PracticeContextService {
  PracticeContextService._();
  static final PracticeContextService instance = PracticeContextService._();

  final ValueNotifier<PracticeContext?> notifier = ValueNotifier(null);

  PracticeContext? get current => notifier.value;

  void set(PracticeContext ctx) => notifier.value = ctx;
  void clear() => notifier.value = null;
}
