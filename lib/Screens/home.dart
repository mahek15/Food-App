import 'package:chat_app/Screens/Nutrition.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';
import 'package:provider/provider.dart';
import '../LogIn/SignIn.dart';
import '../Models/Nutrients_model.dart';
import '../Profile/profile.dart';
import '../Search/FavSearch.dart';
import '../Service/googleSignIn.dart';
import 'Cuisine.dart';
import 'Favorite.dart';
import '../Search/Search.dart';
import 'home1.dart';
import 'package:google_nav_bar/google_nav_bar.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  int currentIndex = 0;
  List<String> title = ['Home', 'Favorite', 'Cuisine', 'Nutrition'];

  final pages = [Home1(), Favorite(), Cuisine(), NutritionPage()];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(title[currentIndex]),
        centerTitle: true,
        backgroundColor: Colors.brown,
        shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(bottom: Radius.circular(20))),
        elevation: 0,
        actions: [
          IconButton(
              onPressed: () {
                if (currentIndex == 0) {
                  showSearch(
                      context: context, delegate: CustomSearchDelegate());
                } else if (currentIndex == 1) {
                  showSearch(context: context, delegate: FavSearch());
                }
              },
              icon: Icon(Icons.search_sharp))
        ],
      ),
      drawer: const NavBar(),
      body: IndexedStack(
        index: currentIndex,
        children: pages,
      ),
      bottomNavigationBar: Container(
        margin: const EdgeInsets.all(5),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(25),
          border: Border.all(color: Colors.white),
          color: Colors.brown,
        ),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: GNav(
            gap: 5,
            backgroundColor: Colors.brown,
            color: Colors.white,
            activeColor: Colors.white,
            tabBackgroundColor: Colors.grey,
            padding: const EdgeInsets.all(15),
            onTabChange: (int num) {
              setState(() {
                currentIndex = num;
              });
            },
            tabs: [
              GButton(
                icon: Icons.home,
                text: title[0],
              ),
              GButton(
                icon: Icons.star,
                text: title[1],
              ),
              GButton(
                icon: Icons.restaurant,
                text: title[2],
              ),
              GButton(
                icon: Icons.auto_graph,
                text: title[3],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class NavBar extends StatefulWidget {
  const NavBar({Key? key}) : super(key: key);

  @override
  State<NavBar> createState() => _NavBarState();
}

class _NavBarState extends State<NavBar> {
  final user = FirebaseAuth.instance.currentUser!;
  final userCollection = FirebaseFirestore.instance.collection('users');
  String? name;
  Future<String> getUserData() async {
    DocumentSnapshot data = await userCollection.doc(user.uid).get();
    name = data.get("name");
    return name!;
  }

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser!;
    return FutureBuilder(
      future: getUserData(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting)
          return Center(
            child: CircularProgressIndicator(),
          );
        return Drawer(
            child: Column(
          children: [
            Container(
              width: double.infinity,
              padding: const EdgeInsets.fromLTRB(25, 60, 25, 5),
              decoration: const BoxDecoration(
                  color: Colors.brown,
                  image: DecorationImage(
                      image: AssetImage('assets/bricks.jpg'),
                      fit: BoxFit.cover)),
              child: Column(
                children: [
                  CircleAvatar(
                    radius: 80,
                    backgroundColor: Colors.black45,
                    child: CircleAvatar(
                      backgroundImage: NetworkImage((user.photoURL == null
                          ? "https://media.istockphoto.com/id/1223671392/vector/default-profile-picture-avatar-photo-placeholder-vector-illustration.jpg?s=612x612&w=0&k=20&c=s0aTdmT5aU6b8ot7VKm11DeID6NctRCpB755rA1BIP0="
                          : user.photoURL!)),
                      radius: 75,
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Text(
                    (user.displayName == null ? name! : user.displayName!),
                    style: const TextStyle(
                        fontSize: 25, letterSpacing: 2, color: Colors.white),
                  ),
                  const SizedBox(
                    height: 5,
                  ),
                  Text(
                    user.email!,
                    style: const TextStyle(
                        fontSize: 15, letterSpacing: 1.5, color: Colors.white),
                  ),
                ],
              ),
            ),
            const SizedBox(
              height: 30,
            ),
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: ListTile(
                onTap: () {
                  Navigator.push(
                    context,
                    PageTransition(
                        type: PageTransitionType.rightToLeftWithFade,
                        child: Profile()),
                  );
                },
                leading: Icon(Icons.person),
                title: Text('My Profile'),
                tileColor: Colors.brown[200],
                shape: RoundedRectangleBorder(
                    side: BorderSide(width: 2),
                    borderRadius: BorderRadius.circular(10)),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: ListTile(
                leading: Icon(Icons.settings),
                title: Text('Settings'),
                tileColor: Colors.brown[200],
                shape: RoundedRectangleBorder(
                    side: BorderSide(width: 2),
                    borderRadius: BorderRadius.circular(10)),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: ListTile(
                leading: Icon(Icons.help_outline_rounded),
                title: Text('Contact Us'),
                tileColor: Colors.brown[200],
                shape: RoundedRectangleBorder(
                    side: BorderSide(width: 2),
                    borderRadius: BorderRadius.circular(10)),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: ListTile(
                onTap: () async {
                  showDialog(
                    context: context,
                    builder: (context) {
                      return Center(child: CircularProgressIndicator());
                    },
                  );

                  final provider =
                      Provider.of<GoogleSignInProvider>(context, listen: false);
                  provider.logOut();
                  await FirebaseAuth.instance.signOut();
                  //setState(() {});
                  await Navigator.push(
                    context,
                    PageTransition(
                        type: PageTransitionType.fade, child: LogIn()),
                  );
                  Navigator.of(context).pop();
                },
                leading: Icon(Icons.arrow_back),
                title: Text('Log Out'),
                tileColor: Colors.brown[200],
                shape: RoundedRectangleBorder(
                    side: BorderSide(width: 2),
                    borderRadius: BorderRadius.circular(10)),
              ),
            ),
          ],
        ));
      },
    );
  }
}
