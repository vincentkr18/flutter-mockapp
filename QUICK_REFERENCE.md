# Quick Configuration Reference

## 🔑 Required Credentials Checklist

### 1. Supabase Credentials
- [ ] Supabase URL
- [ ] Supabase Anon Key
- [ ] Web redirect URI configured: `https://[project].supabase.co/auth/v1/callback`

### 2. Google OAuth Credentials
- [ ] Web Client ID (used in code as `serverClientId`)
- [ ] Web Client Secret (configured in Supabase, NOT in code)
- [ ] iOS Client ID (used in code as `clientId` for iOS)
- [ ] iOS Bundle ID matches OAuth client
- [ ] Android Package Name matches OAuth client
- [ ] Android SHA-1 fingerprint added to OAuth client

---

## 📝 Configuration Checklist

### Files to Update:

#### 1. lib/config/env_config.dart
```dart
supabaseUrl = 'https://YOUR_PROJECT.supabase.co'
supabaseAnonKey = 'YOUR_ANON_KEY'
googleWebClientId = 'YOUR_WEB_CLIENT_ID.apps.googleusercontent.com'
googleIosClientId = 'YOUR_IOS_CLIENT_ID.apps.googleusercontent.com'
```

#### 2. ios/Runner/Info.plist (Line ~52)
```xml
<!-- Reverse your iOS Client ID -->
<string>com.googleusercontent.apps.YOUR_IOS_CLIENT_NUMBER</string>
```

**Example:**
- iOS Client ID: `123456-abc.apps.googleusercontent.com`
- Reversed: `com.googleusercontent.apps.123456-abc`

#### 3. android/app/src/main/AndroidManifest.xml (Line ~33)
```xml
<data
    android:scheme="https"
    android:host="YOUR_PROJECT.supabase.co" />
```

---

## 🔄 Google OAuth Client Types Explained

### Web Client
- **Where**: Google Cloud Console → Credentials → Web application
- **Used for**: Token validation on Supabase
- **In code**: Set as `serverClientId` in both iOS and Android
- **Client Secret**: Configured in Supabase (never in Flutter code)
- **Redirect URI**: `https://[project].supabase.co/auth/v1/callback`

### iOS Client
- **Where**: Google Cloud Console → Credentials → iOS
- **Used for**: iOS native authentication
- **In code**: Set as `clientId` for iOS platform only
- **Bundle ID**: Must match your app's bundle identifier
- **Reversed ID**: Used in Info.plist for URL scheme

### Android Client
- **Where**: Google Cloud Console → Credentials → Android
- **Used for**: Android native authentication
- **In code**: NOT used (auto-matched via SHA-1)
- **Package Name**: Must match your app's package name
- **SHA-1**: Required for client validation

---

## 🎯 Quick Commands

### Get SHA-1 Fingerprint (Android):
```bash
cd android
./gradlew signingReport
```

### Install Dependencies:
```bash
flutter pub get
```

### Run on iOS:
```bash
flutter run -d iphone
```

### Run on Android:
```bash
flutter run -d emulator
```

### Clean Build:
```bash
flutter clean
flutter pub get
flutter run
```

---

## ⚠️ Common Mistakes to Avoid

1. ❌ Using Android Client ID in code (it's auto-detected)
2. ❌ Putting Client Secret in Flutter code
3. ❌ Wrong reversed iOS Client ID in Info.plist
4. ❌ Missing SHA-1 fingerprint for Android
5. ❌ Bundle ID / Package Name mismatch
6. ❌ Not updating Supabase URL in AndroidManifest.xml
7. ❌ Forgetting to enable Google provider in Supabase

---

## ✅ Verification Steps

### Before Running:
1. [ ] All credentials updated in `env_config.dart`
2. [ ] iOS reversed client ID updated in Info.plist
3. [ ] Android Supabase URL updated in AndroidManifest.xml
4. [ ] Bundle ID matches Google Console (iOS)
5. [ ] Package name matches Google Console (Android)
6. [ ] SHA-1 added to Android OAuth client
7. [ ] Google provider enabled in Supabase
8. [ ] Web redirect URI added to Google Console
9. [ ] Web Client ID/Secret added to Supabase
10. [ ] Dependencies installed (`flutter pub get`)

### Test Flow:
1. [ ] App launches without config error
2. [ ] Login screen shows
3. [ ] Click "Sign in with Google"
4. [ ] Google account picker appears
5. [ ] Select account successfully
6. [ ] Navigate to home screen
7. [ ] User info displays correctly
8. [ ] Profile picture loads
9. [ ] Sign out works
10. [ ] Re-login shows account picker
11. [ ] App restart preserves session

---

## 🔗 Quick Links

- **Supabase Dashboard**: https://app.supabase.com/
- **Google Cloud Console**: https://console.cloud.google.com/
- **OAuth Consent Screen**: https://console.cloud.google.com/apis/credentials/consent
- **Credentials**: https://console.cloud.google.com/apis/credentials

---

## 📞 Getting Help

If something doesn't work:

1. Check the detailed [GOOGLE_AUTH_SETUP.md](GOOGLE_AUTH_SETUP.md) guide
2. Review Supabase auth logs
3. Check Flutter console for error messages
4. Verify all checklist items above
5. Ensure OAuth clients are correctly configured

---

**Last Updated**: January 2026
