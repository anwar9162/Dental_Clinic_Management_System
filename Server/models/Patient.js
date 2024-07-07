const mongoose = require("mongoose");
const { Schema } = mongoose;

const patientSchema = new Schema({
  name: String,
  dateOfBirth: Date,
  gender: String,
  contactInfo: {
    phone: String,
    email: String,
    address: String,
  },
  firstVisitDate: Date,
  medicalHistory: [String],
  currentAppointmentReason: String,
  lastTreatment: String,
});

const Patient = mongoose.model("Patient", patientSchema);
module.exports = Patient;
