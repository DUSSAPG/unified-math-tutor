import 'package:flutter/foundation.dart';

import '../../services/locale_service.dart';
import '../config/build_flags.dart';
import 'market_store.dart';

class MarketSmoke {
  const MarketSmoke._();

  static Future<void> printStartupState({MarketStore? store}) async {
    if (!kDebugMode) return;

    final marketStore = store ?? MarketStore();
    await marketStore.init();
    final selection = await marketStore.load(
      deviceLocale: LocaleService.instance.current,
    );
    debugPrint(
      'Startup market=${selection?.uiMarketId ?? 'unset'} '
      'canton=${selection?.selectedCanton?.id ?? 'unset'} '
      'locale=${LocaleService.instance.current} '
      'ENABLE_CH_PACKS=${BuildFlags.enableChPacks}',
    );
  }
}
