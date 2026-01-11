import 'dart:io' show Platform;
import 'package:flutter/foundation.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../config/env_config.dart';

/// Authentication service that handles Google Sign-In with Supabase
/// 
/// This service manages:
/// - Google Sign-In initialization
/// - Sign in with Google flow
/// - Token exchange with Supabase
/// - Sign out functionality
/// - Current user information
/// - Auth state changes
class AuthService {
  // Singleton pattern
  static final AuthService _instance = AuthService._internal();
  factory AuthService() => _instance;
  AuthService._internal();

  // Supabase client instance
  final SupabaseClient _supabase = Supabase.instance.client;
  
  // Google Sign-In instance
  late final GoogleSignIn _googleSignIn;

  /// Initialize Google Sign-In with platform-specific configuration
  void initialize() {
    _googleSignIn = GoogleSignIn(
      // iOS requires clientId to be set
      // Android uses SHA-1 fingerprint and doesn't need clientId
      clientId: kIsWeb || Platform.isIOS ? EnvConfig.googleIosClientId : null,
      
      // Web Client ID is used as serverClientId for token validation
      // This is required for both iOS and Android
      serverClientId: EnvConfig.googleWebClientId,
      
      // Request email and profile scopes
      scopes: [
        'email',
        'profile',
      ],
    );
  }

  /// Sign in with Google
  /// 
  /// Flow:
  /// 1. Sign out from Google to force account picker
  /// 2. Sign in with Google to get tokens
  /// 3. Exchange tokens with Supabase
  /// 4. Return user session
  /// 
  /// Returns the User object if successful, null otherwise
  Future<User?> signInWithGoogle() async {
    try {
      // Force sign out to show account picker every time
      await _googleSignIn.signOut();

      // Trigger the Google Sign-In flow
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
      
      // User cancelled the sign-in
      if (googleUser == null) {
        debugPrint('Google Sign-In cancelled by user');
        return null;
      }

      // Obtain the auth details from the Google Sign-In
      final GoogleSignInAuthentication googleAuth = await googleUser.authentication;

      // Get the tokens
      final String? idToken = googleAuth.idToken;
      final String? accessToken = googleAuth.accessToken;

      // Validate tokens
      if (idToken == null) {
        throw Exception('No ID Token found from Google Sign-In');
      }

      debugPrint('Google Sign-In successful for: ${googleUser.email}');

      // Sign in to Supabase using the Google tokens
      final AuthResponse response = await _supabase.auth.signInWithIdToken(
        provider: OAuthProvider.google,
        idToken: idToken,
        accessToken: accessToken,
      );

      debugPrint('Supabase authentication successful');
      return response.user;
    } on AuthException catch (e) {
      debugPrint('Supabase Auth Error: ${e.message}');
      throw Exception('Authentication failed: ${e.message}');
    } catch (e) {
      debugPrint('Sign in error: $e');
      throw Exception('Sign in failed: $e');
    }
  }

  /// Sign out from both Google and Supabase
  /// 
  /// This ensures the user is completely signed out and will
  /// see the account picker on next sign-in
  Future<void> signOut() async {
    try {
      // Sign out from Google
      await _googleSignIn.signOut();
      
      // Sign out from Supabase
      await _supabase.auth.signOut();
      
      debugPrint('Sign out successful');
    } catch (e) {
      debugPrint('Sign out error: $e');
      throw Exception('Sign out failed: $e');
    }
  }

  /// Get the current authenticated user
  /// 
  /// Returns the User object if authenticated, null otherwise
  User? get currentUser => _supabase.auth.currentUser;

  /// Get the current session
  /// 
  /// Returns the Session object if authenticated, null otherwise
  Session? get currentSession => _supabase.auth.currentSession;

  /// Check if user is currently authenticated
  bool get isAuthenticated => currentUser != null;

  /// Get the current user's email
  String? get userEmail => currentUser?.email;

  /// Get the current user's display name
  String? get userDisplayName => currentUser?.userMetadata?['full_name'] as String?;

  /// Get the current user's profile picture URL
  String? get userPhotoUrl => currentUser?.userMetadata?['avatar_url'] as String?;

  /// Stream of auth state changes
  /// 
  /// Listen to this stream to react to authentication state changes
  Stream<AuthState> get authStateChanges => _supabase.auth.onAuthStateChange;

  /// Refresh the current session
  /// 
  /// Useful for pull-to-refresh functionality
  Future<AuthResponse> refreshSession() async {
    try {
      final response = await _supabase.auth.refreshSession();
      debugPrint('Session refreshed');
      return response;
    } catch (e) {
      debugPrint('Session refresh error: $e');
      throw Exception('Failed to refresh session: $e');
    }
  }

  /// Get user metadata
  /// 
  /// Returns additional user information stored in Supabase
  Map<String, dynamic>? get userMetadata => currentUser?.userMetadata;

  /// Dispose resources (if needed)
  void dispose() {
    // Clean up resources if necessary
  }
}
