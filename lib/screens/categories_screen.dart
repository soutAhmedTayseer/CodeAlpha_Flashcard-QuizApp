import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_projects/screens/questions_api_screen.dart';
import 'package:flutter_projects/components/searchbar_widget.dart';
import '../components/background_widget.dart';

class CategoriesScreen extends StatefulWidget {
  const CategoriesScreen({super.key});

  @override
  _CategoriesScreenState createState() => _CategoriesScreenState();
}

class _CategoriesScreenState extends State<CategoriesScreen> {
  final List<Map<String, dynamic>> categories = [
    {'title': 'general knowledge'.tr(), 'id': 9, 'image': 'assets/images/general knowledge.jpeg'},
    {'title': 'books'.tr(), 'id': 10, 'image': 'assets/images/books.jpeg'},
    {'title': 'film'.tr(), 'id': 11, 'image': 'assets/images/film.jpeg'},
    {'title': 'music'.tr(), 'id': 12, 'image': 'assets/images/music.jpeg'},
    {'title': 'science'.tr(), 'id': 17, 'image': 'assets/images/science.jpeg'},
    {'title': 'geography'.tr(), 'id': 22, 'image': 'assets/images/geography.jpeg'},
    {'title': 'history'.tr(), 'id': 23, 'image': 'assets/images/history.jpeg'},
    {'title': 'politics'.tr(), 'id': 24, 'image': 'assets/images/politics.jpeg'},
    {'title': 'sports'.tr(), 'id': 21, 'image': 'assets/images/sports.jpeg'},
    {'title': 'animals'.tr(), 'id': 27, 'image': 'assets/images/animals.jpeg'},
  ];

  String searchQuery = ''; // To hold the search query

  @override
  Widget build(BuildContext context) {
    final filteredCategories = categories
        .where((category) =>
        category['title'].toLowerCase().contains(searchQuery.toLowerCase()))
        .toList();

    return Scaffold(
      body: Stack(
        children: [
          const BackgroundImage(imagePath: 'assets/images/background home3.jpeg'), // Use BackgroundImage

          Column(
            children: [
              CustomSearchBar(
                onChanged: (value) {
                  setState(() {
                    searchQuery = value;
                  });
                },
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: GridView.builder(
                    itemCount: filteredCategories.length,
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      crossAxisSpacing: 16,
                      mainAxisSpacing: 16,
                      childAspectRatio: 1,
                    ),
                    itemBuilder: (BuildContext context, int index) {
                      final category = filteredCategories[index];
                      return GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => QuestionsScreen(
                                categoryTitle: category['title'],
                                categoryId: category['id'],
                              ),
                            ),
                          );
                        },
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(16),
                            image: DecorationImage(
                              image: AssetImage(category['image']),
                              fit: BoxFit.cover,
                            ),
                          ),
                          child: Align(
                            alignment: Alignment.bottomCenter,
                            child: Container(
                              width: double.infinity,
                              padding: const EdgeInsets.all(8.0),
                              decoration: BoxDecoration(
                                color: Colors.black.withOpacity(0.6),
                                borderRadius: const BorderRadius.only(
                                  bottomLeft: Radius.circular(16),
                                  bottomRight: Radius.circular(16),
                                ),
                              ),
                              child: Text(
                                category['title'],
                                textAlign: TextAlign.center,
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold,
                                  shadows: [
                                    Shadow(
                                      offset: Offset(2, 2),
                                      blurRadius: 3.0,
                                      color: Colors.black54,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
