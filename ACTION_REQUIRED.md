# 🚀 Final Setup Checklist - Action Required

## ⚠️ IMPORTANT: Complete These Steps Before Running

### Step 1️⃣: Update Environment Configuration (REQUIRED)

Open: `lib/config/env_config.dart`

Replace these values with your actual credentials:

```dart
// 1. Replace with YOUR Supabase project URL
static const String supabaseUrl = 'https://YOUR_PROJECT.supabase.co';

// 2. Replace with YOUR Supabase anon key  
static const String supabaseAnonKey = 'YOUR_ANON_KEY';

// 3. Replace with YOUR Google Web Client ID
static const String googleWebClientId = 'YOUR_WEB_CLIENT_ID.apps.googleusercontent.com';

// 4. Replace with YOUR Google iOS Client ID
static const String googleIosClientId = 'YOUR_IOS_CLIENT_ID.apps.googleusercontent.com';
```

**Where to find:**
- Supabase Dashboard → Settings → API → URL and anon/public key
- Google Cloud Console → Credentials → Your OAuth 2.0 Client IDs

---

### Step 2️⃣: Configure iOS (REQUIRED for iOS)

Open: `ios/Runner/Info.plist`

Find line ~52 and update the reversed iOS Client ID:

**Your iOS Client ID:** `123456-abc.apps.googleusercontent.com`
**Reverse it to:** `com.googleusercontent.apps.123456-abc`

Replace in Info.plist:
```xml
<string>com.googleusercontent.apps.YOUR_NUMBER_HERE</string>
```

---

### Step 3️⃣: Configure Android (REQUIRED for Android)

Open: `android/app/src/main/AndroidManifest.xml`

Find line ~33 and update your Supabase URL:

```xml
<data
    android:scheme="https"
    android:host="YOUR_PROJECT.supabase.co" />
```

Replace `YOUR_PROJECT` with your actual Supabase project name.

---

### Step 4️⃣: Verify Bundle ID / Package Name

**iOS:**
Current bundle ID: `com.testingapp.flutter_login_app`
- File: `ios/Runner.xcodeproj/project.pbxproj` (line 371)
- **Must match** your iOS OAuth client bundle ID in Google Console

**Android:**
Current package: `com.testingapp.flutter_login_app`
- File: `android/app/build.gradle` (applicationId)
- **Must match** your Android OAuth client package name in Google Console

If different, update both files.

---

### Step 5️⃣: Add SHA-1 to Android OAuth Client (REQUIRED)

If you haven't already added your SHA-1 fingerprint:

```bash
cd android
./gradlew signingReport
```

Copy the SHA-1 and add it to your Android OAuth client in Google Cloud Console.

---

### Step 6️⃣: Verify Supabase Configuration

In Supabase Dashboard:

1. ✅ Authentication → Providers → Google is ENABLED
2. ✅ Google Client ID (Web) is set
3. ✅ Google Client Secret (Web) is set
4. ✅ Authorized Client IDs includes Web Client ID

---

### Step 7️⃣: Verify Google Cloud Console

1. ✅ Web OAuth client exists with redirect URI:
   - `https://[project].supabase.co/auth/v1/callback`

2. ✅ iOS OAuth client exists with:
   - Bundle ID: `com.testingapp.flutter_login_app` (or your custom one)

3. ✅ Android OAuth client exists with:
   - Package name: `com.testingapp.flutter_login_app` (or your custom one)
   - SHA-1 fingerprint added

4. ✅ OAuth consent screen configured

---

## ✅ Ready to Run!

Once all steps above are complete:

```bash
# Run on iOS
flutter run -d iphone

# Run on Android
flutter run -d emulator

# Or just
flutter run
```

---

## 📋 Quick Test

After launch:

1. [ ] App shows login screen (not config error)
2. [ ] Click "Sign in with Google"
3. [ ] Google account picker appears
4. [ ] Select account
5. [ ] Home screen appears with your info
6. [ ] Profile picture loads
7. [ ] Click sign out
8. [ ] Returns to login screen

---

## 🐛 If Something Goes Wrong

**"Configuration Error"**
→ Update `lib/config/env_config.dart` with real values

**"Developer Error" (iOS)**
→ Check reversed iOS Client ID in Info.plist

**"Developer Error" (Android)**
→ Verify SHA-1 is added to Android OAuth client

**"Invalid Grant"**
→ Check Web Client ID is correct in Supabase and code

**Account picker doesn't show**
→ Already implemented - we force sign out before sign in

**Can't find files to edit**
→ All file paths are relative to project root

---

## 📁 Files You Need to Edit

Only these 3 files need your credentials:

1. `lib/config/env_config.dart` - All credentials
2. `ios/Runner/Info.plist` - Reversed iOS Client ID
3. `android/app/src/main/AndroidManifest.xml` - Supabase URL

---

## 🎯 That's It!

After updating the 3 files above with your credentials, run:

```bash
flutter run
```

Good luck! 🚀

---

**Need detailed help?** See [GOOGLE_AUTH_SETUP.md](GOOGLE_AUTH_SETUP.md)
