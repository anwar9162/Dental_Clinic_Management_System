const Patient = require("../models/Patient");

const getAllPatients = async () => {
  return await Patient.find();
};

const getPatientById = async (id) => {
  return await Patient.findById(id);
};

const createPatient = async (patientData) => {
  const newPatient = new Patient(patientData);
  return await newPatient.save();
};

const updatePatient = async (id, patientData) => {
  return await Patient.findByIdAndUpdate(id, patientData, { new: true });
};

const deletePatient = async (id) => {
  return await Patient.findByIdAndDelete(id);
};

module.exports = {
  getAllPatients,
  getPatientById,
  createPatient,
  updatePatient,
  deletePatient,
};
