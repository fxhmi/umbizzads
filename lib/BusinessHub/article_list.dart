// @dart=2.9
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:umbizz/BusinessHub/create_article.dart';
import 'package:umbizz/HomeScreen.dart';
import 'package:umbizz/Services/blog_database.dart';
import 'package:umbizz/globalVar.dart';

class ArticleList extends StatefulWidget {
  const ArticleList({Key key}) : super(key: key);

  @override
  _ArticleListState createState() => _ArticleListState();
}

class _ArticleListState extends State<ArticleList> {

  CrudMethods crudMethods = new CrudMethods();
  FirebaseAuth auth;
  Stream blogsStream ;
  String myName, myProfilePic, myUserName, myEmail, myUid;


  Widget BlogsList() {
    return Container(
      child: blogsStream != null
          ? SingleChildScrollView(
            child: Column(
              children: <Widget>[
              StreamBuilder(
                stream: blogsStream,
                builder: (context, snapshot) {
                return ListView.builder(
                    padding: EdgeInsets.symmetric(horizontal: 16),
                    itemCount: snapshot.data.docs.length,
                    shrinkWrap: true,
                    itemBuilder: (context, index) {
                    DocumentSnapshot ads = snapshot.data.docs[index];
                      return BlogsTile(
                        authorName: ads['authorName'],
                        title: ads['title'],
                        description: ads['desc'],
                        imgUrl: ads['imgUrl'],
                      );
                    });
              },
            )
        ],
      ),
          )
          : Container(),
    );
  }

  getMyInfoFromSharedPreference() async {
    myName = getUserName;
    myProfilePic = getUserImageUrl;
    myUserName = getNameChatId;
    myEmail = userEmail;
    myUid = getUserId;

    setState(() {});
  }


  onScreenLoaded() async {
    await getMyInfoFromSharedPreference();
    blogsStream = crudMethods.getData();
    //getChatRooms();
  }

  getData() async {
    crudMethods.getData().then((result) {
      setState(() {
        blogsStream = result;
      });
    });
  }

  @override
  void initState() {
    onScreenLoaded();
    getData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Business Tips",
          style: TextStyle(fontSize: 22),
        ),

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
        leading: BackButton(
            onPressed: () {
              Route newRoute = MaterialPageRoute(builder: (_) => HomeScreen());
              Navigator.pushReplacement(context, newRoute);
            }
        ),
        elevation: 0.0,
      ),
      body: BlogsList(),

      /// admin module
      floatingActionButton: Container(
        padding: EdgeInsets.symmetric(vertical: 20),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            FloatingActionButton(
              onPressed: () {
                Navigator.push(context,
                MaterialPageRoute(builder: (context) => CreateBlog()));
              },
              child: Icon(Icons.add),
            )
          ],
        ),
      ),
    );
  }
}

class BlogsTile extends StatelessWidget {
  String imgUrl, title, description, authorName;
  BlogsTile({ this.imgUrl, this.title, this.description, this.authorName});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: 16),
      height: 150,

      child: Stack(
        children: <Widget>[
          SizedBox(height: 20,),
          ClipRRect(
            borderRadius: BorderRadius.circular(6),
            child: CachedNetworkImage(
              imageUrl: imgUrl ?? "",
              width: MediaQuery.of(context).size.width,
              fit: BoxFit.cover,
            ),
          ),
          Container(
            height: 170,
            decoration: BoxDecoration(
                color: Colors.black45.withOpacity(0.3),
                borderRadius: BorderRadius.circular(6)),
          ),
          Container(
            width: MediaQuery.of(context).size.width,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Text(
                  title ?? "",
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 25, fontWeight: FontWeight.w700, color: Colors.white),
                ),
                SizedBox(
                  height: 4,
                ),
                Text(
                  description ?? "",
                  style: TextStyle(fontSize: 17, fontWeight: FontWeight.w400, color: Colors.white),
                ),
                SizedBox(
                  height: 4,
                ),
                Text(
                  authorName ?? "",
                  style: TextStyle(fontSize: 17, fontWeight: FontWeight.w400, color: Colors.white),
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}
