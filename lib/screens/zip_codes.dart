import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:zip_codes/models/zip_code.dart';

class ZipCodes extends StatefulWidget {
  const ZipCodes({super.key});

  @override
  State<ZipCodes> createState() => _ZipCodesState();
}

class _ZipCodesState extends State<ZipCodes> {
  TextEditingController zipController = TextEditingController();

  ZipCode? result;
  String error = "";

  @override
  Widget build(BuildContext context) {
    var resultLocal = result;
    return Scaffold(
        appBar: AppBar(
          title: const Text("Codis postals"),
          backgroundColor: Colors.amber,
          centerTitle: true,
        ),
        body: Center(
          child: Column(
            children: [
              const SizedBox(
                height: 50,
              ),
              SizedBox(
                width: 200,
                child: TextField(
                  controller: zipController,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 48,
                  ),
                  decoration: const InputDecoration(
                    label: Text("Codi postal"),
                    border: UnderlineInputBorder(),
                  ),
                  keyboardType: TextInputType.number,
                ),
              ),
              const SizedBox(
                height: 50,
              ),
              ElevatedButton(
                onPressed: fetchData,
                child: const Text("Busca"),
              ),
              const SizedBox(
                height: 50,
              ),
              if (resultLocal != null)
                Column(
                  children: [
                    Text(resultLocal.places.first.placeName),
                    Text(resultLocal.places.first.state),
                    Text("(${resultLocal.places.first.longitude},"
                        " ${resultLocal.places.first.latitude})"),
                  ],
                ),
              if (error.isNotEmpty)
                Text(
                  error,
                  style: const TextStyle(color: Colors.red),
                )
            ],
          ),
        ));
  }

  Future<void> fetchData() async {
    try {
      var response = await http.get(
          Uri.parse("https://api.zippopotamasdas.us/es/${zipController.text}"));
      debugPrint(response.body);
      result = zipCodeFromJson(response.body);
      error = "";
    } on TypeError catch (_, __) {
      result = null;
      error = "No hi ha cap localitat amb el codi postal ${zipController.text}";
    } on http.ClientException catch (_) {
      result = null;
      error = "Error conectant al servidor";
    }
    setState(() {});
  }
}
