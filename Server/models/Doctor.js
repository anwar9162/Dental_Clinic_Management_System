const mongoose = require('mongoose');
const bcrypt = require('bcrypt');

const doctorSchema = new mongoose.Schema({
  name: { type: String, required: true },
  specialty: { type: String, required: true },
  contactInfo: {
    phone: { type: String, required: true },
    gender: { type: String, required: true },
    address: { type: String, required: true },
  },
  username: { type: String, required: true, unique: true },
  password: { type: String, required: true },
  role: { type: String, default: 'Doctor', immutable: true } // Role is immutable
});

// Hash the password before saving
doctorSchema.pre('save', async function (next) {
  if (this.isModified('password') || this.isNew) {
    this.password = await bcrypt.hash(this.password, 10);
  }
  next();
});

// Method to compare passwords
doctorSchema.methods.comparePassword = async function (password) {
  return await bcrypt.compare(password, this.password);
};

const Doctor = mongoose.model('Doctor', doctorSchema);

module.exports = Doctor;
