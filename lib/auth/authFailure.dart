

class AuthFailure {
  final String message;

  const AuthFailure([this.message = "An unknown error occured."]);

  factory AuthFailure.code(String code){
    switch(code){
      case 'weak-password':
      return const AuthFailure('Please enter strong password');
      case 'invalid-email':
      return const AuthFailure('Invalid email format');
      case 'email-already-in-use':
      return const AuthFailure('Email already exist');
      case 'operation-not-allowed':
      return const AuthFailure('Operation is not allowed. Please contact support.');
      default:
      return const AuthFailure();
    }
  }

}