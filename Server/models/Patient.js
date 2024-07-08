const mongoose = require('mongoose');

const patientSchema = new mongoose.Schema({
  firstName: String,
  lastName: String,
  dateOfBirth: Date,
  medicalHistory: [{
    condition: String,
    treatment: String,
    date: Date
  }],
  // Adding visit history to the patient schema
  visitHistory: [{
    type: mongoose.Schema.Types.ObjectId,
    ref: 'Appointment',
  }]
});

const Patient = mongoose.model('Patient', patientSchema);

module.exports = Patient;
