import 'dart:async';

import 'package:rxdart/subjects.dart';
import 'package:salons_app_flutter_module/salons_app_flutter_module.dart';
import 'package:salons_app_mobile/utils/error_parser.dart';

class AppointmentsBloc {
  final AppointmentRepository _appointmentRepository;
  final LocalStorage _localStorage;

  AppointmentsBloc(this._appointmentRepository, this._localStorage);

  List<AppointmentEntity> _appointmentsList = [];

  final _appointmentsLoadedSubject = PublishSubject<List<AppointmentEntity>>();
  final _appointmentUpdatedSubject = PublishSubject<void>();
  final _errorSubject = PublishSubject<String>();
  final _isLoadingSubject = PublishSubject<bool>();

  // output stream
  Stream<List<AppointmentEntity>> get appointmentsLoaded =>
      _appointmentsLoadedSubject.stream;

  Stream<void> get appointmentUpdated => _appointmentUpdatedSubject.stream;

  Stream<String> get errorMessage => _errorSubject.stream;

  Stream<bool> get isLoading => _isLoadingSubject.stream;

  getAppointmentsForCurrentUser(
      {String? dateFor, String? dateFrom, String? dateTo}) async {
    try {
      String userId = _localStorage.getUserId();
      var response = await _appointmentRepository.getUserAppointments(userId);
      _appointmentsList = response;
      _appointmentsLoadedSubject.add(_appointmentsList);
    } catch (error) {
      _errorSubject.add(ErrorParser.parseError(error));
    }
  }

  getOrdersForCurrentMaster(
      {String? dateFor, String? dateFrom, String? dateTo}) async {
    try {
      String userId = _localStorage.getUserId();
      var response = await _appointmentRepository.getMasterAppointments(userId);
      _appointmentsList = response;
      _appointmentsLoadedSubject.add(_appointmentsList);
    } catch (error) {
      _errorSubject.add(ErrorParser.parseError(error));
    }
  }

  // getAvailableOrdersByTime(
  //     String salonId, String serviceId, String masterId, String date) async {
  //   final response =
  //       await _getAvailableTimeUseCase(salonId, serviceId, masterId, date);
  //   print("LoadAvailableTimeEvent");
  //
  //   if (response.isLeft) {
  //     _errorSubject.add(response.left.message);
  //   } else {
  //     _appointmentsList = response.right;
  //     _appointmentsLoadedSubject.add(_appointmentsList);
  //   }
  // }

  cancelAppointment(AppointmentEntity appointment) async {
    //todo after canceling appointment should be checking on BE side if there is signed users on it and send push to them
    // AppointmentEntity appointmentToUpdate =
    //     appointment.copy(clientName: "", clientId: "");
    // final response = await _updateOrderUseCase(appointmentToUpdate);
    //
    // if (response.isLeft) {
    //   _errorSubject.add(response.left.message);
    // } else {
    //   _appointmentsList.remove(appointmentToUpdate);
    //   _appointmentsLoadedSubject.add(_appointmentsList);
    //
    //   _localStorage.setOrdersList(_appointmentsList);
    // }
  }

  updateAppointment(String uuid, CreateAppointmentRequest appointmentRequest) async {
    try {
      var response = await _appointmentRepository.updateAppointment(uuid,appointmentRequest );
      // _appointmentsList = response;
      // _appointmentsLoadedSubject.add(_appointmentsList);
    } catch (error) {
      _errorSubject.add(ErrorParser.parseError(error));
    }
  }

  pinAppointment(AppointmentEntity appointment, int index) async {
    // AppointmentEntity appointmentToUpdate = appointment;
    // appointmentToUpdate.isPinned = !appointmentToUpdate.isPinned;
    //
    // if (_appointmentsList.contains(appointmentToUpdate)) {
    //   _appointmentsList[index] = appointmentToUpdate;
    //   _appointmentsLoadedSubject.add(_appointmentsList);
    //
    //   _localStorage.setOrdersList(_appointmentsList);
    // }
  }

  dispose() {
    _appointmentUpdatedSubject.close();
    _appointmentsLoadedSubject.close();
    _isLoadingSubject.close();
    _errorSubject.close();
  }
}
