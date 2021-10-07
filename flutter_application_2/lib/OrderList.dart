import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'dart:convert' as convert;
import 'package:http/http.dart' as http;

class OrdersList extends StatefulWidget {
  OrdersListState createState() => OrdersListState();
}

class OrdersListState extends State<OrdersList> {
  Future<List<OrderDetails>> _getData() async {
    List<OrderDetails> ordersList = [];

    var url = Uri.http('www.nisargasanjeevini.in', '/admin/shop-sales');
    var response = await http.get(url);
    print("Response: $response");
    if (response.statusCode == 200) {
      var jsonResponse = convert.jsonDecode(response.body);
      var ordersListJson = jsonResponse["payload"];

      for (var eachOrderJson in ordersListJson) {
        OrderDetails orderObj = OrderDetails(
            orderNumber: eachOrderJson['orderNumber'],
            buyerId: eachOrderJson['buyerId'],
            sellerId: eachOrderJson['sellerId'],
            totalPrice: eachOrderJson['totalPrice'],
            quantity: eachOrderJson['quantity'],
            paymentOption: eachOrderJson['paymentOption'],
            placedDateInLocalDate: eachOrderJson['placedDateInLocalDate']);

        ordersList.add(orderObj);
      }
      print(ordersList.length);

      return ordersList;
    } else {
      print('Request failed with status: ${response.statusCode}.');
      return ordersList;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: new AppBar(
        centerTitle: true,
        title: new Text("All Orders"),
      ),
      body: Container(
        alignment: Alignment.center,
        child: FutureBuilder<List<OrderDetails>>(
            future: _getData(),
            builder: (BuildContext context,
                AsyncSnapshot<List<OrderDetails>> snapshot) {
              if (snapshot.data == null) {
                return Container(child: Center(child: Text("Loading...")));
              } else {
                return ListView.builder(
                    itemCount: snapshot.data?.length ?? 0,
                    itemBuilder: (BuildContext context, int index) {
                      return Padding(
                          padding: EdgeInsets.all(20),
                          child: Material(
                              elevation: 10,
                              child: Container(
                                decoration: BoxDecoration(
                                    color: Colors.yellow,
                                    borderRadius: BorderRadius.all(
                                        Radius.circular(10.0)) //Border.all
                                    ),
                                child: Container(
                                    height: 150,
                                    child: ListTile(
                                        title: Text(
                                            snapshot.data![index].orderNumber ??
                                                ""),
                                        subtitle: Text(
                                            "BuyerId: ${snapshot.data![index].buyerId ?? 0} \n SellerId:  ${snapshot.data![index].sellerId ?? 0} \n Totalprice:  ${snapshot.data![index].totalPrice ?? 0} \n Quantity:  ${snapshot.data![index].quantity ?? 0} \n paymentOption:  ${snapshot.data![index].paymentOption ?? " "}  \n PlacedDateInLocalDate:  ${snapshot.data![index].placedDateInLocalDate ?? ""}"))),
                              )));
                    });
              }
            }),
      ),
    );
  }
}

class OrderDetails {
  final String? orderNumber;
  final int? buyerId;
  final int? sellerId;
  final int? totalPrice;
  final int? quantity;
  final String? paymentOption;
  final String? placedDateInLocalDate;

  OrderDetails(
      {this.orderNumber,
      this.buyerId,
      this.sellerId,
      this.totalPrice,
      this.quantity,
      this.paymentOption,
      this.placedDateInLocalDate});
}
