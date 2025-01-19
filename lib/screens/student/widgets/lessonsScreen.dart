// import 'package:flutter/material.dart';
// import 'package:gtec/models/student_model.dart';
// import 'package:gtec/provider/student_provider.dart';
// import 'package:gtec/screens/student/widgets/user_quiz.dart';
// import 'package:provider/provider.dart';

// class LessonsScreen extends StatelessWidget {
//   const LessonsScreen({super.key});

//   @override
//   Widget build(BuildContext context) {
//     final provider = Provider.of<StudentAuthProvider>(context, listen: false);

//     return Scaffold(
//       appBar: AppBar(
//         title: const Text("Lessons, Assignments, and Quiz"),
//       ),
//       body: FutureBuilder<void>(
//         future: provider.fetchLessonsAndAssignmentsquiz(),
//         builder: (context, snapshot) {
//           if (snapshot.connectionState == ConnectionState.waiting) {
//             return const Center(child: CircularProgressIndicator());
//           } else if (snapshot.hasError) {
//             return Center(child: Text('Error: ${snapshot.error}'));
//           } else {
//             // Fetch lessons, assignments, and quiz
//             final lessons = provider.lessons;
//             final assignments = provider.assignments;
//             final quiz = provider.quiz;

//             // Check if no content is available
//             if (lessons.isEmpty && assignments.isEmpty && quiz.isEmpty) {
//               return const Center(
//                 child: Text('No content available for this module.'),
//               );
//             }

//             // Display lessons, assignments, and quiz
//             return ListView(
//               children: [
//                 if (lessons.isNotEmpty) ...[
//                   const Padding(
//                     padding: EdgeInsets.all(8.0),
//                     child: Text(
//                       'Lessons',
//                       style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
//                     ),
//                   ),
//                   ...lessons.map((lesson) {
//                     return Card(
//                       margin: const EdgeInsets.symmetric(
//                           horizontal: 16.0, vertical: 8.0),
//                       elevation: 4,
//                       child: ListTile(
//                         title: Text(lesson.title),
//                         subtitle: Text(lesson.content),
//                       ),
//                     );
//                   }),
//                 ],
//                 if (assignments.isNotEmpty) ...[
//                   const Padding(
//                     padding: EdgeInsets.all(8.0),
//                     child: Text(
//                       'Assignments',
//                       style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
//                     ),
//                   ),
//                   ...assignments.map((assignment) {
//                     return Card(
//                       margin: const EdgeInsets.symmetric(
//                           horizontal: 16.0, vertical: 8.0),
//                       elevation: 4,
//                       child: ListTile(
//                         title: Text(assignment.title),
//                         subtitle: Text(assignment.description),
//                       ),
//                     );
//                   }),
//                 ],
//                 if (quiz.isNotEmpty) ...[
//                   const Padding(
//                     padding: EdgeInsets.all(8.0),
//                     child: Text(
//                       'Quiz',
//                       style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
//                     ),
//                   ),
//                   ...quiz.map((quizItem) {
//                     return Card(
//                       margin: const EdgeInsets.symmetric(
//                           horizontal: 16.0, vertical: 8.0),
//                       elevation: 4,
//                       child: ListTile(
//                         title: Text(quizItem.name),
//                         subtitle: Text(quizItem.description),
//                         onTap: () {
//                           // Navigate to quiz details or start quiz page
//                           Navigator.push(
//                             context,
//                             MaterialPageRoute(
//                               builder: (context) => QuizDetailScreen(quiz: quizItem),
//                             ),
//                           );
//                         },
//                       ),
//                     );
//                   }),
//                 ],
//               ],
//             );
//           }
//         },
//       ),
//     );
//   }
// }

