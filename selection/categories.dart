import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import '../dashboard.dart';
import '../widget.dart';
import 'cart.dart';
class Category extends StatefulWidget {
  final String item;
  final List<String> _cartList;
  Category(this.item,this._cartList);
  @override
  _CategoryState createState() => _CategoryState(this.item,this._cartList);
}

class _CategoryState extends State<Category> {
  String item;
  List<String> _cartList;
  _CategoryState(this.item,this._cartList);
  QuerySnapshot hoho;

  getcategory(String type) async{
    return await Firestore.instance.collection(type)
        .getDocuments();
  }
  @override
  void initState() {
    super.initState();
    getcategory(widget.item).then((value){
      setState(() {
      hoho= value;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("start"),),
      body:_gridView(),
      floatingActionButton: FloatingActionButton(
        onPressed: function,
        tooltip: 'order',
        child: Icon(Icons.add_shopping_cart),
      ),
    );
  }
  void function()async{
    await Navigator.push(context, MaterialPageRoute(
        builder: (context) => DashboardPage(_cartList)
    )
    );
  }

    _gridView() {
     return hoho != null ? GridView.builder(
               padding: const EdgeInsets.all(4.0),
               gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                   crossAxisCount: 2),
               itemCount: hoho.documents.length,
               itemBuilder: (context, index) {
                 var item = hoho.documents[index].data["Item"];
                 return Card(
                   elevation: 4.0,
                   child: Stack(
                     fit: StackFit.loose,
                     alignment: Alignment.center,
                     children: [
                       Column(
                         mainAxisAlignment: MainAxisAlignment.center,
                         children: [
                           //TODO image
                           Text(item, textAlign: TextAlign.center,
                               style: mediumtextstyle1())
                         ],
                       ),
                       Padding(
                         padding: const EdgeInsets.only(
                             right: 8.0, bottom: 8.0),
                         child: Align(alignment: Alignment.bottomRight,
                           child: GestureDetector(
                             child: (!_cartList.contains(item)) ?
                             Icon(Icons.add_circle) : Icon(Icons.remove_circle),
                             onTap: () {
                               setState(() {
                                 if (!_cartList.contains(item))
                                   _cartList.add(item);
                                 else
                                   _cartList.remove(item);
                               });
                             },
                           ),),
                       )
                     ],
                   ),
                 );
               }
           ) : Container(child: Center(child: CircularProgressIndicator()));
  }
}
