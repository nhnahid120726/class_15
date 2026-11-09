import 'dart:io';


class bankAccount {
  var _balance =0.0;
  void deposit(){
    stdout.write("deposit ammount");
    var amount=int.parse(stdin.readLineSync()!);
    _balance+=amount;
    print("$amount deposit");
  }
  void withdro(){
    stdout.write("withdro ammount");
    var amount=int.parse(stdin.readLineSync()!);
    _balance -=amount;
    print("$_balance withdro");
  }
  void showbalance(){
    print("My current balance is $_balance");
  }
}
class atm extends bankAccount{
}