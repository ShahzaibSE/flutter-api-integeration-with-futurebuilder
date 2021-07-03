import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
// Model.
import './api.model.dart';

class UsersState extends StatefulWidget {
  const UsersState({ Key? key }) : super(key: key);

  @override
  _UsersState createState() => _UsersState();
}

class _UsersState extends State<UsersState> {
  getUsers() async{
    List<UserModel> users = [];
    var response = await http.get(Uri.https('jsonplaceholder.typicode.com', 'users'));
    var usersResponse = jsonDecode(response.body);
    // 
    for (var user in usersResponse){
      
      UserModel userItem = UserModel(user['name'], user['username'], user['email']);
      users.add(userItem);
    }
    // 
    return users;
  }
  
  Widget createUserItem(UserModel user){
    return ListTile(
      leading: CircleAvatar(
        backgroundImage: NetworkImage('https://www.omnitouchinternational.com/wp-content/uploads/2018/05/user-placeholder.jpg'),
      ),
      title: Text(user.username),
      subtitle: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(user.username),
          Text(user.email)
        ],
      ),
      isThreeLine: true,
    );
  }
  @override
  Widget build(BuildContext context) {
    getUsers();
    return Container(
      child: Center(
        child: FutureBuilder(
          future: getUsers(),
          builder: (BuildContext context, AsyncSnapshot snapshot){
            if (snapshot.data == null){
              return SnackBar(content: Text('Data not found'), backgroundColor: Colors.red,);
            }else {
              return ListView.builder(
                itemCount: snapshot.data!.length,
                itemBuilder: (BuildContext context, int index) {
                  return createUserItem(snapshot.data[index]);
                },
              );
            }
          }
        )
      )
    );
  }
}