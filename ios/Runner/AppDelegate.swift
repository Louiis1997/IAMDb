
import UIKit
import Flutter
import GoogleMaps
#import "ReactNativeConfig.h"

@UIApplicationMain
@objc class AppDelegate: FlutterAppDelegate {
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {

    // Add your Google Maps API Key here
    NSString *mapsApiKey = [ReactNativeConfig envFor:@"GOOGLE_MAPS_API_KEY"];
    [GMSServices provideAPIKey: mapsApiKey];

    GeneratedPluginRegistrant.register(with: self)

    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }
}
