const mongoose = require('mongoose');

const appointmentSchema = new mongoose.Schema({
  patient: {
    type: mongoose.Schema.Types.ObjectId,
    ref: 'Patient',
    required: true,
  },
  doctor: {
    type: mongoose.Schema.Types.ObjectId,
    ref: 'Doctor',
    required: true,
  },
  date: {
    type: Date,
    required: true,
  },
  AppointmentReason:{
    type:String
  },
  ExpectedPayment:{
    type:String
  },
  status: {
    type: String,
    enum: ['Scheduled', 'Arrived', 'Completed'],
    default: 'Scheduled'
  },
});

const Appointment = mongoose.model('Appointment', appointmentSchema);

module.exports = Appointment;
