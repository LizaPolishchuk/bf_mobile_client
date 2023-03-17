import 'dart:async';

import 'package:bf_mobile_client/utils/error_parser.dart';
import 'package:rxdart/subjects.dart';
import 'package:salons_app_flutter_module/salons_app_flutter_module.dart';

class SalonDetailsBloc {
  final SalonRepository _salonRepository;
  final PromoRepository _promoRepository;

  SalonDetailsBloc(this._salonRepository, this._promoRepository);

  final _salonLoadedSubject = PublishSubject<Salon>();
  final _promosLoadedSubject = PublishSubject<List<Promo>>();
  final _bonusCardsLoadedSubject = PublishSubject<List<Promo>>();
  final _errorSubject = PublishSubject<String>();
  final _isLoadingSubject = PublishSubject<bool>();

  // output stream
  Stream<Salon> get salonLoaded => _salonLoadedSubject.stream;

  Stream<List<Promo>> get promosLoaded => _promosLoadedSubject.stream;

  Stream<List<Promo>> get bonusCardsLoaded => _bonusCardsLoadedSubject.stream;

  Stream<String> get errorMessage => _errorSubject.stream;

  Stream<bool> get isLoading => _isLoadingSubject.stream;

  loadSalonById(String salonId) async {
    try {
      _isLoadingSubject.add(true);

      var response = await _salonRepository.getSalon(salonId);
      _salonLoadedSubject.add(response);

      _isLoadingSubject.add(false);
    } catch (error) {
      _isLoadingSubject.add(false);
      _errorSubject.add(ErrorParser.parseError(error));
    }
  }

  loadPromos(String salonId, PromoType promoType) async {
    try {
      var response = await _promoRepository.getSalonPromos(salonId);
      _promosLoadedSubject.add(response);
    } catch (error) {
      _errorSubject.add(ErrorParser.parseError(error));
    }
  }

  // loadBonusCards(String salonId) async {
  //   // _isLoadingSubject.add(true);
  //
  //   final response = await _getBonusCardListUseCase(salonId);
  //
  //   if (response.isLeft) {
  //     _errorSubject.add(response.left.message);
  //   } else {
  //     _bonusCardsLoadedSubject.add(response.right);
  //   }
  //
  //   // _isLoadingSubject.add(false);
  // }

  updateSalon(Salon salon) async {
    try {
      var response = await _salonRepository.updateSalon(salon);
      _salonLoadedSubject.add(salon);
    } catch (error) {
      _errorSubject.add(ErrorParser.parseError(error));
    }
  }
}
