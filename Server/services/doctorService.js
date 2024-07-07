const Doctor = require("../models/Doctor");

const getAllDoctors = async () => {
  return await Doctor.find();
};

const getDoctorById = async (id) => {
  return await Doctor.findById(id);
};

const createDoctor = async (doctorData) => {
  const newDoctor = new Doctor(doctorData);
  return await newDoctor.save();
};

const updateDoctor = async (id, doctorData) => {
  return await Doctor.findByIdAndUpdate(id, doctorData, { new: true });
};

const deleteDoctor = async (id) => {
  return await Doctor.findByIdAndDelete(id);
};

module.exports = {
  getAllDoctors,
  getDoctorById,
  createDoctor,
  updateDoctor,
  deleteDoctor,
};
