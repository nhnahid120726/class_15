import 'dart:io';

void main(){
  stdin.readLineSync();


  print("গাড়ির ব্র্যান্ড  মডেল   দাম          সংক্ষিপ্ত বিবরণ");
  var car1=car()
  ..name ="Toyota"
  ..model= "Corolla"
  ..price=35
  ..deatils="চমৎকার মাইলেজ এবং দৈনন্দিন ব্যবহারের জন্য টেকসই।"
  ..showdeatils();

  var car2=car()
    ..name ="Honda"
    ..model= "Civic"
    ..price=40
    ..deatils="স্টাইলিশ স্পোর্টি লুক এবং অত্যন্ত আরামদায়ক সিটিং।"
    ..showdeatils();

  var car3=car()
    ..name ="Nissan"
    ..model= "X-Trail"
    ..price=45
    ..deatils="পরিবারের জন্য আদর্শ একটি এসইউভি (SUV) এবং অফ-রোডে দারুণ।"
    ..showdeatils();

  var car4=car()
    ..name ="Hyundai"
    ..model= "Tucson"
    ..price=55
    ..deatils="প্রিমিয়াম ডিজাইন, শক্তিশালী ইঞ্জিন এবং আধুনিক সেফটি ফিচার।"
    ..showdeatils();

  var car5=car()
    ..name ="Mitsubishi"
    ..model= "Outlander"
    ..price=50
    ..deatils="প্রশস্ত ইন্টেরিয়র এবং মসৃণ ড্রাইভিং অভিজ্ঞতা।"
    ..showdeatils();


}

class car{
  var name ="";
  var model ="";
  var price =0;
  var deatils ="";

  void showdeatils(){
    print("$name $model $price $deatils");
  }


}