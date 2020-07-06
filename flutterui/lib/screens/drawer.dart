import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_phoenix/flutter_phoenix.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutterui/blocs/auth/auth_bloc.dart';

class DrawerScreen extends StatefulWidget {
  @override
  _DrawerScreenState createState() => _DrawerScreenState();
}

class _DrawerScreenState extends State<DrawerScreen> {
  AuthBloc _authBloc;

  Widget _createHeader() {
    return DrawerHeader(
      margin: EdgeInsets.zero,
      padding: EdgeInsets.zero,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          IconButton(
              icon: Icon(
                Icons.arrow_back,
                color: Colors.white,
              ),
              onPressed: () => Navigator.pop(context)),
          RawMaterialButton(
            onPressed: () {},
            elevation: 0.0,
            fillColor: Colors.white,
            child: Icon(
              Icons.person_outline,
              size: 30.0,
            ),
            padding: EdgeInsets.all(15.0),
            shape: CircleBorder(),
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                "Biki Deka",
                style: TextStyle(
                    fontFamily: 'Roboto',
                    color: Color.fromARGB(230, 255, 255, 255),
                    fontWeight: FontWeight.w900,
                    fontSize: 20),
              ),
              SizedBox(
                height: 10,
              ),
              Text(
                "biki@gmail.com",
                style: TextStyle(
                    fontFamily: 'Roboto',
                    color: Color.fromARGB(255, 191, 254, 254),
                    //fontWeight: FontWeight.normal,
                    fontSize: 15),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _createDrawerItem(
      {IconData icon, String text, GestureTapCallback onTap}) {
    return ListTile(
      title: Row(
        children: <Widget>[
          SizedBox(width: 40),
          //Icon(icon, color: Color.fromARGB(255, 95, 181, 249)),
          Icon(icon, color: Color.fromARGB(255,191, 254, 254)),
          Padding(
            padding: EdgeInsets.only(left: 15.0),
            child: Text(
              text,
              style: TextStyle(
                fontFamily: 'Roboto',
                fontSize: 18,
                color: Color.fromARGB(230, 255, 255, 255),
                fontWeight: FontWeight.w900,
              ),
            ),
          ),
        ],
      ),
      onTap: onTap,
    );
  }

  @override
  void initState() {
    super.initState();
    _authBloc = BlocProvider.of<AuthBloc>(context);
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      elevation: 1.0,
      child: Container(
        color: Color.fromARGB(250, 25, 119, 210),
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            _createHeader(),
            SizedBox(
              height: 20,
            ),
            _createDrawerItem(
                icon: Icons.home,
                text: "Home",
                onTap: () {
                  Navigator.popAndPushNamed(context, '/homePage');
                }),
            _createDrawerItem(icon: Icons.person, text: "Account", onTap: null),
            _createDrawerItem(
                icon: Icons.shopping_cart,
                text: "Shopping Cart",
                onTap: () {
                  //these 2 lines didnot worked
                  // Navigator.pop(context);
                  // Navigator.push(context,
                  //     MaterialPageRoute(builder: (context) => CartPage()));
                  Navigator.popAndPushNamed(context, '/cartPage');
                }),
            _createDrawerItem(
              icon: Icons.exit_to_app,
              text: "Log Out",
              onTap: () async {
                //firing LogedOut() event will delete the stored jwt
                //this way user will be loggedout
                _authBloc.add(LoggedOut());
                Navigator.pop(context);
                final storage = new FlutterSecureStorage();
                // Delete value
                print("jwt: ${storage.read(key: "jwt")}");
                var r = await storage.delete(key: "jwt");
                Phoenix.rebirth(context);
              },
            ),
          ],
        ),
      ),
    );
  }
}
//rgb(25, 121, 169)
//rgb(93, 188, 210)
