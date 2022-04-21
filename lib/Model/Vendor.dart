


import 'dart:io';

class Vendors {
  String ?id;
  String ?name;
  String ?start;
  String ?end;
  String ?image;
  String ?deliverytime;
  String ?specialty;
  String ?deliveryfee;
  String ?location;



  Vendors(
      {this.id,
        this.name,
        this.start,
        this.end,
        this.image,
        this.deliveryfee,
        this.deliverytime,
        this.specialty,
        this.location,
      });

  Map<String, dynamic> toJson() {
    return {
      "name": name,
      '_id': id,
      "start": start,
      'end': end,
      'image': image,
      'deliveryfee': deliveryfee,
      'deliverytime': deliverytime,
      'specialty': specialty,
      'location': location
    };
  }

  factory Vendors.fromJson(jsonData) => Vendors(
    name: jsonData["name"],
    id: jsonData["_id"],
    start: jsonData['start'],
    end: jsonData['end'],
    image: jsonData['image'],
    deliveryfee: jsonData['deliveryfee'],
    deliverytime: jsonData['deliverytime'],
    specialty: jsonData['specialty'],
    location: jsonData['location'],
  );
}





class Search {
  String ?id;
  String ?name;
  String ?start;
  String ?end;
  String ?image;
  String ?deliverytime;
  String ?specialty;
  String ?deliveryfee;
  String ?location;
  String ?status;


  final category;
  String ?vendor;
  String ?menu;
  // String ?name;
  // String ?image;
  String ?description;
  String ?price;
  String ?vendortitle;



  Search(
      {this.id,
        this.name,
        this.start,
        this.end,
        this.image,
        this.deliveryfee,
        this.location,
        this.deliverytime,
        this.specialty,
        this.status,


        // this.id,
        this.category,
        this.vendor,
        // this.image,
        // this.name,
        this.menu,
        this.description,
        this.price,
        this.vendortitle,

      });

  Map<String, dynamic> toJson() {
    return {
      "name": name,
      '_id': id,
      "start": start,
      'end': end,
      "status": status,
      'image': image,
      "location": location,
      'deliveryfee': deliveryfee,
      'deliverytime': deliverytime,
      'specialty': specialty,
      "vendortitle": vendortitle,
      "price": price,
      "description": description,
      "title": name,
      // "image": image,
      "menu": menu,
      "vendor": vendor,
      "category": category,
      // '_id': id,
    };
  }

  factory Search.fromJson(jsonData) => Search(
    name: jsonData["name"]==null?jsonData["title"]:jsonData["name"],
    id: jsonData["_id"],
    start: jsonData['start'],
    location: jsonData["location"],
    end: jsonData['end'],
    image: jsonData['image'],
    deliveryfee: jsonData['deliveryfee'],
    deliverytime: jsonData['deliverytime'],
    specialty: jsonData['specialty'],
    status: jsonData['status'],



    vendortitle: jsonData["vendortitle"],
    price: jsonData["price"],
    description: jsonData["description"],
    // name: jsonData["title"],
    // image: jsonData["image"],
    menu: jsonData["menu"],
    vendor: jsonData["vendor"],
    category: jsonData["category"],
    // id: jsonData["_id"],
  );
}