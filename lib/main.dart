import 'package:flutter/material.dart';
import 'constant.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(title: 'Flutter Demo', home: HomePage());
  }
}

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<Widget> itemsData = [];
  ScrollController controller = ScrollController();
  double topContainerScale = 0;
  bool closeTopContainer = false;

  getThingsData() {
    List<dynamic> responseList = THINGS_DATA;
    List<Widget> thingsItemList = [];

    responseList.forEach((item) {
      thingsItemList.add(Container(
          padding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 12.0),
          height: 200,
          child: Container(
            decoration: BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(20.0)),
                color: Colors.white,
                image: DecorationImage(
                    image: AssetImage('assets/' + item["name"] + '.jpg'),
                    fit: BoxFit.cover,
                    colorFilter: ColorFilter.mode(
                        Colors.white.withOpacity(.4), BlendMode.dstATop)),
                boxShadow: [
                  BoxShadow(
                      color: Colors.black.withAlpha(100), blurRadius: 10.0),
                ]),
            padding: EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                Text(item["name"],
                    style:
                        TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                Text(item["price"].toString())
              ],
            ),
          )));
    });
    setState(() {
      itemsData = thingsItemList;
    });
  }

  @override
  void initState() {
    getThingsData();
    super.initState();

    controller.addListener(() {
      double val = controller.offset / (200 * 0.55);
      setState(() {
        closeTopContainer = controller.offset > 30;
        topContainerScale = val;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    final double categoryHeight = size.height * 0.30;
    return Scaffold(
        // appBar: AppBar(backgroundColor: Colors.white),
        body: Container(
      height: size.height,
      child: Column(
        children: <Widget>[
          AnimatedOpacity(
            duration: Duration(milliseconds: 250),
            opacity: closeTopContainer ? 0 : 1,
            child: AnimatedContainer(
                width: size.width,
                padding: EdgeInsets.only(bottom: 16.0),
                duration: Duration(milliseconds: 250),
                height: closeTopContainer ? 70 : categoryHeight,
                decoration: BoxDecoration(
                    image: DecorationImage(
                        image: AssetImage('assets/sample.jpg'),
                        fit: BoxFit.cover)),
                child: Align(
                  alignment: Alignment.bottomLeft,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text("Japan",
                        style: TextStyle(
                            fontSize: 30,
                            fontWeight: FontWeight.bold,
                            color: Colors.white)),
                  ),
                )),
          ),
          Expanded(
            child: ListView.builder(
                controller: controller,
                itemCount: itemsData.length,
                itemBuilder: (context, index) {
                  double scale = 1.0;
                  if (topContainerScale > 0.5) {
                    scale = index + 0.5 - topContainerScale;
                    if (scale < 0) {
                      scale = 0;
                    } else if (scale > 1) {
                      scale = 1;
                    }
                  }
                  return Transform(
                    alignment: Alignment.bottomCenter,
                    transform: Matrix4.identity()..scale(scale, scale),
                    child: Opacity(
                      opacity: scale,
                      child: Align(
                          alignment: Alignment.topCenter,
                          heightFactor: 0.55,
                          child: itemsData[index]),
                    ),
                  );
                }),
          )
        ],
      ),
    ));
  }
}
