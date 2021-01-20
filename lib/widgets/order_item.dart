import 'package:flutter/material.dart';
import '../provider/Orders.dart';
import 'package:intl/intl.dart';
import 'dart:math';

class SingleOrderItem extends StatefulWidget {
  final Orders orderItems;

  SingleOrderItem(this.orderItems);

  @override
  _SingleOrderItemState createState() => _SingleOrderItemState();
}

class _SingleOrderItemState extends State<SingleOrderItem> {
  var _expanded = false;

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      height: _expanded ? min(widget.orderItems.products.length * 20.0 + 110, 200) : 100,
      duration: Duration(milliseconds: 300),
      child: Column(
        children: [
          ListTile(
            title: Text('Rs.${widget.orderItems.total}'),
            subtitle: Text(
              DateFormat('dd-MM-yyyy hh:mm').format(widget.orderItems.dateTime),
            ),
            trailing: IconButton(
              icon: Icon(_expanded ? Icons.expand_less : Icons.expand_more),
              onPressed: () {
                setState(() {
                  _expanded = !_expanded;
                });
              },
            ),
          ),
            AnimatedContainer(
              padding: EdgeInsets.all(10),
              duration: Duration(milliseconds: 300),
              height: _expanded ? min(widget.orderItems.products.length * 20.0 + 15, 200) : 0,
              child: ListView(
                children: widget.orderItems.products
                    .map(
                      (prod) => Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            '  ${prod.title}',
                            style: TextStyle(
                                color: Colors.black,
                                fontSize: 18,
                                fontWeight: FontWeight.bold),
                          ),
                          Text(
                            'Quantity: ${prod.quantity}  Price: Rs.${prod.price}  ',
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 18,
                            ),
                          )
                        ],
                      ),
                    )
                    .toList(),
              ),
            ),
          Divider()
        ],
      ),
    );
  }
}
