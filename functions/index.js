const functions = require("firebase-functions");
const admin = require("firebase-admin");
const sgMail = require("@sendgrid/mail");

admin.initializeApp();

const SENDGRID_API_KEY = "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"; 
sgMail.setApiKey(SENDGRID_API_KEY);

exports.sendJobApplicationEmail = functions.firestore
  .document("employers/{employerID}/jobs/{jobId}/applications/{applicationId}")
  .onCreate(async (snap, context) => {
    const data = snap.data();

    const msg = {
      to: data.userEmail,
      from: "your-email@example.com",
      subject: "Job Application Received",
      text: `Hello ${data.userName},\n\nYour job application has been received.\n\nThank you!`,
      html: `<p>Hello <strong>${data.userName}</strong>,</p>
             <p>Your job application has been received.</p>
             <p>Thank you!</p>`,
    };

    try {
      await sgMail.send(msg);
      console.log("Email sent to:", data.userEmail);
    } catch (error) {
      console.error("Error sending email:", error);
    }
  });
