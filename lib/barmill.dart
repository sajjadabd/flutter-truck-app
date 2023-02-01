import 'package:flutter/material.dart';

class Barmill extends StatelessWidget {

  final List<dynamic> trucks;

  const Barmill({Key? key, required this.trucks}) : super(key: key);



  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.grey[200],
        appBar: AppBar(
          // Here we take the value from the MyHomePage object that was created by
          // the App.build method, and use it to set our appbar title.
          title: const Text(
              'بارمیل' ,
              style : TextStyle(
                fontFamily: 'Shabnam',
                color: Colors.white,
              )
          ),
          centerTitle: true,
          backgroundColor: Colors.black87,
        ),
        body : buildListView()
    );
  }

  Widget buildListView() {
    if(trucks.length <= 0) {
      return Center (
          child : Card(
              child : Container(
                padding: EdgeInsets.all(20),
                child: const Text(
                    'ورودی نداشت' ,
                    style : TextStyle(
                        fontFamily: 'Shabnam',
                        fontSize: 16 ,
                        fontWeight: FontWeight.bold,
                        color:  Colors.black54
                    )
                ),
              )
          )
      );
    } else {
      return ListView.builder(
          itemCount: trucks.length,
          itemBuilder: (context, index) {
            return Card(
              child: ListTile(
                onTap: () {},
                title: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: <Widget>[
                    Row(
                      children: <Widget>[
                        const Text(
                            'عدد',
                            style: TextStyle(
                              fontSize: 10,
                              fontFamily: 'Shabnam',
                              color: Colors.black,
                            )
                        ),
                        Text(
                            trucks[trucks.length - index -
                                1]['BilletInputCount'].toString(),
                            style: const TextStyle(
                              fontSize: 10,
                              fontFamily: 'Shabnam',
                              color: Colors.black,
                            )
                        ),
                      ],
                    ),
                    Expanded(
                      child: Center(
                        child : Text(
                            trucks[trucks.length-index-1]['BilletDescription'] ,
                            style : const TextStyle(
                              fontSize: 10,
                              fontFamily: 'Shabnam',
                              color: Colors.black,
                            )
                        ),
                      ),
                    ),
                    Text(
                        (trucks.length - (index)).toString(),
                        style: const TextStyle(
                          fontSize: 10,
                          fontFamily: 'Shabnam',
                          color: Colors.black,
                        )
                    ),
                  ],
                ),
              ),
            );
          }
      );
    }
  }
}
