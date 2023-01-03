const functions = require("firebase-functions");

const admin = require("firebase-admin");
admin.initializeApp();

exports.resetFieldsDaily = functions.pubsub.schedule("0 0 * * *").onRun((_) => {
  const db = admin.firestore();

  const usersRef = db.collection("users");

  usersRef.get().then((querySnapshot) => {
    querySnapshot.forEach((doc) => {
      const habitsRef = usersRef.doc(doc.id).collection("habits");

      habitsRef.get().then((querySnapshot) => {
        querySnapshot.forEach((doc) => {
          habitsRef.doc(doc.id).update({
            completed: false,
            dayCount: 0,
          });
        });
      });
    });
  });

  console.log("Reset Completed", new Date().toLocaleString());
});
