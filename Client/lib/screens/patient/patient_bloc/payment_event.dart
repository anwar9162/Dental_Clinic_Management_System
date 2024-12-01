import 'package:equatable/equatable.dart';

abstract class PaymentEvent extends Equatable {
  @override
  List<Object> get props => [];
}

class AddPayment extends PaymentEvent {
  final String patientId;
  final Map<String, dynamic> paymentData;

  AddPayment({required this.patientId, required this.paymentData});

  @override
  List<Object> get props => [patientId, paymentData];
}
