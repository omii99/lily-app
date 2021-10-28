// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';
// import 'package:lily/data/db/entity/app_user.dart';
// import 'package:lily/data/model/chat_with_user.dart';
// import 'package:lily/data/provider/user_provider.dart';
// import 'package:lily/ui/screens/chat_screen.dart';
// import 'package:lily/ui/widgets/chats_list.dart';
// import 'package:lily/ui/widgets/custom_modal_progress_hud.dart';

// class ChatBotScreen extends StatefulWidget {
//   @override
//   _ChatBotScreenState createState() => _ChatBotScreenState();
// }

// class _ChatBotScreenState extends State<ChatBotScreen> {
//   // void chatWithUserPressed(ChatWithUser chatWithUser) async {
//   //   AppUser user = await Provider.of<UserProvider>(context, listen: false).user;
//   //   Navigator.pushNamed(context, ChatScreen.id, arguments: {
//   //     "chat_id": chatWithUser.chat.id,
//   //     "user_id": user.id,
//   //     "other_user_id": chatWithUser.user.id
//   //   });
//   // }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: Container(
//         padding: EdgeInsets.symmetric(vertical: 16.0, horizontal: 16.0),
//         child: Consumer<UserProvider>(
//           builder: (context, userProvider, child) {
//             return FutureBuilder<AppUser>(
//               future: userProvider.user,
//               builder: (context, userSnapshot) {
//                 return CustomModalProgressHUD(
//                   inAsyncCall:
//                       userProvider.user == null || userProvider.isLoading,
//                   child: (userSnapshot.hasData)
//                       ? FutureBuilder<List<ChatWithUser>>(
//                           future: userProvider
//                               .getChatsWithUser(userSnapshot.data.id),
//                           builder: (context, chatWithUsersSnapshot) {
//                             if (chatWithUsersSnapshot.data == null &&
//                                 chatWithUsersSnapshot.connectionState !=
//                                     ConnectionState.done) {
//                               return CustomModalProgressHUD(
//                                   inAsyncCall: true, child: Container());
//                             } else {
//                               return chatWithUsersSnapshot.data.length == 0
//                                   ? Center(
//                                       child: Container(
//                                           child: Text('No matches',
//                                               style: Theme.of(context)
//                                                   .textTheme
//                                                   .headline4)),
//                                     )
//                                   : ChatsList(
//                                       chatWithUserList:
//                                           chatWithUsersSnapshot.data,
//                                       // onChatWithUserTap: chatWithUserPressed,
//                                       myUserId: userSnapshot.data.id,
//                                     );
//                             }
//                           })
//                       : Container(),
//                 );
//               },
//             );
//           },
//         ),
//       ),
//     );
//   }
// }
import 'package:flutter/material.dart';
import 'package:flutter_dialogflow/dialogflow_v2.dart';

class ChatBotPage extends StatefulWidget{
  @override
  _ChatBotPageState createState() => _ChatBotPageState();

}

class _ChatBotPageState extends State<ChatBotPage>{
  final TextEditingController _textController = TextEditingController();
  final List<Message> _messages = <Message>[];


  void _getMessage (query) async{
AuthGoogle authGoogle = await AuthGoogle(fileJson: "assets/lily-chatbot-tm9x-c16af05e7cd9.json").build();

Dialogflow dialogflow = Dialogflow(authGoogle:  authGoogle, language: Language.english);

AIResponse response = await dialogflow.detectIntent(query);

Message message = Message(
  name : "Lily",
  isMyMessage: false,
  text: response.getMessage() ?? CardDialogflow(response.getListMessage()[0]).title,
);

setState(() {
  _messages.insert(0, message);
});
  }

  void _sendMessage(String text){
    _textController.clear();
    // print(text);

    Message messages = Message(
      name: 'Mandara',
      text : text,
      isMyMessage : true,
    );

    setState(() {
      _messages.insert(0, messages);
    });

    _getMessage(text);
  }

  @override
  Widget build(BuildContext context){
    return Scaffold(
      appBar: AppBar(
        title: const Text("Sample Chatbot") ,
        ),
        body: Column(
          children: <Widget>[
            Flexible(
              child: ListView.builder(
                padding: EdgeInsets.all(8.0),
                reverse: true,
                itemBuilder: (_,int index) => _messages[index],
                itemCount: _messages.length,
                )),
                Divider(height: 1.0),
                Container(
                  child: Container(
                    margin: const EdgeInsets.symmetric(horizontal: 8.0),
                    child: Row(
                      children: <Widget>[
                        Flexible(
                          child: TextField(
                            controller: _textController,
                            autocorrect: false,
                            enableSuggestions: false,
                            onSubmitted: _sendMessage,
                          )),
                          Container(
                            margin: EdgeInsets.symmetric(horizontal: 4.0),
                            child: IconButton(
                              icon: Icon(Icons.send),
                              onPressed: () => _sendMessage(_textController.text),
                              ),
                          )
                      ],),
                  ),
                )

          ],),
    );
  }
}

class Message extends StatelessWidget {
  final String text;
  final String name;
  final bool isMyMessage;

  Message({
    this.text,
     this.name,
    this.isMyMessage,
  });
  
  List<Widget> botMessage(context){
    return <Widget>[
      Container(
        margin:  const EdgeInsets.only(right: 16.0),
        child: CircleAvatar(
          child: Text(this.name[0]) ,
          backgroundColor: Colors.red,
          ),
      ),
      Expanded(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              this.name,
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            Container(
              margin: const EdgeInsets.only(top: 5.0),
              child: Text(text),
            ),
          ],
        ))
    ];

  }

  List <Widget> myMessage(context){
    return <Widget>[
      Expanded(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: <Widget>[
            Text(
              this.name,
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            Container(
              margin: const EdgeInsets.only(top: 5.0),
              child: Text(text),
            ),
          ],
        )),
        Container(
          margin: const EdgeInsets.only(left: 16.0),
          child: CircleAvatar(
            child: Text(this.name[0]) ,
            ),
        )
    ];
  }


  @override
  Widget build(BuildContext context){
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 10.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: this.isMyMessage ? myMessage(context) : botMessage(context),
        ),
    );
  }


}