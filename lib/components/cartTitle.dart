import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:smartmarket1/cloudDatabase/cloud_service.dart';
import 'package:smartmarket1/components/cart_item.dart';
import 'package:smartmarket1/components/myquainityselector.dart';

class Carttitle extends StatefulWidget {
  final CartItem cartitem;
  const Carttitle({super.key, required this.cartitem});

  @override
  State<Carttitle> createState() => _CarttitleState();
}

class _CarttitleState extends State<Carttitle> {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
      ),
      margin: EdgeInsets.symmetric(horizontal: 25, vertical: 20),
      child: Column(
        children: [
          Row(
            children: [
              ClipRRect(
                child: Image.network(
                  widget.cartitem.product['imageUrl'],
                  height: 100,
                  width: 100,
                ),
              ),
              SizedBox(width: 10),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(widget.cartitem.product['productName']),
                  Text('\$' + widget.cartitem.product['productprice']),
                ],
              ),
              SizedBox(width: 70),
              Myquainityselector(
                quaintity: widget.cartitem.quaintity,
                onIncrement: () {
                  context.read<CloudService>().removeItemformCart(
                    widget.cartitem,
                  );
                },
                onDecement: () {
                  context.read<CloudService>().addTocart(
                    widget.cartitem.product,
                    widget.cartitem.selectAddon,
                  );
                },
                food: widget.cartitem.product,
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: SizedBox(
              height: widget.cartitem.selectAddon.isEmpty ? 0 : 60,
              width: double.infinity,
              child: ListView(
                scrollDirection: Axis.horizontal,
                children: widget.cartitem.selectAddon
                    .map(
                      (addon) => Padding(
                        padding: const EdgeInsets.only(right: 8.0),
                        child: FilterChip(
                          label: Row(
                            children: [
                              //addon name
                              Text(addon['name']),
                              SizedBox(width: 10),
                              //addon price
                              Text(
                                '\$' + addon['price'].toString(),
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 12,
                                ),
                              ),
                            ],
                          ),
                          shape: StadiumBorder(
                            side: BorderSide(color: Colors.black),
                          ),
                          onSelected: (value) {},
                          backgroundColor: Colors.amber,
                          labelStyle: TextStyle(
                            color: Colors.black,
                            fontSize: 13,
                          ),
                        ),
                      ),
                    )
                    .toList(),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
