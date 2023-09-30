import 'package:flutter/material.dart';
import 'package:viacep_app/interface/cep_interface.dart';
import 'package:viacep_app/models/cep.dart';
import 'package:viacep_app/repository/cep_repository.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  CEPInterface cepRepository = CEPRepository();
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('CEP'),
      ),
      body: Padding(
          padding: const EdgeInsets.all(20),
          child: FutureBuilder(
              future: cepRepository.fetchAllCEP(),
              builder: (context, snapshot) {
                switch (snapshot.connectionState) {
                  case ConnectionState.none:
                  case ConnectionState.waiting:
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  default:
                    if (snapshot.hasError) {
                      return Center(child: Text(snapshot.error.toString()));
                    } else {
                      if (snapshot.data!.length > 0) {
                        return ListView.builder(
                          itemBuilder: (context, i) {
                            return ListTile(
                              title: Text(snapshot.data![i].cep),
                            );
                          },
                          itemCount: snapshot.data!.length,
                        );
                      } else if (snapshot.data == null || snapshot.data == []) {
                        return const Center(
                          child:
                              Text('Não há nenhum registro de CEP armazenado'),
                        );
                      }
                      return const Center(
                        child: Text('Não há nenhum registro de CEP armazenado'),
                      );
                    }
                }
              }

              //   if (snapshot.connectionState == ConnectionState.done) {
              //     if (snapshot.hasData) {

              //   } else if (snapshot.data == null || snapshot.data == []) {
              //     return const Center(
              //       child: Text('Não há nenhum registro de CEP armazenado'),
              //     );
              //   }
              //   if (snapshot.connectionState == ConnectionState.waiting) {
              //     return const Center(child: CircularProgressIndicator());
              //   }

              //   return const Center(
              //     child: Text('Não há nenhum registro de CEP armazenado'),
              //   );
              // }
              //   ListView.builder(
              //     itemBuilder: (context, i) {
              //       items = cepRepository.items;
              //       if (items.isEmpty) {
              //         return const Center(
              //             child: Text('Não há nenhum cep registrado.'));
              //       } else {
              //         return ListTile(
              //           title: Text(items[i].cep),
              //         );
              //       }
              //     },
              //     itemCount: cepRepository.items.length,
              //   ),
              // ),
              )),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {},
        label: Text('Pesquisar CEP'),
        icon: const Icon(Icons.search),
      ),
    );
  }
}
