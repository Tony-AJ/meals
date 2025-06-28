import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:meals/providers/meals_provider.dart';

enum Filters { glutenFree, LactoseFree, vegetarian, vegan }

class FiltersNotifier extends StateNotifier<Map<Filters, bool>> {
  FiltersNotifier()
    : super({
        Filters.glutenFree: false,
        Filters.LactoseFree: false,
        Filters.vegetarian: false,
        Filters.vegan: false,
      });

  void setFilters(Map<Filters, bool> choosenfilter) {
    state = choosenfilter;
  }

  void setFilter(Filters filter, bool isActive) {
    state = {...state, filter: isActive};
  }
}

final filtersProvider =
    StateNotifierProvider<FiltersNotifier, Map<Filters, bool>>(
      (ref) => FiltersNotifier(),
    );

final filteredMealProvider = Provider((ref) {
  final meals = ref.watch(mealsProvider);
  final activefilters = ref.watch(filtersProvider);

  return meals.where((meals) {
    if (activefilters[Filters.glutenFree]! && !meals.isGlutenFree) {
      return false;
    }
    if (activefilters[Filters.LactoseFree]! && !meals.isLactoseFree) {
      return false;
    }
    if (activefilters[Filters.vegetarian]! && !meals.isVegetarian) {
      return false;
    }
    if (activefilters[Filters.vegan]! && !meals.isVegan) {
      return false;
    }
    return true;
  }).toList();
});
