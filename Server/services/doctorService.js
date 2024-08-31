const Doctor = require('../models/Doctor');
const jwt = require('jsonwebtoken');
const bcrypt = require('bcrypt');

const getAllDoctors = async () => {
  return await Doctor.find();
};

const getDoctorById = async (id) => {
  return await Doctor.findById(id);
};

const createDoctor = async (doctorData) => {
  // Check if username already exists
  const existingDoctor = await Doctor.findOne({ username: doctorData.username });
  if (existingDoctor) {
    throw new Error('Username already exists');
  }

  const newDoctor = new Doctor(doctorData);
  return await newDoctor.save();
};

const updateDoctor = async (id, doctorData) => {
  const updateData = {};

  // Check for existing username
  if (doctorData.username) {
    const existingDoctor = await Doctor.findOne({ username: doctorData.username });
    if (existingDoctor && existingDoctor._id.toString() !== id) {
      throw new Error('Username already exists');
    }
    updateData.username = doctorData.username;
  }

  // Hash the password if it's being updated
  if (doctorData.password) {
    updateData.password = await bcrypt.hash(doctorData.password, 10);
  }

  // Update other fields
  if (doctorData.name) updateData.name = doctorData.name;
  if (doctorData.specialty) updateData.specialty = doctorData.specialty;
  if (doctorData.contactInfo) updateData.contactInfo = doctorData.contactInfo;

  return await Doctor.findByIdAndUpdate(id, updateData, { new: true });
};

const deleteDoctor = async (id) => {
  return await Doctor.findByIdAndDelete(id);
};

const loginDoctor = async (username, password) => {
  const doctor = await Doctor.findOne({ username });
  if (!doctor || !(await doctor.comparePassword(password))) {
    throw new Error('Invalid credentials');
  }
  const token = jwt.sign({ id: doctor._id, username: doctor.username }, process.env.JWT_SECRET, { expiresIn: '1h' });
  return token;
};

module.exports = {
  getAllDoctors,
  getDoctorById,
  createDoctor,
  updateDoctor,
  deleteDoctor,
  loginDoctor
};
