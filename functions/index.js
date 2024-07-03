/**
 * Import function triggers from their respective submodules:
 *
 * const {onCall} = require("firebase-functions/v2/https");
 * const {onDocumentWritten} = require("firebase-functions/v2/firestore");
 *
 * See a full list of supported triggers at https://firebase.google.com/docs/functions
 */

const functions = require("firebase-functions");
const admin = require("firebase-admin");
const express = require("express");
admin.initializeApp();

const app = express();

// Middleware to parse JSON bodies
app.use(express.json());

// HTTP request handler
app.post("/midtransCallback", (req, res) => {
  const transactionStatus = req.body.transaction_status;
  const orderId = req.body.order_id;

  // Update Firestore
  const db = admin.firestore();
  const orderRef = db.collection("orders").doc(orderId);

  return orderRef.update({status: transactionStatus})
      .then(() => {
        res.status(200).send("Callback received and processed successfully");
      })
      .catch((error) => {
        console.error("Error updating order status:", error);
        res.status(500).send("Internal Server Error");
      });
});

// Export Express app as a Firebase Function
exports.app = functions.https.onRequest(app);


// Create and deploy your first functions
// https://firebase.google.com/docs/functions/get-started

// exports.helloWorld = onRequest((request, response) => {
//   logger.info("Hello logs!", {structuredData: true});
//   response.send("Hello from Firebase!");
// });
