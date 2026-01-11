# 🔧 Troubleshooting Guide

## Common Issues and Solutions

---

### ❌ Issue: "Configuration Error" on App Launch

**Symptoms:**
- Red error icon appears
- Message: "Please configure your Supabase credentials..."

**Solution:**
1. Open `lib/config/env_config.dart`
2. Replace ALL placeholder values with your actual credentials
3. Make sure:
   - `supabaseUrl` contains your real Supabase URL
   - `supabaseAnonKey` contains your real anon key
   - No values contain "yourproject" or "your_supabase"

---

### ❌ Issue: "Developer Error" (iOS)

**Symptoms:**
- Google Sign-In shows error popup
- Error code: 10 or "DEVELOPER_ERROR"

**Solution:**
1. Open `ios/Runner/Info.plist`
2. Find the CFBundleURLSchemes section
3. Verify the reversed client ID is correct

**How to reverse:**
- Your iOS Client ID: `123456-abc.apps.googleusercontent.com`
- Reversed form: `com.googleusercontent.apps.123456-abc`
- Use this reversed form in Info.plist

**Double check:**
- Bundle ID in Xcode matches Google Console
- iOS OAuth client exists in Google Console
- Bundle ID is added to iOS OAuth client

---

### ❌ Issue: "Developer Error" (Android)

**Symptoms:**
- Google Sign-In fails silently or shows error
- Error in console: "DEVELOPER_ERROR"

**Solution:**
1. Get your SHA-1 fingerprint:
   ```bash
   cd android
   ./gradlew signingReport
   ```
   (Windows: `.\gradlew.bat signingReport`)

2. Copy the SHA-1 fingerprint (starts with SHA1:)

3. Go to Google Cloud Console → Credentials → Android OAuth client

4. Add the SHA-1 fingerprint

5. Verify package name matches `android/app/build.gradle` applicationId

**Common mistakes:**
- Using release SHA-1 for debug build (use debug SHA-1)
- Package name mismatch
- Forgot to save changes in Google Console

---

### ❌ Issue: "Invalid Grant" or Token Errors

**Symptoms:**
- Sign-in completes with Google but fails at Supabase
- Error: "Invalid grant" or "Token validation failed"

**Solution:**
1. Verify Web Client ID is correctly set as `serverClientId`:
   - Open `lib/services/auth_service.dart`
   - Check line ~32: `serverClientId: EnvConfig.googleWebClientId`

2. Verify in Supabase Dashboard:
   - Authentication → Providers → Google
   - Client ID (for OAuth) is your **Web Client ID**
   - Client Secret (for OAuth) is your **Web Client Secret**

3. Check redirect URI in Google Console:
   - Should be: `https://[project].supabase.co/auth/v1/callback`
   - Must match EXACTLY (no trailing slash)

---

### ❌ Issue: Account Picker Doesn't Appear

**Expected Behavior:**
- Account picker should appear every time you sign in
- Allows selecting different Google accounts

**Solution:**
Already implemented! The code forces sign out before sign in:

```dart
// In auth_service.dart
await _googleSignIn.signOut(); // Forces account picker
final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
```

If still not working:
- Clear app data/cache
- Uninstall and reinstall app
- Check Google Sign-In plugin version

---

### ❌ Issue: "No ID Token Found"

**Symptoms:**
- Error: "No ID Token found from Google Sign-In"

**Solution:**
1. Verify `serverClientId` is set correctly
2. iOS users: Verify `clientId` is set
3. Clear Google Sign-In cache:
   ```dart
   await _googleSignIn.disconnect();
   ```

---

### ❌ Issue: Session Not Persisting

**Symptoms:**
- After closing app, user has to login again
- Session doesn't survive app restart

**Solution:**
Session persistence is automatic in Supabase Flutter v2+.

If not working:
1. Check device storage permissions
2. Verify Supabase initialization completed successfully
3. Try:
   ```bash
   flutter clean
   flutter pub get
   flutter run
   ```

---

### ❌ Issue: Profile Picture Not Loading

**Symptoms:**
- User info displays but picture shows default avatar

**Possible Causes:**
1. Google didn't provide picture URL
2. Network issue loading image
3. User's Google account has no profile picture

**Solution:**
Already handled! The code has fallback:
```dart
errorWidget: (context, url, error) => Container(
  color: Colors.white,
  child: Icon(Icons.person),
),
```

---

### ❌ Issue: Deep Linking Not Working (Android)

**Symptoms:**
- OAuth callback fails on Android
- Browser doesn't redirect back to app

**Solution:**
1. Open `android/app/src/main/AndroidManifest.xml`
2. Verify Supabase URL is correct (line ~33):
   ```xml
   <data
       android:scheme="https"
       android:host="yourproject.supabase.co" />
   ```
3. Replace `yourproject` with your actual Supabase project name
4. Verify `android:autoVerify="true"` is present

---

### ❌ Issue: Build Fails - Dependency Conflicts

**Symptoms:**
- Flutter pub get fails
- Version conflicts in dependencies

**Solution:**
```bash
flutter clean
rm -rf pubspec.lock
flutter pub get
```

If still failing, check minimum SDK versions:
- Android: `minSdkVersion = 21`
- iOS: `MinimumOSVersion = 13.0`

---

### ❌ Issue: "PlatformException" on iOS

**Symptoms:**
- App crashes with PlatformException
- Google Sign-In not initializing

**Solution:**
1. Verify Info.plist is correctly formatted (valid XML)
2. Run `flutter clean`
3. Delete `ios/Pods` folder
4. Run:
   ```bash
   cd ios
   pod install
   cd ..
   flutter run
   ```

---

### ❌ Issue: Gradle Build Fails (Android)

**Symptoms:**
- Android build fails with Gradle errors

**Solution:**
1. Check `android/app/build.gradle`:
   - `minSdkVersion = 21` (line ~23)
   - `compileSdkVersion` is compatible

2. Update Gradle if needed:
   ```bash
   cd android
   ./gradlew wrapper --gradle-version=8.0
   ```

3. Sync Gradle:
   ```bash
   cd android
   ./gradlew clean build
   ```

---

### ❌ Issue: "Client is already authenticated with different credentials"

**Symptoms:**
- Can't sign in with different account
- Stuck with one Google account

**Solution:**
Already handled by forcing sign out! But if issue persists:

```dart
// Add to auth_service.dart if needed
await _googleSignIn.disconnect(); // Complete disconnect
await _googleSignIn.signOut();
```

---

## 🔍 Debugging Tips

### Enable Debug Logging

The code already includes debug prints. To see them:

**iOS:**
- Xcode → View → Debug Area → Activate Console
- Look for "Google Sign-In successful" messages

**Android:**
- Run with: `flutter run -v`
- Check logcat for detailed logs

### Check Supabase Logs

1. Go to Supabase Dashboard
2. Authentication → Logs
3. Filter by "google" provider
4. Look for failed attempts

### Check Network Requests

Use Flutter DevTools:
```bash
flutter pub global activate devtools
flutter pub global run devtools
```

---

## 📞 Still Need Help?

### Checklist Before Asking:

1. ✅ Read [ACTION_REQUIRED.md](ACTION_REQUIRED.md)
2. ✅ Read [GOOGLE_AUTH_SETUP.md](GOOGLE_AUTH_SETUP.md)
3. ✅ Verified all credentials are correct
4. ✅ Checked Google Cloud Console configuration
5. ✅ Checked Supabase Dashboard configuration
6. ✅ Tried `flutter clean` and rebuild
7. ✅ Reviewed Supabase auth logs
8. ✅ Checked Flutter console output

### Provide This Information:

- Platform (iOS/Android)
- Error message (exact text)
- Supabase auth logs
- Flutter console output
- Steps to reproduce

---

## 🛠️ Nuclear Option (Last Resort)

If nothing works:

```bash
# Complete clean rebuild
flutter clean
cd ios
pod deintegrate
pod install
cd ..
cd android
./gradlew clean
cd ..
flutter pub get
flutter run
```

---

**Good luck! Most issues are configuration-related and can be fixed by double-checking credentials and OAuth client settings.**
