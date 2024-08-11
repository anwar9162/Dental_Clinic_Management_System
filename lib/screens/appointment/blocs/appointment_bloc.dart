import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../services/appointment_api_service.dart';
import 'appointment_event.dart';
import 'appointment_state.dart';

class AppointmentBloc extends Bloc<AppointmentEvent, AppointmentState> {
  final AppointmentService _appointmentService;

  AppointmentBloc(this._appointmentService) : super(AppointmentInitial()) {
    on<FetchAllAppointments>(_onFetchAllAppointments);
    on<FetchAppointmentById>(_onFetchAppointmentById);
    on<CreateAppointment>(_onCreateAppointment);
    on<UpdateAppointment>(_onUpdateAppointment);
    on<DeleteAppointment>(_onDeleteAppointment);
    on<FetchTodaysAppointments>(_onFetchTodaysAppointments);
    on<FetchVisitHistory>(_onFetchVisitHistory);
  }

  Future<void> _onFetchAllAppointments(
      FetchAllAppointments event, Emitter<AppointmentState> emit) async {
    emit(AppointmentLoading());
    try {
      final appointments = await _appointmentService.getAllAppointments();
      emit(AppointmentLoaded(appointments));
    } catch (e) {
      emit(AppointmentError('Failed to load appointments: ${e.toString()}'));
    }
  }

  Future<void> _onFetchAppointmentById(
      FetchAppointmentById event, Emitter<AppointmentState> emit) async {
    emit(AppointmentLoading());
    try {
      final appointment =
          await _appointmentService.getAppointmentById(event.id);
      emit(AppointmentSuccess(appointment));
    } catch (e) {
      emit(AppointmentError('Failed to load appointment: ${e.toString()}'));
    }
  }

  Future<void> _onCreateAppointment(
      CreateAppointment event, Emitter<AppointmentState> emit) async {
    emit(AppointmentLoading());
    try {
      final appointment =
          await _appointmentService.createAppointment(event.appointment);
      emit(AppointmentSuccess(appointment));
    } catch (e) {
      emit(AppointmentError('Failed to create appointment: ${e.toString()}'));
    }
  }

  Future<void> _onUpdateAppointment(
      UpdateAppointment event, Emitter<AppointmentState> emit) async {
    emit(AppointmentLoading());
    try {
      final appointment = await _appointmentService.updateAppointment(
          event.id, event.appointment);
      emit(AppointmentSuccess(appointment));
    } catch (e) {
      emit(AppointmentError('Failed to update appointment: ${e.toString()}'));
    }
  }

  Future<void> _onDeleteAppointment(
      DeleteAppointment event, Emitter<AppointmentState> emit) async {
    emit(AppointmentLoading());
    try {
      await _appointmentService.deleteAppointment(event.id);
      emit(AppointmentInitial()); // Optionally refresh or notify deletion
    } catch (e) {
      emit(AppointmentError('Failed to delete appointment: ${e.toString()}'));
    }
  }

  Future<void> _onFetchTodaysAppointments(
      FetchTodaysAppointments event, Emitter<AppointmentState> emit) async {
    emit(AppointmentLoading());
    try {
      final appointments = await _appointmentService.getTodaysAppointments();
      emit(AppointmentLoaded(appointments));
    } catch (e) {
      emit(AppointmentError(
          'Failed to load today\'s appointments: ${e.toString()}'));
    }
  }

  Future<void> _onFetchVisitHistory(
      FetchVisitHistory event, Emitter<AppointmentState> emit) async {
    emit(AppointmentLoading());
    try {
      final appointments =
          await _appointmentService.getVisitHistory(event.patientId);
      emit(AppointmentLoaded(appointments));
    } catch (e) {
      emit(AppointmentError('Failed to load visit history: ${e.toString()}'));
    }
  }
}
