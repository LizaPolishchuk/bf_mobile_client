import 'dart:async';

import 'package:rxdart/subjects.dart';
import 'package:salons_app_flutter_module/salons_app_flutter_module.dart';

class SalonsBloc {
  final GetSalonsListUseCase _getSalonsListUseCase;
  final UpdateSalonUseCase _updateSalonUseCase;

  SalonsBloc(
    this._getSalonsListUseCase,
    this._updateSalonUseCase,
  );

  List<Salon> _salonsList = [];

  int page = 1;
  int limit = 5;
  bool noMoreData = false;

  final _salonsLoadedSubject = PublishSubject<List<Salon>>();
  final _topSalonsLoadedSubject = PublishSubject<List<Salon>>();
  final _errorSubject = PublishSubject<String>();
  final _isLoadingSubject = PublishSubject<bool>();

  // output stream
  Stream<List<Salon>> get salonsLoaded => _salonsLoadedSubject.stream;
  Stream<List<Salon>> get topSalonsLoaded => _topSalonsLoadedSubject.stream;

  Stream<String> get errorMessage => _errorSubject.stream;

  Stream<bool> get isLoading => _isLoadingSubject.stream;

  loadTopSalons() async {
    final response = await _getSalonsListUseCase(loadTop: true);

    if (response.isLeft) {
      _errorSubject.add(response.left.message);
    } else {
      List<Salon> salonsList = response.right;

      print("_parseSalonsResponse ${salonsList.length}, page: $page");
      noMoreData = false;

      if (page == 1) {
        this._salonsList = salonsList;
      } else {
        if (salonsList.length == 0) {
          print("_parseSalonsResponse no more data set tot true");

          noMoreData = true;
        }
        this._salonsList.addAll(salonsList);
      }

      _topSalonsLoadedSubject.add(_salonsList);
    }
  }

  loadSalons(String searchText, {SearchFilters? searchFilters}) async {
    final response = await _getSalonsListUseCase(
        searchText: searchText,
        page: page,
        limit: limit,
        searchFilters: searchFilters);

    if (response.isLeft) {
      _errorSubject.add(response.left.message);
    } else {
      List<Salon> salonsList = response.right;

      print("_parseSalonsResponse ${salonsList.length}, page: $page");
      noMoreData = false;

      if (page == 1) {
        this._salonsList = salonsList;
      } else {
        if (salonsList.length == 0) {
          print("_parseSalonsResponse no more data set tot true");

          noMoreData = true;
        }
        this._salonsList.addAll(salonsList);
      }

      _salonsLoadedSubject.add(_salonsList);
    }
  }

  loadFavouriteSalons(String searchText) async {
    //todo change here to search for favourites salons
    final response = await _getSalonsListUseCase(
      searchText: searchText,
      page: page,
      limit: limit,
    );

    if (response.isLeft) {
      _errorSubject.add(response.left.message);
    } else {
      List<Salon> salonsList = response.right;

      print("_parseFavouriteSalonsResponse ${salonsList.length}, page: $page");
      noMoreData = false;

      if (page == 1) {
        this._salonsList = salonsList;
      } else {
        if (salonsList.length == 0) {
          print("_parseFavouriteSalonsResponse no more data set tot true");

          noMoreData = true;
        }
        this._salonsList.addAll(salonsList);
      }

      _salonsLoadedSubject.add(_salonsList);
    }
  }

  updateSalon(Salon salon, int index) async {
    var response = await _updateSalonUseCase(salon);

    if (response.isLeft) {
      _errorSubject.add(response.left.message);
    } else {
      _salonsList[index] = salon;
      _salonsLoadedSubject.add(_salonsList);
    }
  }
}
