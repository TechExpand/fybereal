import 'dart:io';

import 'CategoryModel.dart';

class OrderHistoryModel {
  String ?id;
  String ?user;
  String ?name;
  Map ?menu;

  OrderHistoryModel(
      {this.id,
        this.menu,
        this.user,
        this.name,
      });

  Map<String, dynamic> toJson(){
    return {
      "user": user,
      '_id': id,
      "menu": menu,
      // if (this.menu != null)
      //   'menu' : this.menu!.toJson(),
    };
  }

  factory OrderHistoryModel.fromJson(jsonData) => OrderHistoryModel(
    user: jsonData["user"],
    id: jsonData["_id"],
    menu: jsonData['menu']
  );
}





class CartModel {
  String ?id;
  String ?quantity;
  Map ?menu;
  final specialty;
  final name;

  CartModel(
      {this.id,
        this.quantity,
        this.menu,
        this.name,
        this.specialty,
      });

  Map<String, dynamic> toJson(){
    return {
      "quantity": quantity,
      '_id': id,
      "menu": menu,
      "specialty": specialty,
      // if (this.menu != null)
      //   'menu' : this.menu!.toJson(),
    };
  }

  factory CartModel.fromJson(jsonData) => CartModel(
      quantity: jsonData["quantity"],
      id: jsonData["_id"],
      specialty: jsonData["specialty"],
      // menu: jsonData['menu'] != null ?  MenuModel.fromJson(jsonData['menu']) : null,
      menu: jsonData['menu']
  );
}
