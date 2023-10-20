import 'package:app_consulta_cep/repositories/via_cep_back4app_repository.dart';
import 'package:flutter/material.dart';

import '../models/viacep_model.dart';
import '../repositories/via_cep_repository.dart';

class ConsultaCEP extends StatefulWidget {
  const ConsultaCEP({Key? key}) : super(key: key);

  @override
  State<ConsultaCEP> createState() => _ConsultaCEPState();
}

class _ConsultaCEPState extends State<ConsultaCEP> {
  var cepController = TextEditingController(text: "");
  bool loading = false;
  var consultaCep = ConsultaViaCep();
  var _listaCeps = ViaCEPModel();
  var viaCEPRepository = ViaCepRepository();
  ViaCepBack4AppRepository _back4appRepository = ViaCepBack4AppRepository();

  @override
  void initState() {
    super.initState();
    obterCeps();
  }

  void obterCeps() async {
    setState(() {
      loading = true;
    });
    _listaCeps = await _back4appRepository.getCeps(null);
    setState(() {
      loading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: const Text("Consulta CEP"),
          centerTitle: true,
          backgroundColor: Colors.blueAccent,
        ),
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: Column(
            children: [
              const SizedBox(
                height: 20,
              ),
              const Text(
                "Informe o CEP",
                style: TextStyle(fontSize: 22),
              ),
              TextField(
                controller: cepController,
                keyboardType: TextInputType.number,
                maxLength: 8,
                onChanged: (String value) async {
                  var cep = value.replaceAll(RegExp(r'[^0-9]'), '');
                  if (cep.length == 8) {
                    setState(() {
                      loading = true;
                    });
                    consultaCep = await viaCEPRepository.consultarCEP(cep);
                    _listaCeps = await _back4appRepository.getCeps(null);
                  }
                  setState(() {
                    loading = false;
                  });
                },
              ),
              const SizedBox(
                height: 50,
              ),
              Text(
                consultaCep.logradouro ?? "",
                style: const TextStyle(fontSize: 22),
              ),
              Text(
                "${consultaCep.localidade ?? ""} - ${consultaCep.uf ?? ""}",
                style: const TextStyle(fontSize: 22),
              ),
              const Text("Lista Ceps"),
              loading
                  ? const Center(
                      child: CircularProgressIndicator(),
                    )
                  : Expanded(
                      child: ListView.builder(
                        itemCount: _listaCeps.results!.length,
                        itemBuilder: (BuildContext bc, int index) {
                          var cep = _listaCeps.results![index];
                          return Dismissible(
                            direction: DismissDirection.endToStart,
                            key: Key(cep.logradouro!),
                            background: Container(
                              alignment: AlignmentDirectional.centerEnd,
                              color: Colors.red,
                              child: const Padding(
                                padding: EdgeInsets.fromLTRB(0, 0, 10.0, 0),
                                child: Icon(
                                  Icons.delete,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                            onDismissed:
                                (DismissDirection dismissDirection) async {
                              await _back4appRepository.remover(cep.objectId!);
                              obterCeps();
                            },
                            child: ListTile(
                              title: Text(
                                  "${cep.logradouro!} - ${cep.localidade}"),
                            ),
                          );
                        },
                      ),
                    ),
            ],
          ),
        ),
      ),
    );
  }
}
