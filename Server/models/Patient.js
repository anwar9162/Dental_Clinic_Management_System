const mongoose = require('mongoose');
const dentalChartEntrySchema = new mongoose.Schema({
  condition: String,
  treatment: String,
  date: Date
});

const dentalChartSchema = new mongoose.Schema({
  toothNumber: String,
  notes: [dentalChartEntrySchema]
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
  dentalChart: [dentalChartSchema]
});

const Patient = mongoose.model('Patient', patientSchema);

module.exports = Patient;