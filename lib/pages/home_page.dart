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
  bool isLoading = false;
  TextEditingController _cepController = TextEditingController();
  CEPInterface cepRepository = CEPRepository();
  @override
  void initState() {
    super.initState();
  }

  Future<void> _cepSubmit(BuildContext context) async {
    _cepController.clear();
    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: const Text('Pesquisar endereço'),
            content: SizedBox(
              height: 130,
              child: Center(
                child: isLoading
                    ? const Center(
                        child: CircularProgressIndicator(),
                      )
                    : Column(
                        children: [
                          TextField(
                            onChanged: (value) {},
                            controller: _cepController,
                            decoration: const InputDecoration(
                                hintText: "Digite o numero do CEP"),
                            keyboardType: TextInputType.number,
                            maxLength: 8,
                          ),
                          TextButton(
                            onPressed: () async {
                              setState(() {
                                isLoading = true;
                              });
                              await cepRepository
                                  .getNewCEPByViaCep(_cepController.text);
                              setState(() {
                                cepRepository.fetchAllCEP();
                                Navigator.pop(context);
                                dispose();
                                isLoading = false;
                              });
                            },
                            child: const Text('Pesquisar'),
                          ),
                        ],
                      ),
              ),
            ),
          );
        });
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
                        return isLoading
                            ? Center(
                                child: CircularProgressIndicator(),
                              )
                            : ListView.builder(
                                itemBuilder: (context, i) {
                                  CEP currentCep = snapshot.data![i];
                                  return Card(
                                    child: ListTile(
                                      title: Text(
                                          '${currentCep.logradouro} - ${currentCep.bairro}'),
                                      subtitle: Text(
                                          'CEP: ${currentCep.cep} | ${currentCep.localidade} - ${currentCep.uf}'),
                                      trailing: IconButton(
                                        icon: Icon(Icons.delete,
                                            color: Colors.red),
                                        onPressed: () {
                                          isLoading = true;
                                          setState(() {
                                            cepRepository.removeCEP(currentCep);
                                            cepRepository.fetchAllCEP();
                                            isLoading = false;
                                          });
                                        },
                                      ),
                                    ),
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
        onPressed: () async => _cepSubmit(context),
        label: Text('Pesquisar CEP'),
        icon: const Icon(Icons.search),
      ),
    );
  }
}
