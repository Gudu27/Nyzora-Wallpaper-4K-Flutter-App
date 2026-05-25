import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final connectivityServiceProvider = Provider<ConnectivityService>((ref) {
  return ConnectivityService();
});

final connectivityStatusProvider = StreamProvider<bool>((ref) {
  final service = ref.watch(connectivityServiceProvider);
  return service.onConnectivityChanged;
});

final isConnectedProvider = Provider<bool>((ref) {
  return ref.watch(connectivityStatusProvider).maybeWhen(
        data: (connected) => connected,
        orElse: () => true,
      );
});

class ConnectivityService {
  ConnectivityService() : _connectivity = Connectivity();

  final Connectivity _connectivity;
  bool _lastConnected = true;

  Stream<bool> get onConnectivityChanged async* {
    final initial = await _connectivity.checkConnectivity();
    _lastConnected = _isConnected(initial);
    yield _lastConnected;

    await for (final result in _connectivity.onConnectivityChanged) {
      _lastConnected = _isConnected(result);
      yield _lastConnected;
    }
  }

  Future<bool> checkConnectivity() async {
    final result = await _connectivity.checkConnectivity();
    _lastConnected = _isConnected(result);
    return _lastConnected;
  }

  bool get lastConnected => _lastConnected;

  bool _isConnected(dynamic result) {
    if (result is List<ConnectivityResult>) {
      return result.any((r) => r != ConnectivityResult.none);
    }
    if (result is ConnectivityResult) {
      return result != ConnectivityResult.none;
    }
    return true;
  }
}
