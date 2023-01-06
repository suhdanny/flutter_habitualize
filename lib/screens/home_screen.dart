import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../widgets/habit_grid_tile.dart';
import '../widgets/habit_list_tile.dart';

class HomeScreen extends StatelessWidget {
  HomeScreen({super.key});

  String userUid = FirebaseAuth.instance.currentUser!.uid;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ListTile(
              leading: CircleAvatar(
                backgroundImage: NetworkImage(
                  FirebaseAuth.instance.currentUser!.photoURL!,
                ),
              ),
              title: Text(
                'Welcome, \n${FirebaseAuth.instance.currentUser!.displayName!}',
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const SizedBox(height: 10),
            const Text(
              "Today's Challenge",
              style: TextStyle(
                fontSize: 20,
              ),
            ),
            const SizedBox(height: 10),
            Expanded(
              child: StreamBuilder(
                builder: (ctx, snapshot) {
                  if (snapshot.data == null) {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  }
                  return GridView.builder(
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      mainAxisSpacing: 10,
                      crossAxisSpacing: 10,
                    ),
                    itemBuilder: (ctx, idx) {
                      Map<String, dynamic> data =
                          snapshot.data!.docs[idx].data();
                      int codePoint = int.parse(
                          data['icon'].split('U+')[1].split(')')[0],
                          radix: 16);
                      IconData icon =
                          IconData(codePoint, fontFamily: "MaterialIcons");
                      Color iconColor =
                          Color(int.parse(data['iconColor'], radix: 16));
                      return HabitGridTile(
                        docId: snapshot.data!.docs[idx].id,
                        icon: icon,
                        iconColor: iconColor,
                        title: data['title'],
                        count: data['count'],
                        countUnit: data['countUnit'],
                        dayCount: data['dayCount'],
                        duration: data['duration'],
                        streaks: data['streaks'],
                        completed: data['completed'],
                      );
                    },
                    itemCount: snapshot.data!.docs.length,
                  );
                },
                stream: FirebaseFirestore.instance
                    .collection('/users/$userUid/habits')
                    .snapshots(),
              ),
            ),
            // Expanded(
            //   child: StreamBuilder(
            //     builder: (ctx, snapshot) {
            //       if (snapshot.data == null) {
            //         return const Center(
            //           child: CircularProgressIndicator(),
            //         );
            //       }
            //       return ListView.builder(
            //         itemBuilder: (ctx, idx) {
            //           Map<String, dynamic> data =
            //               snapshot.data!.docs[idx].data();
            //           int codePoint = int.parse(
            //               data['icon'].split('U+')[1].split(')')[0],
            //               radix: 16);
            //           IconData icon =
            //               IconData(codePoint, fontFamily: "MaterialIcons");
            //           Color iconColor =
            //               Color(int.parse(data['iconColor'], radix: 16));
            //           return HabitListTile(
            //             docId: snapshot.data!.docs[idx].id,
            //             icon: icon,
            //             iconColor: iconColor,
            //             title: data['title'],
            //             count: data['count'],
            //             countUnit: data['countUnit'],
            //             dayCount: data['dayCount'],
            //             duration: data['duration'],
            //             streaks: data['streaks'],
            //             completed: data['completed'],
            //           );
            //         },
            //         itemCount: snapshot.data!.docs.length,
            //       );
            //     },
            //     stream: FirebaseFirestore.instance
            //         .collection('/users/$userUid/habits')
            //         .snapshots(),
            //   ),
            // ),
          ],
        ),
      ),
    );
  }
}
