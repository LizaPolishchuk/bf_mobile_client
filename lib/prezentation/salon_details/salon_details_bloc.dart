import 'dart:async';

import 'package:rxdart/subjects.dart';
import 'package:salons_app_flutter_module/salons_app_flutter_module.dart';

class SalonDetailsBloc {
  final GetSalonByIdUseCase _getSalonByIdUseCase;
  final GetPromoListUseCase _getPromoListUseCase;
  final GetBonusCardListUseCase _getBonusCardListUseCase;
  final UpdateSalonUseCase _updateSalonUseCase;

  SalonDetailsBloc(this._getSalonByIdUseCase, this._getPromoListUseCase,
      this._getBonusCardListUseCase, this._updateSalonUseCase);

  final _salonLoadedSubject = PublishSubject<Salon>();
  final _promosLoadedSubject = PublishSubject<List<Promo>>();
  final _bonusCardsLoadedSubject = PublishSubject<List<BonusCard>>();
  final _errorSubject = PublishSubject<String>();
  final _isLoadingSubject = PublishSubject<bool>();

  // output stream
  Stream<Salon> get salonLoaded => _salonLoadedSubject.stream;

  Stream<List<Promo>> get promosLoaded => _promosLoadedSubject.stream;

  Stream<List<BonusCard>> get bonusCardsLoaded =>
      _bonusCardsLoadedSubject.stream;

  Stream<String> get errorMessage => _errorSubject.stream;

  Stream<bool> get isLoading => _isLoadingSubject.stream;

  loadSalonById(String salonId) async {
    _isLoadingSubject.add(true);

    final response = await _getSalonByIdUseCase(salonId);

    if (response.isLeft) {
      _errorSubject.add(response.left.message);
    } else {
      _salonLoadedSubject.add(response.right);
    }

    _isLoadingSubject.add(false);
  }

  loadPromos(String salonId) async {
    // _isLoadingSubject.add(true);

    final response = await _getPromoListUseCase(salonId);

    if (response.isLeft) {
      _errorSubject.add(response.left.message);
    } else {
      _promosLoadedSubject.add(response.right);
    }

    // _isLoadingSubject.add(false);
  }

  loadBonusCards(String salonId) async {
    // _isLoadingSubject.add(true);

    final response = await _getBonusCardListUseCase(salonId);

    if (response.isLeft) {
      _errorSubject.add(response.left.message);
    } else {
      _bonusCardsLoadedSubject.add(response.right);
    }

    // _isLoadingSubject.add(false);
  }

  updateSalon(Salon salon) async {
    final response = await _updateSalonUseCase(salon);

    if (response.isLeft) {
      _errorSubject.add(response.left.message);
    } else {
      _salonLoadedSubject.add(salon);
    }
  }
}
