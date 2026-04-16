import 'package:flutter_bloc/flutter_bloc.dart';

import '../model/ad_item.dart';

/*
 * Event
 */
abstract class AdListEvent {}

class LoadAdList extends AdListEvent {
  LoadAdList();
}

/*
 * State
 */
abstract class AdListState {}

class AdListInitial extends AdListState {}

class AdListLoaded extends AdListState {
  final List<AdItem> items;

  AdListLoaded(this.items);
}

/*
 * BloC
 */
class AdListBloc extends Bloc<AdListEvent, AdListState> {
  AdListBloc() : super(AdListInitial()) {
    on<LoadAdList>(_onLoad);
  }

  void _onLoad(LoadAdList event, Emitter<AdListState> emit) {
    int id = 0;

    final items = <AdItem>[
      // BASIC
      AdItem(id: id++, type: AdViewType.banner, category: AdCategory.basic),
      AdItem(id: id++, type: AdViewType.popup, category: AdCategory.basic),
      AdItem(id: id++, type: AdViewType.inPage, category: AdCategory.basic),
      AdItem(id: id++, type: AdViewType.welcome, category: AdCategory.basic),
      AdItem(id: id++, type: AdViewType.catfish, category: AdCategory.basic),
      AdItem(id: id++, type: AdViewType.home, category: AdCategory.basic),

      // MIX
      AdItem(id: id++, type: AdViewType.list, category: AdCategory.mix),
      AdItem(id: id++, type: AdViewType.stickyList, category: AdCategory.mix),
    ];

    emit(AdListLoaded(items));
  }
}
