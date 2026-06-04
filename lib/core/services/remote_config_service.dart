import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:get/get.dart';

import '../constants/remote_config_keys.dart';
import 'debug_logger.dart';

class RemoteConfigService extends GetxService {
  RemoteConfigService({required FirebaseRemoteConfig remoteConfig})
    : _remoteConfig = remoteConfig;

  final FirebaseRemoteConfig _remoteConfig;

  Future<RemoteConfigService> init() async {
    await _remoteConfig.setConfigSettings(
      RemoteConfigSettings(
        fetchTimeout: const Duration(seconds: 15),
        minimumFetchInterval: const Duration(hours: 1),
      ),
    );
    await _remoteConfig.setDefaults(const {
      RemoteConfigKeys.feedPageSize: 20,
      RemoteConfigKeys.enableAds: true,
      RemoteConfigKeys.enablePremiumPaywall: true,
      RemoteConfigKeys.enableNotifications: true,
    });
    await _remoteConfig.fetchAndActivate();
    DebugLogger.logInfo(
      module: 'RemoteConfig',
      className: 'RemoteConfigService',
      method: 'init',
      message: 'Remote config initialized',
      additionalDetails: {
        RemoteConfigKeys.feedPageSize: _remoteConfig.getInt(
          RemoteConfigKeys.feedPageSize,
        ),
        RemoteConfigKeys.enableAds: _remoteConfig.getBool(
          RemoteConfigKeys.enableAds,
        ),
        RemoteConfigKeys.enablePremiumPaywall: _remoteConfig.getBool(
          RemoteConfigKeys.enablePremiumPaywall,
        ),
        RemoteConfigKeys.enableNotifications: _remoteConfig.getBool(
          RemoteConfigKeys.enableNotifications,
        ),
      },
    );
    return this;
  }

  int getInt(String key) => _remoteConfig.getInt(key);
  bool getBool(String key) => _remoteConfig.getBool(key);
  String getString(String key) => _remoteConfig.getString(key);
}
