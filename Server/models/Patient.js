const mongoose = require("mongoose");

// Define the schema for chief complaint
const chiefComplaintSchema = new mongoose.Schema({
  description: String,
  duration: String,
  severity: String,
});

// Define the schema for history of present illness (HPI)
const hpiSchema = new mongoose.Schema({
  onset: String,
  progression: String,
  associatedSymptoms: String,
});

// Define the schema for physical examination
const physicalExaminationSchema = new mongoose.Schema({
  bloodPressure: String,
  temperature: String,
  pulse: String,
  respirationRate: String,
});

// Define the schema for general appearance
const generalAppearanceSchema = new mongoose.Schema({
  appearance: {
    type: String,
    enum: ["Well-Looking", "Acute Sick-Looking"],
  },
  additionalNotes: String,
});

// Define the schema for extra oral examination
const extraOralSchema = new mongoose.Schema({
  findings: String,
});

// Define the schema for internal oral examination
const internalOralSchema = new mongoose.Schema({
  findings: String,
});

// Define the schema for diagnosis
const diagnosisSchema = new mongoose.Schema({
  condition: String,
  details: String,
});

// Define the schema for treatment plan
const treatmentPlanSchema = new mongoose.Schema({
  plannedTreatments: [String],
  followUpInstructions: String,
});

// Define the schema for treatment done
const treatmentDoneSchema = new mongoose.Schema({
  treatments: [String],
  completionDate: Date,
});

// Define the schema for progress notes
const progressNoteSchema = new mongoose.Schema({
  note: String,
  createdAt: {
    type: Date,
    default: Date.now,
  },
});

// Define the schema for payments
const paymentSchema = new mongoose.Schema({
  amount: Number,
  date: Date,
  status: {
    type: String,
    enum: ["Pending", "Cancelled", "Paid"],
    default: "Pending",
  },
  reason: String,
});

// Define the schema for images
const imageSchema = new mongoose.Schema({
  dateCaptured: Date,
  assetPath: String,
});

// Define the schema for card status
const cardStatusSchema = new mongoose.Schema({
  isActive: {
    type: Boolean,
    default: true,
  },
  expirationDate: Date,
  notes: String,
});

// Define schema for a visit
const visitSchema = new mongoose.Schema({
  date: {
    type: Date,
    required: true,
  },
  reason: String,
  chiefComplaint: {
    type: chiefComplaintSchema,
    required: function() {
      return this.reason && this.reason !== "Routine Check-up";
    },
  },
  historyOfPresentIllness: {
    type: hpiSchema,
    required: function() {
      return this.reason && this.reason !== "Routine Check-up";
    },
  },
  physicalExamination: {
    type: physicalExaminationSchema,
    required: true,
  },
  generalAppearance: {
    type: generalAppearanceSchema,
    required: true,
  },
  extraOral: extraOralSchema,
  internalOral: {
    type: internalOralSchema,
    required: true,
  },
  diagnosis: diagnosisSchema,
  treatmentPlan: treatmentPlanSchema,
  treatmentDone: treatmentDoneSchema,
  progressNotes: [progressNoteSchema],
  payments: paymentSchema,
});

// Define the schema for the patient
const patientSchema = new mongoose.Schema({
  firstName: String,
  lastName: String,
  phoneNumber: {
    type: String,
    unique: true,
  },
  gender: String,
  dateOfBirth: Date,
  address: String,
  cardStatus: cardStatusSchema,
  visitHistory: [visitSchema],
  progressImages: [imageSchema], // Moved here
  xrayImages: [imageSchema], // Moved here
});

const Patient = mongoose.model("Patient", patientSchema);

module.exports = Patient;
