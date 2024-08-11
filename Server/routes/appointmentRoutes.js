const express = require('express');
const {
  getAllAppointments,
  getAppointmentById,
  createAppointment,
  updateAppointment,
  deleteAppointment,
  getTodaysAppointments,

  getVisitHistory,
} = require('../controllers/appointmentController');

const router = express.Router();

router.get('/', getAllAppointments);
router.get('/:id', getAppointmentById);
router.post('/', createAppointment);
router.put('/:id', updateAppointment);
router.delete('/:id', deleteAppointment);

// New routes for the additional functionalities
router.get('/today/appointments', getTodaysAppointments);
router.get('/history/:patientId', getVisitHistory);

module.exports = router;
