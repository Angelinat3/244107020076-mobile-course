// ignore_for_file: avoid_print

void main() {
  // 1. Calling the function just like print(greet(...))
  print(calculateRectangleArea(10.0, 5.0));

  // 2. Creating the object just like final student = Student(...)
  final myProfile = Profile(name: 'Angelina', studentId: '244107020076');

  // 3. Handling empty email safely just like print(nickname ?? 'NOT PROVIDED')
  print(myProfile.email ?? 'Email NOT PROVIDED');
}

// Using the arrow => syntax exactly like the greet() function in your example
double calculateRectangleArea(double length, double width) => length * width;

// Structured exactly like the Student class in your example
class Profile {
  Profile({required this.name, required this.studentId, this.email});
  
  final String name;
  final String studentId;
  final String? email; // The ? makes it optional, just like String? nickname
}
//AI being used to understand the example code faster +
// made the comment more comfortable to read