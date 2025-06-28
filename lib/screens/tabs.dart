import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:meals/providers/favorites_provider.dart';
import 'package:meals/providers/filters_provider.dart';
import 'package:meals/providers/meals_provider.dart';
import 'package:meals/screens/categories.dart';
import 'package:meals/screens/filters.dart';
import 'package:meals/screens/meals.dart';
import 'package:meals/widgets/main_drawer.dart';

const kInitializeFilter = {
  Filters.glutenFree: false,
  Filters.LactoseFree: false,
  Filters.vegetarian: false,
  Filters.vegan: false,
};

class TabsScreen extends ConsumerStatefulWidget {
  const TabsScreen({super.key});

  @override
  ConsumerState<TabsScreen> createState() {
    return _TabsScreenState();
  }
}

class _TabsScreenState extends ConsumerState<TabsScreen> {
  int _selectedTabIndex = 0;
  // final List<Meal> _favorite = [];
  // Map<Filters, bool> _selectedFilters = kInitializeFilter;

  // void _showInfoMessage(String message) {
  //   ScaffoldMessenger.of(context).clearSnackBars();
  //   ScaffoldMessenger.of(
  //     context,
  //   ).showSnackBar(SnackBar(content: Text(message)));
  // }

  // void _toggleMealFavoriteStatus(Meal meal) {
  //   final isExisting = _favorite.contains(meal);

  //   if (isExisting) {
  //     setState(() {
  //       _favorite.remove(meal);
  //     });
  //     _showInfoMessage('Meal is no more Favorite');
  //   } else {
  //     setState(() {
  //       _favorite.add(meal);
  //     });
  //     _showInfoMessage('Marked as Favorite!');
  //   }
  // }

  void _setScreen(String identifiers) async {
    Navigator.of(context).pop();
    if (identifiers == 'filters') {
      await Navigator.of(context).push<Map<Filters, bool>>(
        MaterialPageRoute(builder: (ctx) => const FiltersScreen()),
      );
    }
  }

  void _selectTab(int index) {
    setState(() {
      _selectedTabIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    final meals = ref.watch(mealsProvider);
    final activefilters = ref.watch(filtersProvider);
    final availableMeals = meals.where((meals) {
      if ( activefilters[Filters.glutenFree]! && !meals.isGlutenFree) {
        return false;
      }
      if ( activefilters[Filters.LactoseFree]! && !meals.isLactoseFree) {
        return false;
      }
      if ( activefilters[Filters.vegetarian]! && !meals.isVegetarian) {
        return false;
      }
      if ( activefilters[Filters.vegan]! && !meals.isVegan) {
        return false;
      }
      return true;
    }).toList();

    Widget activeScreen = CategoriesScreen(
      // onToggleFavorite: _toggleMealFavoriteStatus,
      availableMeals: availableMeals,
    );
    var title = 'Categories';

    if (_selectedTabIndex == 1) {
      final favoriteMeals = ref.watch(favoriteMealProvider);
      activeScreen = MealsScreen(
        meals: favoriteMeals,
        // onToggleFavorite: _toggleMealFavoriteStatus,
      );
      title = 'Your Favorites';
    }

    return Scaffold(
      appBar: AppBar(title: Text(title)),
      drawer: MainDrawer(onselectedscreen: _setScreen),
      body: activeScreen,
      bottomNavigationBar: BottomNavigationBar(
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.set_meal),
            label: 'Categories',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.favorite),
            label: 'Favorites',
          ),
        ],
        onTap: _selectTab,
        currentIndex: _selectedTabIndex,
      ),
    );
  }
}
