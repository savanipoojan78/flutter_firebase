import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:async/async.dart';

final FirebaseAuth auth = FirebaseAuth.instance;
final GoogleSignIn googleSignIn = new GoogleSignIn();

Future<bool> signIn() async {
  GoogleSignInAccount googleSignInAccount = await googleSignIn.signIn();
  GoogleSignInAuthentication googleSignInAuthentication =
      await googleSignInAccount.authentication;
  FirebaseUser user = await auth.signInWithGoogle(
      idToken: googleSignInAuthentication.idToken,
      accessToken: googleSignInAuthentication.accessToken);
  if (user != null && user.isAnonymous == false) {
    return true;
  } else {
    return false;
  }
}

Future<Null> ensurelogIn() async {
  FirebaseUser user=await auth.currentUser();
  assert(user!=null);
  assert(user.isAnonymous==false);
  print('Sucessfully Log in');
}

Future<bool> signOut() async {
  await googleSignIn.signOut();
  await auth.signOut();
  return true;
}
