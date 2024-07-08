const mongoose = require('mongoose');
const dentalChartSchema = new mongoose.Schema({
  toothNumber: String,
  condition: String,
  treatment: String,
  date: Date
});
const patientSchema = new mongoose.Schema({
  firstName: String,
  lastName: String,
  dateOfBirth: Date,
  medicalHistory: [{
    condition: String,
    treatment: String,
    date: Date
  }],
  visitHistory: [{
    type: mongoose.Schema.Types.ObjectId,
    ref: 'Appointment',
  }],
  dentalChart:[dentalChartSchema]
});

const Patient = mongoose.model('Patient', patientSchema);

module.exports = Patient;
