import 'package:flutter/material.dart';

import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';

import 'package:tryme/Globals.dart';
import 'package:tryme/Request.dart';
import 'package:tryme/Styles.dart';
import 'package:tryme/widgets/SearchBar.dart';

class HomeView extends StatefulWidget {
  @override
  _HomeViewState createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  @override
  void initState() {
    super.initState();
    getData();
  }

  void getData() async {
    if (categories.length == 0)
      Request.getCategories().whenComplete(() => setState(() {}));
  }

  Widget _categoryCard(Category category, int index) {
    return Stack(
      children: [
        index == 0
            ? Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(Styles.cardRadius),
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(Styles.cardRadius),
                  child: Padding(
                    padding: const EdgeInsets.all(24.0),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Expanded(
                          flex: 1,
                          child: Padding(
                            padding: const EdgeInsets.only(top: 50),
                            child: Text(
                              category.name,
                              style: TextStyle(
                                  color: Styles.colors.title, fontSize: 16),
                            ),
                          ),
                        ),
                        Expanded(
                          flex: 3,
                          child: Image(
                            image: NetworkImage(category.picture),
                            fit: BoxFit.contain,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              )
            : Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Expanded(
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(Styles.cardRadius),
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(Styles.cardRadius),
                        child: Padding(
                          padding: const EdgeInsets.all(24.0),
                          child: Image(
                            image: NetworkImage(category.picture),
                            fit: BoxFit.contain,
                          ),
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 12.0, top: 4.0),
                    child: Text(
                      category.name,
                      style: TextStyle(
                        color: Styles.colors.title,
                        fontSize: 14,
                      ),
                    ),
                  ),
                ],
              ),
        Positioned.fill(
          child: Material(
            color: Colors.transparent,
            child: InkWell(
              borderRadius: BorderRadius.circular(Styles.cardRadius),
              onTap: () => Navigator.pushNamed(
                  context, 'searchResult/${category.name}/'),
            ),
          ),
        ),
      ],
    );
  }

  Widget _listCategories() {
    return Expanded(
      child: StaggeredGridView.countBuilder(
        padding: const EdgeInsets.symmetric(
            horizontal: Styles.mainHorizontalPadding),
        crossAxisCount: 4,
        mainAxisSpacing: 16.0,
        crossAxisSpacing: 12.0,
        staggeredTileBuilder: (int index) =>
            StaggeredTile.count(index == 0 ? 4 : 2, 3),
        itemCount: categories.length,
        itemBuilder: (BuildContext context, int index) =>
            _categoryCard(categories[index], index),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Styles.colors.background,
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.only(
                left: Styles.mainHorizontalPadding,
                right: Styles.mainHorizontalPadding,
                bottom: 8.0),
            child: SearchBar(
              onSubmitted: (keywords) =>
                  Navigator.pushNamed(context, 'searchResult//$keywords'),
            ),
          ),
          _listCategories(),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Styles.colors.main,
        onPressed: () {
          Navigator.pushNamed(context, 'addProduct');
        },
        child: Icon(Icons.add),
      ),
    );
  }
}
