// models/Arrival.js
const mongoose = require("mongoose");

const arrivalSchema = new mongoose.Schema({
  patientId: {
    type: mongoose.Schema.Types.ObjectId,
    ref: "Patient",
    required: true,
  },
  arrivalTime: {
    type: Date,
    required: true,
  },
  notes: {
    type: String,
    required: false,
  },
  arrivalType: {
    type: String,
    enum: ["On Appointment", "Walk-in"],
    required: true,
  },
});

module.exports = mongoose.model("Arrival", arrivalSchema);
