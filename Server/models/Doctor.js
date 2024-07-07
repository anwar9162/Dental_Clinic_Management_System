const mongoose = require("mongoose");

const doctorSchema = new mongoose.Schema({
  name: { type: String, required: true },
  specialization: { type: String, required: true },
  contactInfo: {
    phone: { type: String, required: true },
    email: { type: String, required: true },
    address: { type: String, required: true },
  },
  availableDays: { type: [String], required: true }, // e.g., ['Monday', 'Wednesday', 'Friday']
  availableTimeSlots: { type: [String], required: true }, // e.g., ['09:00-12:00', '13:00-15:00']
});

const Doctor = mongoose.model("Doctor", doctorSchema);

module.exports = Doctor;
