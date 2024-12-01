import 'package:flutter_bloc/flutter_bloc.dart';
import 'payment_event.dart';
import 'payment_state.dart';
import '../../../services/patient_api_service.dart';

class PaymentBloc extends Bloc<PaymentEvent, PaymentState> {
  final PatientApiService patientApiService;

  PaymentBloc(this.patientApiService) : super(PaymentInitial()) {
    on<AddPayment>(_onAddPayment);
  }

  Future<void> _onAddPayment(
      AddPayment event, Emitter<PaymentState> emit) async {
    emit(PaymentLoading());

    try {
      await patientApiService.addPayment(event.patientId, event.paymentData);
      emit(PaymentSuccess());
    } catch (e) {
      emit(PaymentError(e.toString()));
    }
  }
}
