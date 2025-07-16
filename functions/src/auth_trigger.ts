import {logger} from "firebase-functions";
import {auth} from "firebase-functions/v1";
import {FieldValue} from "firebase-admin/firestore";
import {UserRecord} from "firebase-functions/lib/common/providers/identity";
import {db} from "./firebase";

export const createUserRecord = auth.user().onCreate(async (user: UserRecord) => {
  try {
    const userRef = db.collection("users").doc(user.uid);

    const userData = {
      uid: user.uid,
      email: user.email || "",
      fcmToken: "",
      createdAt: FieldValue.serverTimestamp(),
      updatedAt: FieldValue.serverTimestamp(),
    };

    await userRef.set(userData, {merge: true});

    logger.log(`Utilisateur traité avec succès: ${user.uid}`, {
      userId: user.uid,
      action: "created_or_merged",
    });
  } catch (error) {
    logger.error("Erreur lors du traitement de l'utilisateur:", error);
    throw error;
  }
});
