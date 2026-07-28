class AppConstants {
  static const String appName = 'PolicyPal';
  // Use 10.0.2.2 for Android Emulator (maps to localhost on host machine)
  // Change to your deployed backend URL for production builds
  static const String apiBaseUrl = 'http://10.0.2.2:5000/api';
  static const String localApiBaseUrl = 'http://10.0.2.2:5000/api';
  
  static const String claimsDisclaimer = 
    'DISCLAIMER: PolicyPal provides information for guidance purposes only and does not constitute a formal coverage decision or guarantee. Final claim authorization rests solely with your insurance provider.';
}
