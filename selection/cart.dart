import 'package:citimark0710/widget.dart';
import 'package:flutter/material.dart';
import 'package:citimark0710/database.dart';
import '../dashboard.dart';

class cart extends StatefulWidget {
 final List<String> _cartList;
  cart(this._cartList);
  @override
  _cartState createState() => _cartState(this._cartList);
}

class _cartState extends State<cart> {
  List<String> _cartList;
  _cartState(this._cartList);

  DatabaseMethods databaseMethods =DatabaseMethods();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
     appBar: AppBar(
       title:Text('cart'),
     ),
      body:
            ListView.builder(
             itemCount: _cartList.length,
             itemBuilder: (context,index){
             var item =_cartList[index];
             return Card(
                child:
                Row(
                  children: [
                     Text(item,style: singletextstyle()),
                    Spacer(),
                    Padding(
                      padding: const EdgeInsets.only(bottom:8.0,right:8.0),
                      child: IconButton(icon:Icon(Icons.remove_circle,size:30),
                          onPressed: ()async{
                            ConfirmAction action = await _asyncConfirmDialog(context);
                            if (action != ConfirmAction.Cancel) {
                              setState(() {
                                _cartList.remove(item);
                              });
                            }
                          },
                          ),
                        ),
                  ],
                )
            );
          }),
      floatingActionButton: FloatingActionButton(
        onPressed: function,
        tooltip: 'order',
        child: Icon(Icons.add_shopping_cart),
      ),

    );
  }
  void function(){
    Navigator.push(context, MaterialPageRoute(
        builder: (context) => DashboardPage(_cartList)
    )
    );
  }
}
enum ConfirmAction {Cancel,Accept}
Future<ConfirmAction> _asyncConfirmDialog(BuildContext context) async{
  return await showDialog<ConfirmAction>(
      context:context,
      barrierDismissible: false,
      builder: (BuildContext context){
        return AlertDialog(
          title: Text('Remove this item?'),
          content: Text('This will remove the item from your cart.'),
          actions: [
            FlatButton(
              child: Text('Cancel'),
              onPressed: (){
                Navigator.of(context).pop(ConfirmAction.Cancel);
              },
            ),
            FlatButton(
              child: Text('Remove'),
              onPressed: (){
                Navigator.of(context).pop(ConfirmAction.Accept);
              },
            ),
          ],
        );
      }
  );
}