import {logger} from "firebase-functions";
import {onDocumentUpdated} from "firebase-functions/v2/firestore";
import {FieldValue} from "firebase-admin/firestore";
import {db} from "./firebase";

export const updatePostTimestamp = onDocumentUpdated("posts/{postId}", async (event) => {
  const postId = event.params.postId;

  const before = event.data?.before?.data();
  const after = event.data?.after?.data();

  if (!before || !after) {
    logger.warn("Aucune donnée avant ou après la mise à jour.");
    return;
  }

  if (
    before.title === after.title &&
    before.description === after.description &&
    before.updateDate?.toMillis?.() === after.updateDate?.toMillis?.()
  ) {
    logger.info("Aucune modification pertinente détectée.");
    return null;
  }

  await db.collection("posts").doc(postId).update({
    updatedAt: FieldValue.serverTimestamp(),
  });

  logger.info(`Post mis à jour : ${postId}`);
  return null;
});
