import 'dart:convert';

import 'package:cinema_app/globalVariables.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class SallesPage extends StatefulWidget {
  dynamic cinema;
  SallesPage(this.cinema);
  @override
  _SallesPageState createState() => _SallesPageState();
}

class _SallesPageState extends State<SallesPage> {
  List<dynamic> listSalles;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Salles de ${widget.cinema['name']}"),
      ),
      body: Center(
          child: this.listSalles == null
              ? CircularProgressIndicator()
              : ListView.builder(
                  itemCount:
                      (this.listSalles == null) ? 0 : this.listSalles.length,
                  itemBuilder: (context, index) {
                    return Card(
                        color: Colors.white70,
                        child: Column(
                          children: [
                            Container(
                              width: double.infinity,
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: RaisedButton(
                                  color: Colors.redAccent,
                                  child: Text(this.listSalles[index]['name'],
                                      style: TextStyle(color: Colors.white)),
                                  onPressed: () {
                                    loadProjections(this.listSalles[index]);
                                  },
                                ),
                              ),
                            ),
                            if (this.listSalles[index]['projections'] != null)
                              Padding(
                                padding: const EdgeInsets.all(1.0),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Image.asset(
                                      "./images/spiderMan.jpg", width: 250,
                                      //Image.network(

                                      /* GlobalData.host +
                                          "/imageFilm/${this.listSalles[index]['currentProjection']['film']['id']}",*/
                                      // width: 150,
                                    ),
                                    Column(
                                      children: [
                                        ...(this.listSalles[index]
                                                    ['projections']
                                                as List<dynamic>)
                                            .map((projection) {
                                          return RaisedButton(
                                            color: (this.listSalles[index][
                                                            'currentProjection']
                                                        ['id'] ==
                                                    projection['id'])
                                                ? Colors.deepOrange
                                                : Colors.green,
                                            child: Text(
                                              "${projection['seance']['heureDebut']}(${projection['film']['duree']},Prix=${projection['prix']})",
                                              style: TextStyle(
                                                  color: Colors.black,
                                                  fontSize: 12),
                                            ),
                                            onPressed: () {
                                              loadTickets(projection,
                                                  this.listSalles[index]);
                                            },
                                          );
                                        })
                                      ],
                                    )
                                  ],
                                ),
                              ),
                            if (this.listSalles[index]['currentProjection'] !=
                                    null &&
                                this.listSalles[index]['currentProjection']
                                        ['listTickets'] !=
                                    null &&
                                this
                                        .listSalles[index]['currentProjection']
                                            ['listTickets']
                                        .length >
                                    0)
                              Column(
                                children: [
                                  Row(
                                    children: [
                                      Text(
                                          "Nombre de places disponible:${this.listSalles[index]['currentProjection']['nombrePlacesDisponibles']}")
                                    ],
                                  ),
                                  Container(
                                    padding: EdgeInsets.fromLTRB(6, 2, 6, 2),
                                    child: TextField(
                                      decoration: InputDecoration(
                                          hintText: 'Your name'),
                                    ),
                                  ),
                                  Container(
                                    padding: EdgeInsets.fromLTRB(6, 2, 6, 2),
                                    child: TextField(
                                      decoration: InputDecoration(
                                          hintText: 'Code payemant'),
                                    ),
                                  ),
                                  Container(
                                    padding: EdgeInsets.fromLTRB(6, 2, 6, 2),
                                    child: TextField(
                                      decoration: InputDecoration(
                                          hintText: 'Nombre de Tickets'),
                                    ),
                                  ),
                                  Container(
                                      width: double.infinity,
                                      child: RaisedButton(
                                        color: Colors.redAccent,
                                        child: Text(
                                          "Réserver les places",
                                          style: TextStyle(color: Colors.white),
                                        ),
                                        onPressed: () {},
                                      )),
                                  Wrap(
                                    children: [
                                      ...listSalles[index]['currentProjection']
                                              ['listTickets']
                                          .map((ticket) {
                                        if (ticket['reservee'] == false)
                                          return Container(
                                            width: 50,
                                            padding: EdgeInsets.all(2),
                                            child: RaisedButton(
                                              color: Colors.blueAccent,
                                              child: Text(
                                                "${ticket['place']['numero']}",
                                                style: TextStyle(
                                                    color: Colors.white,
                                                    fontSize: 12),
                                              ),
                                              onPressed: () {},
                                            ),
                                          );
                                        else
                                          return Container();
                                      })
                                    ],
                                  )
                                ],
                              ),
                          ],
                        ));
                  })),
    );
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    loadSalles();
  }

  void loadSalles() {
    var url = Uri.parse(this.widget.cinema['_links']['salles']['href']);

    http.get(url).then((resp) {
      setState(() {
        this.listSalles = json.decode(resp.body)['_embedded']['salles'];
      });
    }).catchError((err) {
      print(err);
    });
  }

  void loadProjections(salle) {
    var url = Uri.parse(
        GlobalData.host + "/salles/${salle['id']}/projections?projection=p1");

    //String url1=GlobalData.host+"/salles/${salle['id']}/projections?projection=p1";
    //var url2 = Uri.parse(salle['_links']['projections']['href'])
    //.toString().replaceAll("{?projection}", "?projection=p1");

    //print(url1);
    print(url);
    http.get(url).then((resp) {
      setState(() {
        salle['projections'] =
            json.decode(resp.body)['_embedded']['projections'];
        salle['currentProjection'] = salle['projections'][0];
        salle['currentProjection']['listTickets'] = [];
        //print(salle['projections']);
      });
    }).catchError((err) {
      print(err);
    });
  }

  void loadTickets(projection, salle) {
    var url = Uri.parse(
        "http://192.168.56.1:8080/projections/1/tickets?projection=ticketProj");
    var url1 = Uri.parse(projection['_links']['tickets']['href']
        .toString()
        .replaceAll("{?projection}", "?projection=p2"));
    // var url = Uri.parse(['_links']['tickets']['href']
    //.toString()
    //.replaceAll("{?projection}", "?projection=p2"));
    http.get(url1).then((resp) {
      setState(() {
        projection['listTickets'] =
            json.decode(resp.body)['_embedded']['tickets'];
        salle['currentProjection'] = projection;
        projection['nombrePlacesDisponibles'] =
            nombrePlaceDisponibles(projection);
      });
    }).catchError((err) {
      print(err);
    });
  }

  nombrePlaceDisponibles(projection) {
    int nombre = 0;
    for (int i = 0; i < projection['tickets'].length; i++) {
      if (projection['tickets'][i]['reservee'] == false) ++nombre;
    }
    return nombre;
  }
}
