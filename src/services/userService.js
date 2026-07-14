import { collection, getDocs } from "firebase/firestore";
import { db } from "./firebase";

const USERS_COLLECTION = "users";

export async function getUsers() {
  
  try {

    const snapshot = await getDocs(
      collection(db, USERS_COLLECTION)
    );

    return snapshot.docs.map(doc => ({
      id: doc.id,
      ...doc.data(),
    }));

  } catch (error) {

    console.error(error);

    return [];
  }
  
}