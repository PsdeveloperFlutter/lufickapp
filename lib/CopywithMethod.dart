class MyClass {
  final String name;
  final int age;

  MyClass({required this.name, required this.age});

  MyClass copyWith({String? name, int? age}) {
    return MyClass(
      name: name ?? this.name,
      age: age ?? this.age,
    );
  }
}

void main() {
  MyClass original = MyClass(name: 'John', age: 30);
  MyClass copy = original.copyWith(name: 'Jane');
  print(copy.name); // prints 'Jane'
  print(copy.age); // prints 30
}