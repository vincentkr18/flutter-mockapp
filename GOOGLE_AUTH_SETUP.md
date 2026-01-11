# Google OAuth Authentication Setup Guide

This guide will help you configure and run the Google OAuth authentication system with Supabase.

## ✅ Implementation Complete

All code has been implemented. Here's what was created:

### Files Created/Modified:
1. ✅ `pubspec.yaml` - Added dependencies
2. ✅ `lib/config/env_config.dart` - Environment configuration
3. ✅ `lib/main.dart` - Supabase initialization & auth gate
4. ✅ `lib/services/auth_service.dart` - Authentication service
5. ✅ `lib/screens/login_screen.dart` - Google Sign-In UI
6. ✅ `lib/screens/home_screen.dart` - User dashboard
7. ✅ `ios/Runner/Info.plist` - iOS configuration
8. ✅ `android/app/build.gradle` - Android SDK config
9. ✅ `android/app/src/main/AndroidManifest.xml` - Android permissions

---

## 📋 Setup Instructions

### Step 1: Install Dependencies

Run the following command to install the required packages:

```bash
flutter pub get
```

### Step 2: Configure Environment Variables

Open `lib/config/env_config.dart` and replace the placeholder values with your actual credentials:

```dart
class EnvConfig {
  // Replace with your actual Supabase URL
  static const String supabaseUrl = 'https://yourproject.supabase.co';
  
  // Replace with your actual Supabase Anon Key
  static const String supabaseAnonKey = 'your_supabase_anon_key_here';

  // Replace with your actual Google Web Client ID
  static const String googleWebClientId = '123456789-web.apps.googleusercontent.com';
  
  // Replace with your actual Google iOS Client ID
  static const String googleIosClientId = '123456789-ios.apps.googleusercontent.com';
  
  // Android Client ID (for reference only - not used in code)
  static const String googleAndroidClientId = '123456789-android.apps.googleusercontent.com';
}
```

**Where to find these values:**
- **Supabase URL & Anon Key**: Supabase Dashboard → Settings → API
- **Google Client IDs**: Google Cloud Console → APIs & Services → Credentials

### Step 3: Configure iOS

Open `ios/Runner/Info.plist` and update the reversed iOS Client ID:

1. Take your iOS Client ID: `123456789-ios456.apps.googleusercontent.com`
2. Reverse it to: `com.googleusercontent.apps.123456789-ios456`
3. Replace the placeholder in Info.plist (line 52):

```xml
<string>com.googleusercontent.apps.123456789-ios456</string>
```

**How to get reversed client ID:**
- If your iOS Client ID is: `123456789-abc.apps.googleusercontent.com`
- Reversed version is: `com.googleusercontent.apps.123456789-abc`

### Step 4: Configure Android

Open `android/app/src/main/AndroidManifest.xml` and update the Supabase URL (line 33):

```xml
<data
    android:scheme="https"
    android:host="yourproject.supabase.co" />
```

Replace `yourproject` with your actual Supabase project ID.

### Step 5: Update Bundle ID / Package Name (If Different)

If your bundle ID is different from `com.testingapp.flutter_login_app`, update:

**iOS:**
1. Open `ios/Runner.xcodeproj/project.pbxproj`
2. Search for `PRODUCT_BUNDLE_IDENTIFIER`
3. Update to match your iOS OAuth client bundle ID

**Android:**
1. Open `android/app/build.gradle`
2. Update `applicationId` to match your Android OAuth client package name

### Step 6: Get SHA-1 Fingerprint for Android (If Not Done)

Run this command to get your SHA-1 fingerprint:

**Debug keystore:**
```bash
cd android
./gradlew signingReport
```

**Windows:**
```powershell
cd android
.\gradlew.bat signingReport
```

Copy the SHA-1 fingerprint and add it to your Android OAuth client in Google Cloud Console.

---

## 🚀 Running the App

### Run on iOS Simulator:
```bash
flutter run -d iphone
```

### Run on Android Emulator:
```bash
flutter run -d emulator
```

### Run on Physical Device:
```bash
flutter devices  # List available devices
flutter run -d <device-id>
```

---

## 🔍 Testing Scenarios

### ✅ What to Test:

1. **First Launch**
   - App should show login screen
   - Click "Sign in with Google"
   - Should show Google account picker
   - Select account and authenticate
   - Should navigate to home screen showing user info

2. **Sign Out**
   - Click sign out button on home screen
   - Confirm sign out
   - Should return to login screen

3. **Re-login**
   - Click "Sign in with Google" again
   - Should show account picker (forced to select account)
   - After selecting account, navigate to home

4. **App Restart with Session**
   - Close and reopen app
   - Should automatically show home screen (session persisted)

5. **Pull to Refresh**
   - On home screen, pull down to refresh user data
   - Should show "Refreshed" message

6. **Network Error**
   - Turn off internet
   - Try to sign in
   - Should show error message

7. **Cancel Sign-In**
   - Click "Sign in with Google"
   - Cancel the Google account picker
   - Should return to login screen without errors

---

## 📱 Platform-Specific Notes

### iOS:
- Minimum iOS version: 13.0
- URL scheme is required for OAuth callback
- Uses iOS Client ID for authentication
- Web Client ID used for server validation

### Android:
- Minimum SDK: 21 (Android 5.0)
- No client ID needed in code (uses SHA-1 matching)
- Web Client ID used for server validation
- Deep linking configured for OAuth callback

---

## 🐛 Troubleshooting

### "Configuration Error" appears on launch:
- Check that you've updated `lib/config/env_config.dart` with real values
- Make sure URLs don't contain 'yourproject' or 'your_supabase'

### Google Sign-In fails with "Developer Error":
**iOS:**
- Verify reversed client ID in Info.plist matches your iOS Client ID
- Check bundle ID matches the one in Google Cloud Console

**Android:**
- Verify SHA-1 fingerprint is added to Google Cloud Console
- Check package name matches in build.gradle and Google Console
- Ensure you're using the debug keystore for debug builds

### "Invalid Grant" or Token errors:
- Make sure Web Client ID is correctly set as `serverClientId`
- Verify Supabase Google provider is enabled with correct Web Client ID/Secret
- Check redirect URI in Google Console: `https://yourproject.supabase.co/auth/v1/callback`

### Account picker doesn't appear:
- Check that `signOut()` is called before `signIn()` in auth_service.dart
- This forces the account picker to show every time

### Session not persisting:
- Verify `persistSession: true` in main.dart Supabase initialization
- Check device/emulator storage permissions

### Deep linking not working (Android):
- Verify AndroidManifest.xml has correct Supabase host URL
- Check `android:autoVerify="true"` is present

---

## 🔐 Security Best Practices

### ✅ Implemented:
- ✅ PKCE flow for mobile apps
- ✅ Auto token refresh
- ✅ Session persistence
- ✅ Force account picker on each login
- ✅ No client secrets in code
- ✅ Proper error handling

### 🔒 For Production:

1. **Use Environment Variables**
   - Consider using `flutter_dotenv` package
   - Create `.env` file (add to `.gitignore`)
   - Never commit credentials to version control

2. **Update OAuth Consent Screen**
   - Add logo, privacy policy, terms of service
   - Verify domain ownership
   - Request verification if needed

3. **Enable Additional Security**
   - Enable RLS (Row Level Security) in Supabase
   - Add rate limiting
   - Configure CORS properly
   - Use production keystores for Android

4. **Monitor Usage**
   - Check Supabase auth logs
   - Monitor Google Cloud Console usage
   - Set up alerts for unusual activity

---

## 📚 Code Structure

```
lib/
├── config/
│   └── env_config.dart              # Environment variables
├── services/
│   └── auth_service.dart            # Authentication logic
├── screens/
│   ├── login_screen.dart            # Google Sign-In UI
│   └── home_screen.dart             # User dashboard
└── main.dart                        # App entry & Supabase init
```

---

## 🎯 Key Features Implemented

✅ Sign in with Google (iOS & Android)
✅ Sign out from Google and Supabase
✅ Persist authentication session
✅ Auto-login if session exists
✅ Display user info (email, name, photo)
✅ Force account selection on login
✅ Pull-to-refresh user data
✅ Loading indicators
✅ Error handling with user feedback
✅ Animated UI transitions
✅ Auth state stream management

---

## 📖 Additional Resources

- [Supabase Auth Documentation](https://supabase.com/docs/guides/auth)
- [Google Sign-In Flutter Plugin](https://pub.dev/packages/google_sign_in)
- [Supabase Flutter Documentation](https://supabase.com/docs/reference/dart)
- [Google Cloud Console](https://console.cloud.google.com/)

---

## 💡 Next Steps

1. Add optional Google logo image:
   - Download Google logo
   - Place in `assets/images/google_logo.png`
   - Update `pubspec.yaml` assets section (already configured)

2. Customize UI colors in `login_screen.dart` and `home_screen.dart`

3. Add additional features:
   - Email verification
   - Password reset
   - Profile editing
   - Multi-factor authentication

4. Set up CI/CD for automated builds

---

## ❓ Need Help?

If you encounter issues:

1. Check Supabase Dashboard → Authentication → Logs
2. Check Flutter console for debug messages
3. Verify all configuration values are correct
4. Ensure OAuth clients are properly configured in Google Cloud Console
5. Check that redirect URIs match exactly

---

**🎉 You're all set! Run `flutter pub get` and then `flutter run` to test your app.**
