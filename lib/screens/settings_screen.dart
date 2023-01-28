import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  final String backgroundImageUrl = FirebaseAuth
              .instance.currentUser!.photoURL ==
          null
      ? 'https://upload.wikimedia.org/wikipedia/commons/9/99/Sample_User_Icon.png'
      : FirebaseAuth.instance.currentUser!.photoURL!;
  String userName = FirebaseAuth.instance.currentUser!.displayName == null
      ? 'User'
      : FirebaseAuth.instance.currentUser!.displayName!;
  final userUId = FirebaseAuth.instance.currentUser!.uid;

  Future<bool> signOut() async {
    try {
      await FirebaseAuth.instance.signOut();
      return true;
    } on FirebaseAuthException catch (error) {
      print(error);
      return false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(45),
      margin: const EdgeInsets.only(top: 85),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // "Account" Header
          // TextButton(
          //   onPressed: () => FirebaseAuth.instance.signOut(),
          //   child: Text('temp'),
          // ),
          const Text(
            "Account",
            style: TextStyle(
              fontSize: 35,
              fontWeight: FontWeight.w700,
            ),
          ),

          // Photo Section
          Row(
            children: [
              Container(
                child: const Text(
                  "Photo",
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ),
              const SizedBox(
                width: 80,
              ),
              Container(
                width: 90,
                height: 90,
                margin: const EdgeInsets.only(top: 60),
                child: CircleAvatar(
                  radius: 22,
                  backgroundImage: NetworkImage(
                    backgroundImageUrl,
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(
            height: 40,
          ),

          // Name Section
          Row(
            children: [
              Container(
                child: const Text(
                  "Name",
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ),
              const SizedBox(
                width: 80,
              ),
              Expanded(
                child: StreamBuilder(
                  builder: (context, snapshot) {
                    if (!snapshot.hasData) {
                      return const CircularProgressIndicator();
                    }

                    final data = snapshot.data!.data();
                    TextEditingController controller = TextEditingController();

                    if (data!.containsKey('userName')) {
                      controller.text = data['userName'];
                    }

                    return TextField(
                      controller: controller,
                      onSubmitted: (value) {
                        FirebaseFirestore.instance
                            .doc('users/$userUId')
                            .update({"userName": value});
                      },
                      style: const TextStyle(
                        fontSize: 15,
                      ),
                      decoration: InputDecoration(
                          enabledBorder: const UnderlineInputBorder(
                              borderSide: BorderSide(
                            color: Colors.grey,
                          )),
                          hintText: userName,
                          hintStyle: const TextStyle(
                            fontSize: 15,
                          )),
                    );
                  },
                  stream: FirebaseFirestore.instance
                      .doc('/users/$userUId')
                      .snapshots(),
                ),
              ),
            ],
          ),
          const SizedBox(
            height: 40,
          ),
          Row(
            children: [
              Container(
                child: const Text(
                  "Email",
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ),
              const SizedBox(
                width: 80,
              ),
              Text(
                '${FirebaseAuth.instance.currentUser!.email}',
              )
            ],
          ),
          const SizedBox(
            height: 190,
          ),
          Center(
            child: ElevatedButton(
              style: ButtonStyle(
                backgroundColor:
                    MaterialStateProperty.all(Color.fromRGBO(223, 223, 223, 1)),
              ),
              onPressed: () {
                signOut().then((success) {
                  if (success) {
                    Navigator.pushReplacementNamed(context, '/sign-in');
                  }
                });
              },
              child: const Text(
                "Sign Out",
                style: TextStyle(color: Colors.black),
              ),
            ),
          )
        ],
      ),
    );
  }
}
