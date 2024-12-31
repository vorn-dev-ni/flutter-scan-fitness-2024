class FirebaseAuthMessage {
  FirebaseAuthMessage._();
  static String getMessage(errorCode) {
    switch (errorCode) {
      case 'invalid-credential':
        return "The credential is invalid or expired.";
      case 'user-not-found':
        return "No user found with this email.";
      case 'invalid-email':
        return "An Email is either badly format or wrong";
      case 'wrong-password':
        return "Incorrect password. Please try again.";
        ;
      case 'too-many-requests':
        return "Too many attempts. Try again later.";
        ;
      default:
        return "An unknown error occurred. Please try again.";
    }
  }
}
