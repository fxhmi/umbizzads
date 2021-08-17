// @dart=2.9
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:umbizz/Chats/chat_screen.dart';
import 'package:umbizz/Chats/chatlist.dart';
import 'package:umbizz/Chats/chatscreen.dart';
import 'package:umbizz/SearchProduct.dart';
import 'package:umbizz/Welcome/welcome_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:umbizz/Widgets/imageSliderScreen.dart';
import 'package:umbizz/Widgets/loadingWidget.dart';
import 'package:umbizz/globalVar.dart';
import 'package:umbizz/profile_ads_screen.dart';
import 'package:umbizz/profile_page.dart';
import 'package:umbizz/uploadAdScreen.dart';
import 'package:timeago/timeago.dart' as tAgo;
import 'package:google_fonts/google_fonts.dart';

class HomeScreen extends StatefulWidget {


  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {

  //display ads at jome screen
  final FirebaseFirestore fb = FirebaseFirestore.instance;
  FirebaseAuth auth = FirebaseAuth.instance;
  QuerySnapshot items;

  //update ads
  Future <bool> showDialogForUpdateData(selectedDoc, oldUserName, oldPhoneNumber, oldItemPrice, oldItemName, oldItemColor, oldItemDescription) async{
    return showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context){
        return SingleChildScrollView(
          child: AlertDialog(
            title: Text("Update Data", style: TextStyle(fontSize: 24, fontFamily: 'Bebas', letterSpacing: 2.0)?? ''),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                // TextFormField(
                //   initialValue: oldUserName,
                //   decoration: InputDecoration(
                //     hintText: 'Enter your new name',
                //   ),
                //   onChanged: (value){
                //     setState(() {
                //       oldUserName = value;
                //     });
                //   },
                // ),
                // SizedBox(height: 5.0,),
                // TextFormField(
                //   initialValue: oldPhoneNumber,
                //   decoration: InputDecoration(
                //     hintText: 'Enter your new phone no.',
                //   ),
                //   onChanged: (value){
                //     setState(() {
                //       oldPhoneNumber = value;
                //     });
                //   },
                // ),

                SizedBox(height: 5.0,),
                TextFormField(
                  initialValue: oldItemName,
                  decoration: InputDecoration(
                    hintText: 'Enter your new item model',
                  ),
                  onChanged: (value){
                    setState(() {
                      oldItemName = value;
                    });
                  },
                ),
                SizedBox(height: 5.0,),
                TextFormField(
                  initialValue: oldItemColor,
                  decoration: InputDecoration(
                    hintText: 'Enter your new item color',
                  ),
                  onChanged: (value){
                    setState(() {
                      oldItemColor = value;
                    });
                  },
                ),
                SizedBox(height: 5.0,),
                TextFormField(
                  initialValue: oldItemPrice,
                  decoration: InputDecoration(
                    hintText: 'Enter your new price',
                  ),
                  onChanged: (value){
                    setState(() {
                      oldItemPrice = value;
                    });
                  },
                ),
                SizedBox(height: 5.0,),
                TextFormField(
                  initialValue: oldItemDescription,
                  decoration: InputDecoration(
                    hintText: 'Enter your new description',
                  ),
                  onChanged: (value){
                    setState(() {
                      oldItemDescription = value;
                    });
                  },
                ),
              ],
            ),

            //cancel button
            actions: [
              ElevatedButton(
              onPressed: ()
            {
              Navigator.pop(context);
            },
              child: Text("Cancel" ?? ''),
          ),
              ElevatedButton(
                child: Text(
                  "Update Now" ?? ''
                ),
                onPressed: (){
                  Navigator.pop(context);

                  //update database
                  Map<String, dynamic> itemData = {
                    'userName': oldUserName,
                    'userNumber': oldPhoneNumber,
                    'itemPrice' : oldItemPrice,
                    'itemModel': oldItemName,
                    'itemColor': oldItemColor,
                    'description': oldItemDescription,
                  };

                  FirebaseFirestore.instance.collection('items').doc(selectedDoc).update(itemData).then((value){
                    print("Data updated successfully.");
                  }).catchError((onError){
                    print(onError);
                  });
                },
              ),
            ],
          ),
        );
      }
    );
  }

  getMyData(){
    FirebaseFirestore.instance.collection("users").doc(userId).get().then((results){
      setState(() {
        getUserImageUrl = results.data()['imgPro'];
        getUserName = results.data()['userName'];
        getUserNum = results.data()['userNumber'];
        getAbout = results.data()['about'];
        getUserId = results.data()['uid'];
        getNameChatId = results.data()['nameChatId'];
      });
    });
  }

  getUserAddress() async {
    Position newPosition = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);

    position = newPosition;
    placemarks = await placemarkFromCoordinates(position.latitude, position.longitude);

    Placemark placemark = placemarks[0];
    String newCompleteAddress =
        '${placemark.subThoroughfare} ${placemark.thoroughfare}, '
        '${placemark.subThoroughfare} ${placemark.locality}, '
        '${placemark.subAdministrativeArea} '
        '${placemark.administrativeArea} ${placemark.postalCode}, '
        '${placemark.country}'
    ;

    completeAddress = newCompleteAddress;
    print(completeAddress);

    return completeAddress;
  }

  @override
  void initState() {
    //TODO: implement initstate
    super.initState();
    getUserAddress();

    userId = FirebaseAuth.instance.currentUser.uid;
    userEmail = FirebaseAuth.instance.currentUser.email;



    FirebaseFirestore.instance.collection("items")
    .where("status", isEqualTo: "approved")
    .orderBy("time", descending: true)
    .get().then((results){
      setState(() {

        items = results;

      });
    });

    getMyData();
  }

  Future <bool> _onBackPressed(){
    return showDialog(
        context: context,
        builder: (context)=>AlertDialog(
        title: Text("We are sad you go. Do you really want to exit UMBizz? 🥺"),
          actions: <Widget>[
            FlatButton(
                onPressed: ()=> Navigator.pop(context,false),
                child: Text("No"),
            ),
            FlatButton(
              onPressed: ()=> Navigator.pop(context,true),
              child: Text("Yes"),
            ),
          ],
        )
    );
  }


  @override
  Widget build(BuildContext context) {

    double _screenWidth = MediaQuery.of(context).size.width;
       //_screenHeight = MediaQuery.of(context).size.width;

    Widget showItemsList(){
      if(items != null)
        {
          return ListView.builder(

            itemCount: items.docs.length,
            padding: EdgeInsets.all(8.0),
            itemBuilder: (context, i){
                return Card(
                  clipBehavior: Clip.antiAlias,
                  child: Column(
                    children: [
                      Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: ListTile(
                            leading: GestureDetector(
                              onTap: (){
                                //navigate user to seller profile
                                Route newRoute = MaterialPageRoute(builder: (_) => ProfileScreen(sellerId: items.docs[i].get('uid'),));
                                Navigator.pushReplacement(context, newRoute);
                              },
                              child: Container(
                                width: 60,
                                height: 60,
                                decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    image: DecorationImage(
                                      image: NetworkImage(items.docs[i].get('imgPro'),),
                                      fit: BoxFit.fill
                                    ),
                                ),
                              ),
                            ),
                            title: GestureDetector(
                              onTap: (){
                                //navigate user to seller profile
                                Route newRoute = MaterialPageRoute(builder: (_) => ProfileScreen(sellerId: items.docs[i].get('uid'),));
                                Navigator.pushReplacement(context, newRoute);

                              },
                              child: Text(items.docs[i].get('userName') ?? '')
                            ),

                            // update ads delete ads, if user is the owner of ads
                            trailing: items.docs[i].get('uid') == userId ?
                            Row(
                              mainAxisSize: MainAxisSize.min,
                                children: [
                                  GestureDetector(
                                    onTap: (){
                                      if(items.docs[i].get('uid')==userId){
                                        showDialogForUpdateData(
                                          items.docs[i].id,
                                          items.docs[i].get('userName'),
                                          items.docs[i].get('userNumber'),
                                          items.docs[i].get('itemPrice'),
                                          items.docs[i].get('itemModel'),
                                          items.docs[i].get('itemColor'),
                                          items.docs[i].get('description'),
                                        );
                                      }
                                    },
                                    child: Icon(Icons.edit_outlined,),
                                  ),
                                  SizedBox(width: 20,),
                                  GestureDetector(
                                    //delete items
                                    onDoubleTap: (){
                                        if(items.docs[i].get('uid')==userId){
                                          FirebaseFirestore.instance.collection('items').doc(items.docs[i].id).delete();
                                          Navigator.push(context, MaterialPageRoute(builder: (BuildContext c) => HomeScreen()));
                                        }
                                    },
                                    child: Icon(Icons.delete_forever_sharp),
                                  ),
                                ],

                              // else
                            ) : Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [],
                            ),
                          ),
                      ),

                      GestureDetector(
                        onDoubleTap: (){
                          Route newRoute = MaterialPageRoute(builder: (_) => ImageSliderScreen(
                            title: items.docs[i].get('itemModel'),
                            itemColor: items.docs[i].get('itemColor'),
                            userNumber: items.docs[i].get('userNumber'),
                            description: items.docs[i].get('description'),
                            lat: items.docs[i].get('lat'),
                            lng: items.docs[i].get('long'),
                            userName: items.docs[i].get('userName'),
                            urlImage1: items.docs[i].get('urlImage1'),
                            urlImage2: items.docs[i].get('urlImage2'),
                            urlImage3: items.docs[i].get('urlImage3'),
                            urlImage4: items.docs[i].get('urlImage4'),
                            urlImage5: items.docs[i].get('urlImage5'),
                          ));
                          //whenever click to image it will redirect to imagesliderscreen with the data
                          Navigator.pushReplacement(context, newRoute);
                        },
                        child: Padding(
                          //show a pic first
                          padding: const EdgeInsets.all(16.0),
                          child: Image.network(
                            items.docs[i].get('urlImage1'),
                            errorBuilder: (BuildContext context, Object exception, StackTrace stackTrace) {
                              return Text('Your error widget...');
                            },
                            fit: BoxFit.fill,
                          ),
                        ),
                      ),

                      //item price
                      Padding(
                          padding: const EdgeInsets.only(left: 10.0),
                          child: Text(
                            'RM' + items.docs[i].get('itemPrice') ?? '',
                            style: TextStyle(
                              fontFamily: "Bebas",
                              letterSpacing: 2.0,
                              fontSize: 24,
                            )?? '',
                          ),
                      ),

                      //item model
                      Padding(
                          padding: const EdgeInsets.only(left: 15.0,right: 15.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                Icon(Icons.image_sharp),
                                Padding(
                                    padding: const EdgeInsets.only(left: 10.0),
                                  child: Align(
                                    child: Text(items.docs[i].get('itemModel')?? ''),
                                    alignment: Alignment.topLeft,
                                  ),
                                ),
                              ],
                            ),
                            Row(
                              children: [
                                Icon(Icons.watch_later_outlined),
                                Padding(
                                  padding: const EdgeInsets.only(left: 10.0),
                                  child: Align(
                                    child: Text(tAgo.format((items.docs[i].get('time')).toDate())?? ''),
                                    alignment: Alignment.topLeft,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: 10.0,),
                    ],
                  ),
                );
            },
          );
        } else {
        return circularProgress();
      }
    }


    return WillPopScope(
      onWillPop: _onBackPressed,
      child: Scaffold(
        appBar: AppBar(

          // leading: IconButton(
          //   icon: Icon(Icons.refresh, color: Colors.white),
          //   onPressed: (){
          //     Route newRoute = MaterialPageRoute(builder: (_) => HomeScreen());
          //     Navigator.pushReplacement(context, newRoute);
          //   },
          // ),
          actions: <Widget>[
            // TextButton(
            //     onPressed: (){
            //       Route newRoute = MaterialPageRoute(builder: (_) => ProfileScreen(sellerId: userId));
            //       Navigator.pushReplacement(context, newRoute);
            //     },
            //     child: Padding(
            //       padding: const EdgeInsets.all(10.0),
            //       child: Icon(Icons.person, color: Colors.white),
            //     ),
            // ),
            TextButton(
              onPressed: (){
                Route newRoute = MaterialPageRoute(builder: (_) => SearchProduct());
                Navigator.pushReplacement(context, newRoute);
              },
              child: Padding(
                padding: const EdgeInsets.all(10.0),
                child: Icon(Icons.search, color: Colors.white),
              ),
            ),
            TextButton(
              onPressed: (){
                auth.signOut().then((_){
                  Route newRoute = MaterialPageRoute(builder: (_) => WelcomeScreen());
                  Navigator.pushReplacement(context, newRoute);
                });
              },
              child: Padding(
                padding: const EdgeInsets.all(10.0),
                child: Icon(Icons.notifications_active, color: Colors.white),
              ),
            ),
          ],
          //linear gradient perpose
          flexibleSpace: Container(
            decoration: new BoxDecoration(
              gradient: new LinearGradient(
                  colors: [
                    Colors.deepPurple[300],
                    Colors.blue,

                    // Colors.lightBlueAccent,
                    // Colors.blueAccent,

                    // Colors.blueGrey,
                    // Colors.grey,
                  ],
                begin: const FractionalOffset(0.0, 0.0),
                end: const FractionalOffset(1.0, 0.0),
                stops: [0.0, 1.0],
              ),
            ),
          ),
          title: Image.asset("assets/images/umbizz_logo.png", height: 48,),
          centerTitle: true,
        ),

        drawer: Drawer(
          child: ListView(
            //padding: EdgeInsets.zero,
            children: <Widget>[

              DrawerHeader(
                margin: EdgeInsets.zero,
                decoration: BoxDecoration(
                  image: DecorationImage(
                    fit: BoxFit.fill,
                    image: AssetImage('assets/images/drawer.jpg'),
                  ),
                ),
                padding: EdgeInsets.all(0),
                child: Container(
                  child: Column(
                    children: [
                      const SizedBox(
                        height: 10,
                      ),
                      CircleAvatar(
                        radius: 42,
                        backgroundImage: NetworkImage(getUserImageUrl),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Text(
                        getUserName ?? '',
                        style: GoogleFonts.sanchez(
                          fontSize: 16,
                          color: Colors.white,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                      const SizedBox(
                        height: 5,
                      ),
                      Text(
                        FirebaseAuth.instance.currentUser.email ?? '',
                        style: GoogleFonts.sanchez(
                          fontSize: 16,
                          color: Colors.white,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ],
                  ),
                ),
              ),


              ListTile(
                leading: Icon(

                  Icons.account_box_rounded,
                  color: Colors.blueAccent,
                  size: 29.0,
                  semanticLabel: 'Text to announce in accessibility modes',
                ),

                title: Text('Profile Page' ?? ''),
                onTap: () {
                  Route newRoute = MaterialPageRoute(builder: (_) => ProfilePage());
                  Navigator.pushReplacement(context, newRoute);
                },
              ),

              Divider(),
              ListTile(
                leading: Icon(

                  Icons.message_rounded,
                  color: Colors.blueAccent,
                  size: 29.0,
                  semanticLabel: 'Text to announce in accessibility modes',
                ),

                title: Text('Message'),
                onTap: () {
                  // FutureBuilder(
                  //   future: AuthMethods().getCurrentUser(),
                  //   builder: (context, AsyncSnapshot<dynamic> snapshot) {
                  //     if (snapshot.hasData) {
                  //       return ChatScreen(chatWithUsername, name);
                  //     } else {
                  //       return SignIn();
                  //     }
                  //   },
                  // );
                  Route newRoute = MaterialPageRoute(builder: (_) => ChatList());
                  Navigator.pushReplacement(context, newRoute);
                },

              ),

              Divider(),
              ListTile(
                leading: Icon(

                  Icons.edit,
                  color: Colors.blueAccent,
                  size: 29.0,
                  semanticLabel: 'Text to announce in accessibility modes',
                ),

                title: Text('Manage Advertisement'),
                onTap: () {
                  Route newRoute = MaterialPageRoute(builder: (_) => ProfileScreen(sellerId: userId));
                  Navigator.pushReplacement(context, newRoute);
                },

              ),

              Divider(),
              ListTile(
                leading: Icon(
                    Icons.school,
                    color: Colors.blue,
                    size: 29.0,
                ),

                title: Text('Business Education'),
                onTap: () {
                    auth.signOut().then((_){
                    Route newRoute = MaterialPageRoute(builder: (_) => WelcomeScreen());
                    Navigator.pushReplacement(context, newRoute);
                  });
                },

              ),
              Divider(),
              ListTile(
                leading: Icon(
                  Icons.refresh,
                  color: Colors.blueAccent,
                  size: 29.0,
                  semanticLabel: 'Text to announce in accessibility modes',
                ),

                title: Text('Refresh Page'),
                onTap: () {
                  Route newRoute = MaterialPageRoute(builder: (_) => HomeScreen());
                  Navigator.pushReplacement(context, newRoute);
                },

              ),
              Divider(),

              const SizedBox(height: 45),
              Center(
                child: OutlineButton(
                  padding: EdgeInsets.symmetric(horizontal: 40),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20)),
                  onPressed: () {
                    auth.signOut().then((_){
                      Route newRoute = MaterialPageRoute(builder: (_) => WelcomeScreen());
                      Navigator.pushReplacement(context, newRoute);
                    });
                  },
                  child: Text("SIGN OUT",
                      style: TextStyle(
                          fontSize: 16, letterSpacing: 2.2, color: Colors.red)),
                ),
              )
            ],
          ),
        ),

        body: Center(
          child: Container(
            width: _screenWidth,
            child: showItemsList(),
          ),
        ),
        floatingActionButton: FloatingActionButton(
          tooltip: 'Add post',
          child: Icon(Icons.add, color: Colors.white,),

          //redirect user to Page
          onPressed: (){
            Route newRoute = MaterialPageRoute(builder: (_) => UploadAdScreen());
            Navigator.pushReplacement(context, newRoute);

          },
        ),
      ),
    );
  }
}
