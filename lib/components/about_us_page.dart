import 'package:flutter/material.dart';

class AboutUsPage extends StatefulWidget {
  const AboutUsPage({super.key});

  @override
  State<AboutUsPage> createState() => _AboutUsPageState();
}

class _AboutUsPageState extends State<AboutUsPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Center(child: Text("About Us")),
        actions: [Container(width: 50,),],
        elevation: 0,
      ),
      body: ConstrainedBox(
        constraints: const BoxConstraints(
          maxWidth: 900,
        ),
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              AboutItem("Albert Amadeusz Grycman", "albertamadeusz.grycman@ue-germany.de"),
              AboutItem("Taha Al-Hadhary", "taha.alhadhary@ue-germany.de"),
              AboutItem("Luiz Felipe Kormann", "e-mail"),
              AboutItem("Thaís Martin Baramarchi", "e-mail"),
              AboutItem("Adnan Farra", "e-mail"),
              AboutItem("Sean Feyintola Lasekan", "e-mail"),
            ],
          ),
        ),
      ),
    );
  }

  // ignore: non_constant_identifier_names
  Widget AboutItem(String name, String email){
    return Padding(
      padding: const EdgeInsets.all(15.0),
      child: Column(
        children: [
          Text(
            name,
            style: TextStyle(
                color: Theme.of(context).primaryColor,
                fontSize: 20
            ),
          ),
          Container(
            height: 10,
          ),
          Text(
            email,
            style: TextStyle(
              color: Theme.of(context).primaryColor,
              fontSize: 18,
              fontWeight: FontWeight.w300,
            ),
          ),
          Container(
            height: 10,
          ),
          Divider(
            color: Theme.of(context).primaryColor,
            thickness: 2,
          )
        ],
      ),
    );
  }
}
