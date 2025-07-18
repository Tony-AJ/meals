import 'package:flutter/material.dart';

import 'package:meals/models/meal.dart';
import 'package:meals/screens/meal_detail.dart';
import 'package:meals/widgets/meal_item.dart';

class MealsScreen extends StatelessWidget {
  const MealsScreen({
    super.key,
    this.title,
    required this.meals,
  });

  final String? title;
  final List<Meal> meals;

  void selectMeal(BuildContext context, Meal meal) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (ctx) =>
            MealDetailScreen(meal: meal,
            ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // Default content to display when meals list is empty
    Widget content = Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Display a message when meals list is empty
          Text(
            'Uh oh ... nothing here!',
            style:
                Theme.of(context).textTheme.headlineLarge?.copyWith(
                  color: Theme.of(context).colorScheme.onBackground,
                ) ??
                TextStyle(
                  color: Theme.of(context).colorScheme.onBackground,
                  fontSize: 24,
                ),
          ),
          const SizedBox(height: 16),
          // Display a message to select a different category
          Text(
            'Try selecting a different category!',
            style:
                Theme.of(context).textTheme.bodyLarge?.copyWith(
                  color: Theme.of(context).colorScheme.onBackground,
                ) ??
                TextStyle(
                  color: Theme.of(context).colorScheme.onBackground,
                  fontSize: 16,
                ),
          ),
        ],
      ),
    );

    // If meals list is not empty, display the meals
    if (meals.isNotEmpty) {
      content = ListView.builder(
        itemCount: meals.length,
        itemBuilder: (ctx, index) => MealItem(
          meal: meals[index],
          onselectMeal: (context, meal) {
            selectMeal(context, meal);
          },
        ),
      );
    }

    if (title == null || title!.isEmpty) {
      return content;
    }
    return Scaffold(
      appBar: AppBar(title: Text(title!)),
      body: content,
    );
  }
}
