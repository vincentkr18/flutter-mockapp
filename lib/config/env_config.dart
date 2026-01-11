/// Environment configuration for the Flutter app
/// 
/// IMPORTANT: In production, use flutter_dotenv or similar package
/// to load these values from a .env file that is NOT committed to version control.
/// 
/// For now, replace these placeholder values with your actual credentials.
class EnvConfig {
  // Supabase Configuration
  static const String supabaseUrl = 'https://waiavurchyemodltjrzn.supabase.co';
  static const String supabaseAnonKey = 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6IndhaWF2dXJjaHllbW9kbHRqcnpuIiwicm9sZSI6ImFub24iLCJpYXQiOjE3Njc2ODgwODIsImV4cCI6MjA4MzI2NDA4Mn0.dfB4vIPy7eRZSJ49-lVUpzrI9eU2lre8w01PqTBUy-U';

  // Google OAuth Client IDs
  // Web Client ID is used as serverClientId for both iOS and Android
  static const String googleWebClientId = '537364653418-svii5a1ojkmjnrnpi06ncmsauh7f28so.apps.googleusercontent.com';
  
  // iOS Client ID is used as clientId for iOS only
  static const String googleIosClientId = '537364653418-rv2hspk5hnllq2lj7dv5iv8raaa6nij2.apps.googleusercontent.com';
  
  // Android Client ID - for reference only (not used in code)
  // Android auto-detects the client using SHA-1 fingerprint
  static const String googleAndroidClientId = '537364653418-f8e2rfntkkqd44unsbp8dsi3mt1mftej.apps.googleusercontent.com';

  // App Configuration
  static const String androidPackageName = 'com.testingapp.flutter_login_app';
  static const String iosBundleId = 'com.testingapp.flutter_login_app';

  // Validation
  static bool get isConfigured {
    return supabaseUrl.contains('supabase.co') &&
        !supabaseUrl.contains('yourproject') &&
        !supabaseAnonKey.contains('your_supabase');
  }

  static String get configurationError {
    if (!isConfigured) {
      return 'Please configure your Supabase credentials in lib/config/env_config.dart';
    }
    return '';
  }
}
