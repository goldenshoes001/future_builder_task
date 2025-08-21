import 'package:flutter/material.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  TextEditingController plzController = TextEditingController();

  Future<String?>? result;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Center(
            child: Column(
              spacing: 32,
              children: [
                FutureBuilder<String?>(
                  future: result,
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.none) {
                      return Text(
                        "Bitte eine PLZ suchen",
                        style: Theme.of(context).textTheme.labelLarge,
                      );
                    }
                    // Überprüfen, ob die Future auf das Ergebnis wartet
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const CircularProgressIndicator();
                    } else if (snapshot.connectionState ==
                        ConnectionState.done) {
                      if (snapshot.hasError) {
                        return Text(
                          "Fehler: ${snapshot.error}",
                          style: Theme.of(context).textTheme.labelLarge,
                        );
                      }
                      // Zeige das Ergebnis an, wenn Daten vorhanden sind
                      if (snapshot.hasData) {
                        return Text(
                          "Ergebnis: ${snapshot.data}",
                          style: Theme.of(context).textTheme.labelLarge,
                        );
                      }
                      // Standardfall, wenn nichts zutrifft
                    }
                    ;
                    return Text(
                      "Keine Daten verfügbar",
                      style: Theme.of(context).textTheme.labelLarge,
                    );
                  },
                ),
                TextFormField(
                  controller: plzController,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: "Postleitzahl",
                  ),
                ),
                OutlinedButton(
                  onPressed: searchCity,
                  child: const Text("Suche"),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    // TODO: dispose controllers
    super.dispose();
  }

  Future<String> getCityFromZip(String zip) async {
    // simuliere Dauer der Datenbank-Anfrage
    await Future.delayed(const Duration(seconds: 3));

    switch (zip) {
      case "10115":
        return 'Berlin';
      case "20095":
        return 'Hamburg';
      case "80331":
        return 'München';
      case "50667":
        return 'Köln';
      case "60311":
      case "60313":
        return 'Frankfurt am Main';
      default:
        return 'Unbekannte Stadt';
    }
  }

  void searchCity() {
    setState(() {
      String plz = plzController.text;
      result = getCityFromZip(plz);
    });
  }
}
