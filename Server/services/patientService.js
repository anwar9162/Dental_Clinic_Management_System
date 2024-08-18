const Patient = require("../models/Patient");

const getAllPatients = async () => {
  return await Patient.find();
};

const getPatientById = async (id) => {
  return await Patient.findById(id).populate("visitHistory");
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

const updateCardStatus = async (id, cardStatus) => {
  return await Patient.findByIdAndUpdate(
    id,
    { cardStatus: cardStatus },
    { new: true }
  );
};
const getTodaysPatient = async () => {
  const today = new Date();
  today.setHours(0, 0, 0, 0);
  const tomorrow = new Date(today);
  tomorrow.setDate(today.getDate() + 1);
  console.log(today);
  return await Patient.find({
    createdAt: { $gte: today, $lt: tomorrow },
  });
};

module.exports = {
  getAllPatients,
  getPatientById,
  createPatient,
  updatePatient,
  deletePatient,
  updateCardStatus,
  getTodaysPatient,
};
