abstract class NetworkInfo {
  /// Returns `true` if the device has an active internet connection.
  Future<bool> get isConnected;
}
