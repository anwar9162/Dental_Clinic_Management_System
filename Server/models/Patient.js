const mongoose = require("mongoose");

// Define the schema for an image
const imageSchema = new mongoose.Schema({
  dateCaptured: Date,
  assetPath: String,
});

// Define the schema for a payment
const paymentSchema = new mongoose.Schema({
  amount: Number,
  date: String,
  status: {
    type: String,
    enum: ["Pending", "Cancelled", "Paid"],
    default: "Pending",
  },
  reason: String,
});

// Define the schema for dental chart entries
const dentalChartEntrySchema = new mongoose.Schema({
  condition: String,
  treatment: String,
  date: Date,
});

// Define the schema for dental chart
const dentalChartSchema = new mongoose.Schema({
  toothNumber: String,
  notes: [dentalChartEntrySchema],
});

// Define the schema for the patient
const patientSchema = new mongoose.Schema({
  firstName: String,
  lastName: String,
  phoneNumber: {
    type: String,
    unique: true,
  },
  Gender: String,
  dateOfBirth: Date,
  Address: String,
  medicalHistory: [
    {
      condition: String,
      treatment: String,
      date: Date,
    },
  ],
  visitHistory: [
    {
      type: mongoose.Schema.Types.ObjectId,
      ref: "Appointment",
    },
  ],
  dentalChart: [dentalChartSchema],
  payments: [paymentSchema],
  progressImages: [imageSchema], // Add progressImages field
  xrayImages: [imageSchema], // Add xrayImages field
});

const Patient = mongoose.model("Patient", patientSchema);

module.exports = Patient;
