import 'package:flutter/material.dart';
import 'package:swipe_cards/draggable_card.dart';
import 'package:swipe_cards/swipe_cards.dart';
import 'package:renconsport/widgets/swipe/popup/popup_bio.dart';

class SwipeCard extends StatefulWidget {
  SwipeCard({Key? key, this.title}) : super(key: key);

  final String? title;

  @override
  _SwipeCardState createState() => _SwipeCardState();
}

class _SwipeCardState extends State<SwipeCard> {
  List<SwipeItem> _swipeItems = <SwipeItem>[];
  MatchEngine? _matchEngine;
  GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey();
  List<String> _names = [
    "Brown",
    "Teal",
    "Green",
    "Yellow",
    "Orange",
    "Grey",
    "Purple",
    "Pink"
  ];
  List<Color> _colors = [
    Colors.brown,
    Colors.teal,
    Colors.green,
    Colors.yellow,
    Colors.orange,
    Colors.grey,
    Colors.purple,
    Colors.pink
  ];

  @override
  void initState() {
    for (int i = 0; i < _names.length; i++) {
      _swipeItems.add(SwipeItem(
          content: {'text': _names[i], 'color': _colors[i]},
          likeAction: () {
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
              content: Text("Liked ${_names[i]}"),
              duration: Duration(milliseconds: 500),
            ));
          },
          nopeAction: () {
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
              content: Text("Nope ${_names[i]}"),
              duration: Duration(milliseconds: 500),
            ));
          },
          onSlideUpdate: (SlideRegion? region) async {
            print("Region $region");
          }));
    }

    _matchEngine = MatchEngine(swipeItems: _swipeItems);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        key: _scaffoldKey,
        body: Container(
            child: Stack(children: [
          Container(
            height: MediaQuery.of(context).size.height - kToolbarHeight,
            child: SwipeCards(
              matchEngine: _matchEngine!,
              itemBuilder: (BuildContext context, int index) {
                print(_swipeItems[index].content["color"]);
                return Container(
                  alignment: Alignment.center,
                  color: _swipeItems[index].content["color"],
                  child: Text(
                    _swipeItems[index].content["text"],
                    style: TextStyle(fontSize: 100),
                  ),
                );
              },
              onStackFinished: () {
                ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                  content: Text("Stack Finished"),
                  duration: Duration(milliseconds: 500),
                ));
              },
              itemChanged: (SwipeItem item, int index) {
                print("item: ${item.content["index"]}, index: $index");
              },
              leftSwipeAllowed: true,
              rightSwipeAllowed: true,
              upSwipeAllowed: true,
              fillSpace: true,
              likeTag: Container(
                margin: const EdgeInsets.all(15.0),
                padding: const EdgeInsets.all(3.0),
                decoration:
                    BoxDecoration(border: Border.all(color: Colors.green)),
                child: Text('Like'),
              ),
              nopeTag: Container(
                margin: const EdgeInsets.all(15.0),
                padding: const EdgeInsets.all(3.0),
                decoration:
                    BoxDecoration(border: Border.all(color: Colors.red)),
                child: Text('Nope'),
              ),               
            ),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                 IconButton(
                icon: Icon(Icons.close),
                iconSize: 55,
                color: Colors.red,
                onPressed: () {
                  _matchEngine!.currentItem?.nope();
                },
              ),
              PopupBio(),
              IconButton(
                icon: Icon(Icons.thumb_up_alt_sharp),
                iconSize: 50,
                color: Colors.blue,
                onPressed: () {
                  _matchEngine!.currentItem?.like();
                },
              ),
              ],
            ),
          )
        ])));
  }
}






  // @override
  // Widget build(BuildContext context) {
  //   return Container(
  //       child: Row(
  //           crossAxisAlignment: CrossAxisAlignment.end,
  //           mainAxisAlignment: MainAxisAlignment.spaceAround,
  //           children: [
  //             IconButton(
  //               icon: Icon(Icons.close),
  //               iconSize: 55,
  //               color: Colors.red,
  //               onPressed: () {},
  //             ),
  //             PopupBio(),
  //             IconButton(
  //               icon: Icon(Icons.thumb_up_alt_sharp),
  //               iconSize: 50,
  //               color: Colors.blue,
  //               onPressed: () {},
  //             ),
  //           ]),
  //       height: MediaQuery.of(context).size.width * 2,
  //       width: MediaQuery.of(context).size.width,
  //       decoration: BoxDecoration(
  //           image: DecorationImage(
  //               image: AssetImage('assets/muscu.png'), fit: BoxFit.cover)));
  // }
// }
