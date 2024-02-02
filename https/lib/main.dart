import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

Future<List<User>> fetchUser() async {
  final response = await http.get(
    Uri.parse("http://localhost:8000/users"),
  );
  if (response.statusCode == 200) {
    // final Map<String, dynamic> data = json.decode(response.body);
    final List<dynamic> dataList = json.decode(response.body);
    final List<User> users =
        dataList.map((json) => User.fromJson(json)).toList();
    return users;
    // return User.fromJson(data);
  } else {
    throw Exception("Failed tp load user");
  }
}

class User {
  final int id;
  final String name;
  final String email;

  User({
    required this.id,
    required this.name,
    required this.email,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    print("Raw JSON: $json");
    return User(
      id: json['id'] != null ? int.parse(json['id'].toString()) : 0,
      name: json['name'] ?? '',
      email: json['email'] ?? '',
    );
  }
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'email': email,
    };
  }
}

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData(
            appBarTheme: const AppBarTheme(
          backgroundColor: Colors.blue,
          centerTitle: true,
        )),
        debugShowCheckedModeBanner: false,
        home: Scaffold(
          appBar: AppBar(
            title: const Text("Http Request"),
          ),
          body: const MyHome(),
        ));
  }
}

class MyHome extends StatefulWidget {
  const MyHome({super.key});

  @override
  _MyHomeState createState() => _MyHomeState();
}

class _MyHomeState extends State<MyHome> {
  late Future<List<User>> futurePost;

  @override
  void initState() {
    super.initState();
    futurePost = fetchUser();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: FutureBuilder<List<User>>(
        future: futurePost,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const CircularProgressIndicator();
          } else if (snapshot.hasError) {
            return Text('Error: ${snapshot.error}');
          } else {
            return ListView.builder(
              itemCount: snapshot.data!.length,
              itemBuilder: (context, index) {
                final user = snapshot.data![index];
                return ListTile(
                  title: Text('User Name: ${user.name}'),
                  subtitle: Text('Email: ${user.email}'),
                );
              },
            );
          }
        },
      ),
    );
  }
}
