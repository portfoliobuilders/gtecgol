// import 'package:flutter/material.dart';
// import 'package:gtec/provider/student_provider.dart';
// import 'package:gtec/screens/student/widgets/lessonsScreen.dart';
// import 'package:provider/provider.dart';

// class ModulesScreen extends StatelessWidget {
//   const ModulesScreen({super.key});

//   @override
//   Widget build(BuildContext context) {
//     final provider = Provider.of<StudentAuthProvider>(context, listen: false);

//     return Scaffold(
//       appBar: AppBar(
//         title: const Text("Modules"),
//       ),
//       body: FutureBuilder(
//         future: provider.fetchModulesForSelectedCourse(),
//         builder: (context, snapshot) {
//           if (snapshot.connectionState == ConnectionState.waiting) {
//             return const Center(child: CircularProgressIndicator());
//           } else if (snapshot.hasError) {
//             return Center(child: Text('Error: ${snapshot.error}'));
//           } else {
//             final modules = provider.modules;
//             if (modules.isEmpty) {
//               return const Center(child: Text('No modules available.'));
//             }
//             return ListView.builder(
//               itemCount: modules.length,
//               itemBuilder: (context, index) {
//                 final module = modules[index];
//                 return GestureDetector(
//                   onTap: () {
//                     provider.setSelectedModuleId(module.moduleId);
//                     Navigator.push(
//                       context,
//                       MaterialPageRoute(
//                         builder: (context) => LessonsScreen(),
//                       ),
//                     );
//                   },
//                   child: Card(
//                     margin: const EdgeInsets.symmetric(
//                         horizontal: 16.0, vertical: 8.0),
//                     elevation: 4,
//                     shape: RoundedRectangleBorder(
//                       borderRadius: BorderRadius.circular(12),
//                     ),
//                     child: Padding(
//                       padding: const EdgeInsets.all(16.0),
//                       child: Column(
//                         crossAxisAlignment: CrossAxisAlignment.start,
//                         children: [
//                           Text(
//                             module.title ?? 'No title available',
//                             style: const TextStyle(
//                               fontSize: 18,
//                               fontWeight: FontWeight.bold,
//                             ),
//                           ),
//                           const SizedBox(height: 8),
//                           Text(
//                             module.content ?? 'No content available',
//                             style: const TextStyle(
//                               fontSize: 14,
//                               color: Colors.grey,
//                             ),
//                           ),
//                         ],
//                       ),
//                     ),
//                   ),
//                 );
//               },
//             );
//           }
//         },
//       ),
//     );
//   }
// }

