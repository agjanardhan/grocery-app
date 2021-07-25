import 'package:citimark0710/database.dart';
import 'package:citimark0710/selection/categories.dart';
import 'package:citimark0710/selection/things.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:citimark0710/widget.dart';
import '../chatroom.dart';
import '../dashboard.dart';
import 'cart.dart';

class ListBoard extends StatefulWidget {

   @override
  _ListBoardState createState() => _ListBoardState();
}

class _ListBoardState extends State<ListBoard> {

  DatabaseMethods databaseMethods = new DatabaseMethods();
  QuerySnapshot querySnapshot;
  List<things> _things = List<things>();
  List<String> _cartList = List<String>();
  @override
  void initState() {
    super.initState();
    listthings();
  }
  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(title: Text("mr.Cart"),
        centerTitle: true,
        actions: [
          Padding(padding: const EdgeInsets.only(right: 16.0, top: 8.0),
            child: GestureDetector(
              child: Icon(Icons.shopping_cart, size: 36,),
              onTap: () async{
                if (_cartList.isNotEmpty)
                 await Navigator.push(context, MaterialPageRoute(
                      builder: (context) => cart(_cartList)
                  )
                  );
              },
            ),
          )
        ],
      ),
      body:_gridView(),
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

   _gridView() {
    return _things != null ? GridView.builder(
        padding: const EdgeInsets.all(4.0),
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2),
        itemCount: _things.length,
        itemBuilder: (context, index) {
          var item = _things[index];
          return GestureDetector(
            onTap: ()async{
             await Navigator.push(context, MaterialPageRoute(
                  builder: (context) => Category(item.name,_cartList)));
            },
            child: Card(
                  elevation: 4.0,
                  child: Stack(
                    fit: StackFit.loose,
                    alignment: Alignment.center,
                    children: [
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Image(image: AssetImage(item.image),),
                          Text(item.name, textAlign: TextAlign.center, style: mediumtextstyle1())
                        ],
                      ),
                    ],
                  )
            ),
          );
        }
        ): Container(child: Center(child: CircularProgressIndicator()));
  }

  void listthings() {
    var list = <things>[
      things(
        name: 'atta&flour',
        image: 'assets/atta.png',
      ),
      things(
        name: 'rice',
        image: 'assets/rice.png',
      ),
      things(
        name: 'dals&pulses',
        image: 'assets/dal.png',
      ),
      things(
        name: 'oil&ghee',
        image: 'assets/oilghee.png',
      ),
      things(
        name: 'spices',
        image: 'assets/masala.png',
      ),
      things(
        name: 'salt&sugar',
        image: 'assets/sugarsalt.png',
      ),
      things(
        name: 'biscuits',
        image: 'assets/biscuits.png',
      ),
      things(
        name: 'noodles&pasta',
        image: 'assets/maggi.png',
      ),
      things(
        name: 'chips',
        image: 'assets/lays.png',
      ),
      things(
        name: 'tea&coffee',
        image: 'assets/coffeetea.png',
      ),
      things(
        name: 'health drinks',
        image: 'assets/boost.png',
      ),
      things(
        name: 'soft drinks',
        image: 'assets/cooldrinks.png',
      ),
      things(
        name: 'detergents',
        image: 'assets/harpic.png',
      ),
      things(
        name: 'household cleaning',
        image: 'assets/tide.png',
      ),
      things(
        name: 'dishwashing',
        image: 'assets/vim.png',
      ),
      things(
        name: 'fresheners&repellants',
        image: 'assets/mangaldeep.png',
      ),
      things(
        name: 'bath and body',
        image: 'assets/dettol.png',
      ),
      things(
        name: 'haircare',
        image: 'assets/shampoo.jpeg',
      ),
      things(
        name: 'deodorants',
        image: 'assets/axe.png',
      ),
      things(
        name: 'oralcare',
        image: 'assets/colgate.png',
      ),
    ];
    setState(() {
      _things = list;
    });
  }

}