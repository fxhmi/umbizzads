// @dart=2.9
import 'dart:core';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:umbizz/Chats/chatscreen.dart';
import 'package:umbizz/Helperfunctions/sharepref_helper.dart';
import 'package:umbizz/HomeScreen.dart';
import 'package:umbizz/Services/chat_database.dart';
import 'package:umbizz/Welcome/welcome_screen.dart';
import 'package:umbizz/globalVar.dart';
//import 'package:flutter_image/network.dart';

class ChatList extends StatefulWidget {
  //const ChatList({Key key}) : super(key: key);

  @override
  _ChatListState createState() => _ChatListState();
}

class _ChatListState extends State<ChatList> {

  bool isSearching = false;
  String myName, myProfilePic, myUserName, myEmail, myUid;
  Stream usersStream, chatRoomsStream;

  FirebaseAuth auth = FirebaseAuth.instance;

  TextEditingController searchUsernameEditingController = TextEditingController();

  getMyInfoFromSharedPreference() async {
    myName = getUserName;
    myProfilePic = getUserImageUrl;
    myUserName = getNameChatId;
    myEmail = userEmail;
    myUid = getUserId;

    // myName = await SharedPreferenceHelper().getDisplayName();
    // myProfilePic = await SharedPreferenceHelper().getUserProfileUrl();
    // myUserName = await SharedPreferenceHelper().getUserName();
    // myEmail = await SharedPreferenceHelper().getUserEmail();

    setState(() {});
  }

  getChatRoomIdByUsernames(String a, String b) {
    if (a.substring(0, 1).codeUnitAt(0) > b.substring(0, 1).codeUnitAt(0)) {
      return "$b\_$a";
    } else {
      return "$a\_$b";
    }
  }

  onSearchBtnClick() async {
    isSearching = true;
    setState(() {});

    usersStream = await DatabaseMethods().getUserByUserName(searchUsernameEditingController.text);
    setState(() {});
  }

  Widget chatRoomsList() {
    return StreamBuilder(
      stream: chatRoomsStream,
      builder: (context, snapshot) {
        return snapshot.hasData
            ? ListView.builder(
              itemCount: snapshot.data.docs.length,
              shrinkWrap: true,
              itemBuilder: (context, index) {
              DocumentSnapshot ds = snapshot.data.docs[index];
              return ChatRoomListTile(ds["lastMessage"], ds.id, myUserName);
            })
            : Center(child: CircularProgressIndicator());
      },
    );
  }

  Widget searchListUserTile({String imgPro, userName, nameChatId,  email}) {
    return GestureDetector(
      onTap: () {

        var chatRoomId = getChatRoomIdByUsernames(myUserName, nameChatId);
        Map<String, dynamic> chatRoomInfoMap = {
          "users": [myUserName, nameChatId]
        };
        DatabaseMethods().createChatRoom(chatRoomId, chatRoomInfoMap);
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => ChatScreen(nameChatId, userName)));
      },
      child: Container(
        margin: EdgeInsets.symmetric(vertical: 8),
        child: Row(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(30),
              child: Image.network(
                imgPro,
                height: 40,
                width: 40,
              ),
            ),
            SizedBox(width: 12),
            Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [Text(userName), Text(email)])
          ],
        ),
      ),
    );
  }

  Widget searchUsersList() {
    return StreamBuilder(
      stream: usersStream,
      builder: (context, snapshot) {
        return snapshot.hasData
            ? ListView.builder(
              itemCount: snapshot.data.docs.length,
              shrinkWrap: true,
              itemBuilder: (context, index) {
              DocumentSnapshot ds = snapshot.data.docs[index];
              return searchListUserTile(
                  imgPro: ds['imgPro'],
                  userName: ds['userName'],
                  nameChatId: ds['nameChatId'],
                  email: ds['email'],


                // profileUrl: ds['imgPro'],
                // name: ds['userName'],
                // email: ds['email'],
                // username: ds['userName']
            );
          },
        ) : Center(
          child: CircularProgressIndicator(),
        );
      },
    );
  }

  getChatRooms() async {
    chatRoomsStream = await DatabaseMethods().getChatRooms();
    setState(() {});
  }

  onScreenLoaded() async {
    await getMyInfoFromSharedPreference();
    getChatRooms();
  }

  @override
  void initState() {
    onScreenLoaded();
    super.initState();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Deal Chat"),
        leading: BackButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => HomeScreen()),
              );
            }
        ),
        actions: [
          InkWell(
            onTap: () {
              auth.signOut().then((_){
                Route newRoute = MaterialPageRoute(builder: (_) => WelcomeScreen());
                Navigator.pushReplacement(context, newRoute);
              });
            },
            child: Container(
                padding: EdgeInsets.symmetric(horizontal: 16),
                child: Icon(Icons.exit_to_app)),
          )
        ],
      ),
      body: Container(
        margin: EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          children: [
            Row(
              children: [
                isSearching
                    ? GestureDetector(
                      onTap: () {
                        isSearching = false;
                        searchUsernameEditingController.text = "";
                        setState(() {});
                      },
                        child: Padding(
                          padding: EdgeInsets.only(right: 12),
                          child: Icon(Icons.arrow_back)),
                      )
                    : Container(),
                Expanded(
                  child: Container(
                    margin: EdgeInsets.symmetric(vertical: 16),
                    padding: EdgeInsets.symmetric(horizontal: 16),
                    decoration: BoxDecoration(
                        border: Border.all(
                            color: Colors.grey,
                            width: 1,
                            style: BorderStyle.solid),
                        borderRadius: BorderRadius.circular(24)),
                    child: Row(
                      children: [
                        Expanded(
                            child: TextField(
                              controller: searchUsernameEditingController,
                              decoration: InputDecoration(
                                  border: InputBorder.none, hintText: " Search username "),
                            )),
                        GestureDetector(
                            onTap: () {
                              if (searchUsernameEditingController.text != "") {
                                onSearchBtnClick();
                              }
                            },
                            child: Icon(Icons.search))
                      ],
                    ),
                  ),
                ),
              ],
            ),
            isSearching ? searchUsersList() : chatRoomsList()
          ],
        ),
      ),
    );
  }
}

class ChatRoomListTile extends StatefulWidget {

  final String lastMessage, chatRoomId, myUsername;
  ChatRoomListTile(this.lastMessage, this.chatRoomId, this.myUsername);

  @override
  _ChatRoomListTileState createState() => _ChatRoomListTileState();
}

class _ChatRoomListTileState extends State<ChatRoomListTile> {
  String profilePicUrl = "", name = "", username = "";

  getThisUserInfo() async {
    username = widget.chatRoomId.replaceAll(widget.myUsername, "").replaceAll("_", "");
    QuerySnapshot querySnapshot = await DatabaseMethods().getUserInfo(username);
    print("something bla bla ${querySnapshot.docs[0].id} ${querySnapshot.docs[0]["userName"]}  ${querySnapshot.docs[0]["imgPro"]}");
    name = "${querySnapshot.docs[0]["userName"]}";
    profilePicUrl = "${querySnapshot.docs[0]["imgPro"]}";
    setState(() {});
  }

 @override
  void initState() {
   getThisUserInfo();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => ChatScreen(username, name)
            )
        );
      },
      child: Container(
        margin: EdgeInsets.symmetric(vertical: 8),
        child: Row(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(30),
              child: Image.network(
                profilePicUrl,
                height: 40,
                width: 40,
              ),
            ),

            SizedBox(width: 12),
            Expanded(
              child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  style: TextStyle(fontSize: 16),
                ),
                SizedBox(height: 3),
                Text(widget.lastMessage)
              ],
            )),
          ],
        ),
      ),
    );
  }
}
