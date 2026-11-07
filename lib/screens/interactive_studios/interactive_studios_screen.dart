import 'dart:async';

import 'package:flutter/material.dart';
import 'package:unified_math_tutor/l10n/app_localizations.dart';
import 'package:unified_math_tutor/models/companion_app.dart';
import 'package:unified_math_tutor/services/football_studio_platform.dart';

class InteractiveStudiosScreen extends StatefulWidget {
  const InteractiveStudiosScreen({super.key, this.platform});

  final FootballStudioPlatform? platform;

  @override
  State<InteractiveStudiosScreen> createState() =>
      _InteractiveStudiosScreenState();
}

class _InteractiveStudiosScreenState extends State<InteractiveStudiosScreen> {
  late final FootballStudioCompanionService _service;
  var _app = CompanionApp.footballStudio;
  var _launchFailed = false;
  var _launching = false;

  @override
  void initState() {
    super.initState();
    _service = FootballStudioCompanionService(
      widget.platform ?? const MethodChannelFootballStudioPlatform(),
    );
    unawaited(_loadAvailability());
  }

  Future<void> _refreshAvailability() async {
    setState(() {
      _app = _app.withAvailability(CompanionAvailability.checking);
      _launchFailed = false;
    });
    await _loadAvailability();
  }

  Future<void> _loadAvailability() async {
    final availability = await _service.checkAvailability();
    if (!mounted) return;
    setState(() {
      _app = _app.withAvailability(availability);
    });
  }

  Future<void> _openFootballStudio() async {
    setState(() {
      _launching = true;
      _launchFailed = false;
    });
    final result = await _service.launch();
    if (!mounted) return;
    setState(() {
      _launching = false;
      switch (result) {
        case CompanionLaunchResult.launched:
          _app = _app.withAvailability(CompanionAvailability.installed);
        case CompanionLaunchResult.unavailable:
          _app = _app.withAvailability(CompanionAvailability.notInstalled);
        case CompanionLaunchResult.unsupported:
          _app = _app.withAvailability(CompanionAvailability.unsupported);
        case CompanionLaunchResult.failed:
          _launchFailed = true;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final availability = _app.availability;
    final canLaunch = availability == CompanionAvailability.installed;

    return Scaffold(
      appBar: AppBar(title: Text(l10n.interactiveStudiosTitle)),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          Card(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      const Icon(Icons.sports_soccer_outlined, size: 28),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          _app.title,
                          style: Theme.of(context).textTheme.titleLarge,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Text(l10n.footballStudioDescription),
                  const SizedBox(height: 16),
                  _AvailabilityMessage(
                    availability: availability,
                    launchFailed: _launchFailed,
                  ),
                  const SizedBox(height: 12),
                  if (_launchFailed)
                    OutlinedButton(
                      onPressed: _launching ? null : _openFootballStudio,
                      child: Text(l10n.footballStudioTryAgain),
                    )
                  else if (canLaunch)
                    FilledButton.icon(
                      onPressed: _launching ? null : _openFootballStudio,
                      icon: const Icon(Icons.open_in_new),
                      label: Text(
                        _launching
                            ? l10n.footballStudioOpening
                            : l10n.footballStudioOpen,
                      ),
                    )
                  else if (availability == CompanionAvailability.notInstalled)
                    Text(
                      l10n.footballStudioInstallNeeded,
                      style: Theme.of(context).textTheme.bodyMedium,
                    )
                  else if (availability == CompanionAvailability.checkFailed)
                    OutlinedButton(
                      onPressed: _refreshAvailability,
                      child: Text(l10n.footballStudioCheckAgain),
                    ),
                  if (availability == CompanionAvailability.checking)
                    const Padding(
                      padding: EdgeInsets.symmetric(vertical: 8),
                      child: LinearProgressIndicator(),
                    ),
                  const SizedBox(height: 20),
                  Text(
                    l10n.footballStudioProgressOwnership,
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _AvailabilityMessage extends StatelessWidget {
  const _AvailabilityMessage({
    required this.availability,
    required this.launchFailed,
  });

  final CompanionAvailability availability;
  final bool launchFailed;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final message = switch (availability) {
      CompanionAvailability.checking => l10n.footballStudioChecking,
      CompanionAvailability.installed => l10n.footballStudioInstalled,
      CompanionAvailability.notInstalled => l10n.footballStudioUnavailable,
      CompanionAvailability.unsupported => l10n.footballStudioAndroidOnly,
      CompanionAvailability.checkFailed => l10n.footballStudioCheckFailed,
    };
    final displayedMessage =
        launchFailed ? l10n.footballStudioLaunchFailed : message;
    return Semantics(liveRegion: true, child: Text(displayedMessage));
  }
}
