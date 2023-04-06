import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';

import 'EditProfile.dart';

class Profile extends StatefulWidget {
  const Profile({
    Key? key,
  }) : super(key: key);

  @override
  State<Profile> createState() => _ProfileState();
}

String name='';
String num='';
final user = FirebaseAuth.instance.currentUser!;
final userCollection = FirebaseFirestore.instance.collection('users');

 Future <List<String>> getUserData() async {
  DocumentSnapshot data = await userCollection.doc(user.uid).get();
  num = data.get("number");
  name = data.get("name");
  return [name,num];
}


class _ProfileState extends State<Profile> {
  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser!;
    return FutureBuilder(
      future: getUserData(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting)
          return Center(
            child: CircularProgressIndicator(),
          );
        return Scaffold(
            backgroundColor: Colors.brown,
            body: Stack(children: <Widget>[
              Container(
                decoration: const BoxDecoration(
                  image: DecorationImage(
                      image: AssetImage('assets/bricks.jpg'), fit: BoxFit.fill),
                ),
              ),
              Column(
                children: [
                  const SizedBox(height: 50),
                  CircleAvatar(
                    radius: 90,
                    backgroundColor: Colors.black38,
                    child: CircleAvatar(
                      backgroundColor: Colors.white,
                      backgroundImage: NetworkImage((user.photoURL == null
                          ? "https://media.istockphoto.com/id/1223671392/vector/default-profile-picture-avatar-photo-placeholder-vector-illustration.jpg?s=612x612&w=0&k=20&c=s0aTdmT5aU6b8ot7VKm11DeID6NctRCpB755rA1BIP0="
                          : user.photoURL!)),
                      radius: 85,
                    ),
                  ),
                  const SizedBox(
                    height: 80,
                  ),
                  Container(
                    margin: const EdgeInsets.all(12),
                    padding: const EdgeInsets.all(15),
                    width: double.infinity,
                    decoration: BoxDecoration(
                        color: Colors.white,
                        border: Border.all(color: Colors.black, width: 3),
                        borderRadius:
                            const BorderRadius.all(Radius.circular(10))),
                    child: Text(
                      (user.displayName == null ? "Name: " +name : "Name: " + user.displayName!),
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                  Container(
                    margin: const EdgeInsets.all(12),
                    padding: const EdgeInsets.all(15),
                    width: double.infinity,
                    decoration: BoxDecoration(
                        color: Colors.white,
                        border: Border.all(color: Colors.black, width: 3),
                        borderRadius:
                            const BorderRadius.all(Radius.circular(10))),
                    child: Text(
                     "Email: "+ user.email!,
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                  Container(
                    margin: const EdgeInsets.all(12),
                    padding: const EdgeInsets.all(15),
                    width: double.infinity,
                    decoration: BoxDecoration(
                        color: Colors.white,
                        border: Border.all(color: Colors.black, width: 3),
                        borderRadius:
                            const BorderRadius.all(Radius.circular(10))),
                    child: Text(
                      "Number: " + num.toString(),
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.push(context, PageTransition(
                          type: PageTransitionType.rotate,
                          alignment: Alignment.bottomCenter,
                          child: EditProfile()),);
                    },
                    child: Text('Edit Profile'),
                    style: ElevatedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10)),
                        backgroundColor: Colors.indigo,
                        fixedSize: Size(150, 45)),
                  )
                ],
              )
            ]));
      },
    );
  }
}
