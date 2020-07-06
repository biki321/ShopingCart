import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutterui/blocs/products/products_bloc.dart';
import 'package:flutterui/components/brands_logos_list.dart';
import 'package:flutterui/components/circularLoader.dart';
import 'package:flutterui/components/productCard.dart';
import 'package:flutterui/components/vertical_navigationBar.dart';
import 'package:flutterui/screens/drawer.dart';

class Homepage extends StatefulWidget {
  @override
  _HomepageState createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      left: true,
      right: true,
      top: true,
      bottom: true,
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: Colors.white,
          iconTheme: new IconThemeData(color: Colors.black), //DRAWER ICON COLOR
          elevation: 0.0,
          // the logo of the app(company for example)
          title: Image.asset(
            'assets/logo/logoUpdated.png',
            fit: BoxFit.contain,
          ),
        ),
        body: HomeScreen(),
        //bottomNavigationBar: BottomNav(),
        drawer: DrawerScreen(),
      ),
    );
  }
}

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final _scrollController = ScrollController();
  final _scrollThreshold = 200.0;
  ProductsBloc _productsBloc;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
    _productsBloc = BlocProvider.of<ProductsBloc>(context);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(0.0),
      margin: EdgeInsets.only(
        top: 10,        
      ),
      child: Column(
        children: <Widget>[
          BlocBuilder<ProductsBloc, ProductsState>(
              condition: (previousState, state) {
            if (state is ProductsLoaded)
              return true;
            else
              return false;
          }, builder: (BuildContext context, state) {
            if (state is ProductsLoaded) {
              return SizedBox(
                height: 60.0,
                child: ListView(
                  scrollDirection: Axis.horizontal,
                  padding: EdgeInsets.only(left: 10),
                  //list of logos for the horizontal listview of brands
                  //this _productsBloc.brandName is  brand which data will be loaded
                  children: brandsLogosList(_productsBloc.brandName),
                ),
              );
            } else {
              return Container(
                width: 0.0,
                height: 0.0,
              );
            }
          }),
          SizedBox(height: 30),
          Expanded(
            child: Container(
              padding: EdgeInsets.all(0.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  VerticalNavBar(),
                  SizedBox(width: 5.0),
                  Spacer(),
                  SizedBox(
                    width: MediaQuery.of(context).size.width * 0.70,
                    child: BlocBuilder<ProductsBloc, ProductsState>(
                        builder: (BuildContext context, state) {
                      if (state is ProductsUninitialized) {
                        return Center(
                          child: SizedBox(
                            width: 33,
                            height: 33,
                            child: CircularProgressIndicator(
                              strokeWidth: 1.5,
                            ),
                          ),
                        );
                      }
                      if (state is ProductsError) {
                        return Center(
                          child: Text('failed to fetch posts'),
                        );
                      }
                      if (state is ProductsLoaded) {
                        if (state.products.isEmpty) {
                          return Center(
                            child: Text('no posts'),
                          );
                        }
                        return ListView.builder(
                          padding: EdgeInsets.only(right: 10.0),
                          itemBuilder: (context, index) {
                            return index >= state.products.length
                                ? CircularLoader()
                                : ProductCard(product: state.products[index]);
                          },
                          itemCount: state.hasReachedMax
                              ? state.products.length
                              : state.products.length + 1,
                          controller: _scrollController,
                        );
                      }
                    }),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    final maxScroll = _scrollController.position.maxScrollExtent;
    final currentScroll = _scrollController.position.pixels;
    if (maxScroll - currentScroll <= _scrollThreshold) {
      _productsBloc
          .add(Fetch(brandName: _productsBloc.brandName, isNewBrand: false));
    }
  }
}
