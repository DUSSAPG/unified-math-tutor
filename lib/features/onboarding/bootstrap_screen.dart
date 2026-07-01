import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../core/market/market_store.dart';

class BootstrapScreen extends StatefulWidget {
  final MarketStore store;
  const BootstrapScreen({super.key, required this.store});

  @override
  State<BootstrapScreen> createState() => _BootstrapScreenState();
}

class _BootstrapScreenState extends State<BootstrapScreen> {
  @override
  void initState() {
    super.initState();
    _loadAndRoute();
  }

  Future<void> _loadAndRoute() async {
    final selection = await widget.store.load();
    if (!mounted) return;

    if (selection == null) {
      _routeTo('/choose-market');
    } else {
      _routeTo('/welcome');
    }
  }

  void _routeTo(String location) {
    final router = GoRouter.maybeOf(context);
    if (router != null) {
      router.go(location);
    } else {
      Navigator.of(context).pushReplacementNamed(location);
    }
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(child: CircularProgressIndicator()),
    );
  }
}
