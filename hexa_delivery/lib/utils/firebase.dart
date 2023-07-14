import 'package:firebase_database/firebase_database.dart';

DatabaseReference getFirebaseRef(String src) {
  return FirebaseDatabase.instance.ref(src);
}
