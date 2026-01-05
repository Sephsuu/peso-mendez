import admin from "firebase-admin";

const serviceAccountJson = process.env.FIREBASE_SERVICE_ACCOUNT;

if (!serviceAccountJson) {
  throw new Error("Missing FIREBASE_SERVICE_ACCOUNT env var");
}

const serviceAccount = JSON.parse(serviceAccountJson);

// Fix escaped newlines in the private key (common in env vars)
if (serviceAccount.private_key) {
  serviceAccount.private_key = serviceAccount.private_key.replace(/\\n/g, "\n");
}

admin.initializeApp({
  credential: admin.credential.cert(serviceAccount),
});

export default admin;