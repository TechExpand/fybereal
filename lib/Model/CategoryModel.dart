import 'dart:io';

class CategoryModel {
  String ?id;
  String ?name;
  bool ?loading = true;

  CategoryModel(
      {this.id,
        this.name,
        this.loading,
      });

  Map<String, dynamic> toJson(){
    return {
      "title": name,
      '_id': id,
    };
  }

  factory CategoryModel.fromJson(jsonData) => CategoryModel(
    name: jsonData["title"],
    id: jsonData["_id"],
  );
}





class TransactionModel {
  String ?id;
  String ?user;
  String ?amount;
  String ?status;
  String ?message;
  String ?name;
  String ?date;

  TransactionModel(
      {this.id,
        this.user,
        this.name,
        this.amount,
        this.message,
        this.status,
        this.date,
      });

  Map<String, dynamic> toJson(){
    return {
      "message": message,
      "user": user,
      "amount": amount,
      '_id': id,
      "status": status,
      "date": date,
    };
  }

  factory TransactionModel.fromJson(jsonData) => TransactionModel(
    message: jsonData["message"],
    status: jsonData["status"],
    user: jsonData["user"],
    amount: jsonData["amount"],
    id: jsonData["_id"],
    date:jsonData["date"],
  );
}




class MenuModel {
  String ?id;
  final category;
  String ?vendor;
  String ?menu;
  String ?name;
  String ?image;
  String ?description;
  String ?price;
  String ?vendortitle;

  MenuModel(
      {this.id,
        this.category,
        this.vendor,
        this.image,
        this.name,
        this.menu,
        this.description,
        this.price,
        this.vendortitle,
      });

  Map<String, dynamic> toJson(){
    return {
      "vendortitle": vendortitle,
      "price": price,
      "description": description,
      "title": name,
      "image": image,
      "menu": menu,
      "vendor": vendor,
      "category": category,
      '_id': id,
    };
  }

  factory MenuModel.fromJson(jsonData) => MenuModel(
    vendortitle: jsonData["vendortitle"],
    price: jsonData["price"],
    description: jsonData["description"],
    name: jsonData["title"],
    image: jsonData["image"],
    menu: jsonData["menu"],
    vendor: jsonData["vendor"],
    category: jsonData["category"],
    id: jsonData["_id"],
  );
}


