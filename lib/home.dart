import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:graphql_flutter/graphql_flutter.dart';

class Home extends StatelessWidget {
  Home({Key? key}) : super(key: key);

  RxInt state = 0.obs;

  String query = """
query Content{
  countries {
    name
    capital
  }
}
""";

  String query1 = """
  query Content{
  country(code: "PS") {
    name
  }
  }
  
  """;

  String query2 = """
  query Content{
  country(code: "TN") {
    name
  }
  }
  
  """;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("CodegenTest"),
      ),
      body: Column(
        children: [
          Expanded(
            child: Obx(
              () => Query(
                  options: QueryOptions(
                      document: gql(state.value == 0
                          ? query
                          : state.value == 1
                              ? query1
                              : query2),
                      variables: const <String, dynamic>{
                        "variableName": "value"
                      }),
                  builder: (result, {fetchMore, refetch}) {
                    if (result.isLoading) {
                      return const Center(
                        child: CircularProgressIndicator(),
                      );
                    }
                    if (result.data == null) {
                      return const Center(
                        child: Text("No Country found"),
                      );
                    }

                    final countries = result.data!['countries'] ?? [];

                    return RefreshIndicator(
                      onRefresh: () async {
                        refetch;
                        return;
                      },
                      child: ListView.builder(
                        itemCount: state.value != 0 ? 1 : countries.length,
                        itemBuilder: (context, index) {
                          final country = state.value != 0
                              ? result.data!['country']
                              : countries[index];
                          final name = country['name'].toString();
                          final capital = country['capital'].toString();

                          return ListTile(
                            title: Text(name),
                            subtitle: Text(capital != "null" ? capital : ''),
                          );
                        },
                      ),
                    );
                  }),
            ),
          ),
          const SizedBox(
            height: 20,
          ),
          ElevatedButton(
              onPressed: () {
                state.value = 0;
              },
              child: const Text("Get All Countries")),
          const SizedBox(
            height: 10,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              ElevatedButton(
                  onPressed: () {
                    state.value = 1;
                  },
                  child: const Text("Get PS Country")),
              ElevatedButton(
                  onPressed: () {
                    state.value = 2;
                  },
                  child: const Text("Get TN Country")),
            ],
          ),
          const SizedBox(
            height: 20,
          ),
        ],
      ),
    );
  }
}
