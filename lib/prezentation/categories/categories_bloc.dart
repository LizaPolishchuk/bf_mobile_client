import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:salons_app_flutter_module/salons_app_flutter_module.dart';
import 'package:salons_app_mobile/prezentation/categories/categories_event.dart';
import 'package:salons_app_mobile/prezentation/categories/categories_state.dart';

class CategoriesBloc extends Bloc<CategoriesEvent, CategoriesState> {
  final GetCategoriesListUseCase getCategoriesListUseCase;

  List<Category> categoryList = [];

  CategoriesBloc(this.getCategoriesListUseCase)
      : super(InitialCategoriesListState()) {
    streamController = StreamController<List<Category>>.broadcast();
  }

  void dispose() {
    streamController.close();
  }

  late StreamController<List<Category>> streamController;

  StreamSink<List<Category>> get streamSink => streamController.sink;

  Stream<List<Category>> get streamCategories => streamController.stream;

  @override
  Stream<CategoriesState> mapEventToState(
    CategoriesEvent event,
  ) async* {
    if (event is LoadCategoriesListEvent) {
      final categoryListOrError = await getCategoriesListUseCase(event.salonId);
      categoryListOrError.fold((failure) {
        streamSink.addError(failure.message);
      }, (categoryList) {
        this.categoryList = categoryList;
        streamSink.add(categoryList);
      });
    } else if(event is SearchCategoriesEvent){
       List<Category> foundCategories = this.categoryList.where((categ) => categ.name.contains(event.searchKey)).toList();
       streamSink.add(foundCategories);
    }
  }
}
