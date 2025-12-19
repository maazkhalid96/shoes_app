// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:flutter/material.dart';

// class CartsPlusWidget extends StatefulWidget {
//   final String cartId;
//   final String uid;
//   final int initialQuantity;

//   const CartsPlusWidget(
//       {super.key,
//       required this.cartId,
//       required this.uid,
//       required this.initialQuantity});

//   @override
//   State<CartsPlusWidget> createState() => _CartsPlusWidgetState();
// }

// class _CartsPlusWidgetState extends State<CartsPlusWidget> {
//   late int quantity;

//   @override
//   void initState() {
//     super.initState();
//     quantity = widget.initialQuantity;
//   }

//   void updateQuantity(int newQty) async {
//     if (newQty < 1) return;

//     setState(() {
//       quantity = newQty;
//     });

//     await FirebaseFirestore.instance
//         .collection("carts")
//         .doc(widget.uid)
//         .collection("items")
//         .doc(widget.cartId)
//         .update({"quantity": quantity});
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Row(
//       children: [
//         IconButton(
//             onPressed: () => updateQuantity(quantity - 1),
//             icon: Icon(Icons.remove, color: Colors.red)),
//         Text(quantity.toString(), style: TextStyle(fontSize: 16)),
//         IconButton(
//             onPressed: () => updateQuantity(quantity + 1),
//             icon: Icon(Icons.add, color: Colors.green)),
//       ],
//     );
//   }
// }
