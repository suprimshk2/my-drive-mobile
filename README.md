# create env
  - create .env, .env.dev, .env.qa and .env.prod

# android
  - run 
    - flutter run --flavor dev (i.e, dev, qa, uat, prod)

  - generate apk
    - flutter build apk --flavor=myswaddle --dart-define=FLAVOR=myswaddle (i.e, qa,dev,prod)
      - flutter build apk --flavor=mydrivenepal --dart-define=FLAVOR=mydrivenepal --debug
  - generate aab
    - flutter build appbundle --flavor=mydrivenepal --dart-define=FLAVOR=mydrivenepal --release(i.e, qa,dev,prod)

# ios
  - run
    - flutter run --dart-define=FLAVOR=dev (replace env accordingly i.e qa, dev prod)
    
  - while archiving or running from xcode, must run this command after changing the schema "flutter clean && flutter pub get && cd ios && pod install" or it will not clear the previous environment

  - flutter clean && flutter pub get && cd ios && pod install

# for notification, Add this in AppDelegate.swift
if #available(iOS 10.0, *) {
  UNUserNotificationCenter.current().delegate = self as? UNUserNotificationCenterDelegate
}