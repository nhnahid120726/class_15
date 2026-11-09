class animal{
  void makesound(){
    print("Animal make Sount");
  }
}
class Dog extends animal {
  @override
  void makesound(){
    print("Dog says woof woof woof");
  }
}
class cat extends animal {
  @override
  void makesound(){
    print("Cat says meow meow meow");
  }
}

void main(){
  animal Cat = cat();
  animal dog =Dog();

  dog.makesound();
  Cat.makesound();
}