const functions = require("firebase-functions");
const admin = require("firebase-admin");
const moment = require("moment");

admin.initializeApp();

function getStreakAndTotal(timeline) {
    let bestStreak = 0;
    let currentStreak = 0;
    let totalCount = 0;
    const keys = Object.keys(timeline);

    for (let i = 0; i < keys.length; i++) {
        const date = keys[i];
        const dateInfo = timeline[date];
        if (dateInfo.completed && !isAfterToday(date)) {
            currentStreak++;
            if (currentStreak > bestStreak) {
                bestStreak = currentStreak;
            }
        } else {
            if (!isAfterToday(date)) {
                currentStreak = 0;
            }
        }
        totalCount += dateInfo.dayCount;
    }

    return { bestStreak, currentStreak, totalCount };
}

function isAfterToday(date) {
    const today = new Date();
    const selectedDay = moment(date, "YYYY-MM-DD").toDate();

    if (selectedDay.getFullYear() > today.getFullYear()) {
        return true;
    } else if (selectedDay.getFullYear() === today.getFullYear()) {
        if (selectedDay.getMonth() > today.getMonth()) {
            return true;
        } else if (selectedDay.getMonth() === today.getMonth()) {
            if (selectedDay.getDate() > today.getDate()) {
                return true;
            }
        }
    }

    return false;
}

exports.updateStreakAndTotal = functions.firestore
    .document("users/{userId}/habits/{habitId}")
    .onWrite((change, context) => {
        const timeline = change.after.data().timeline;
        const streakAndTotal = getStreakAndTotal(timeline);

        return change.after.ref.set(
            {
                streaks: streakAndTotal.currentStreak,
                bestStreak: streakAndTotal.bestStreak,
                totalCount: streakAndTotal.totalCount,
            },
            { merge: true }
        );
    });
