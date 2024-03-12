import 'package:codegentest/home.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:graphql_flutter/graphql_flutter.dart';

import 'constants.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  MyApp({Key? key}) : super(key: key);

  final ValueNotifier<GraphQLClient> client = ValueNotifier<GraphQLClient>(
    GraphQLClient(
      link: HttpLink(Constants.url),
      cache: GraphQLCache(),
    ),
  );
  @override
  Widget build(BuildContext context) {
    return GraphQLProvider(
      client: client,
      child: GetMaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Codegen Test',
        theme: ThemeData(
          primarySwatch: Colors.brown,
        ),
        home: Home(),
      ),
    );
  }
}
