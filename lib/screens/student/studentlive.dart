// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';
// import 'package:gtec/provider/student_provider.dart';
// import 'package:gtec/models/student_model.dart';

// class LiveSessionsPage extends StatelessWidget {
//   final int courseId;
//   final int batchId;
//   final String courseName;

//   const LiveSessionsPage({
//     super.key,
//     required this.courseId,
//     required this.batchId,
//     required this.courseName,
//   });

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Live Sessions - $courseName'),
//         backgroundColor: Colors.white,
//         foregroundColor: Colors.black,
//         elevation: 1,
//       ),
//       body: Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: FutureBuilder<List<StudentLiveModel>>(
//           future: Provider.of<StudentAuthProvider>(context, listen: false)
//               .fetchuserliveprovider(),
//           builder: (context, snapshot) {
//             if (snapshot.connectionState == ConnectionState.waiting) {
//               return const Center(child: CircularProgressIndicator());
//             } else if (snapshot.hasError) {
//               return Center(
//                 child: Column(
//                   mainAxisAlignment: MainAxisAlignment.center,
//                   children: [
//                     const Icon(Icons.error_outline, size: 48, color: Colors.red),
//                     const SizedBox(height: 16),
//                     Text('Error: ${snapshot.error}'),
//                   ],
//                 ),
//               );
//             } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
//               return Center(
//                 child: Column(
//                   mainAxisAlignment: MainAxisAlignment.center,
//                   children: const [
//                     Icon(Icons.event_busy, size: 48, color: Colors.grey),
//                     SizedBox(height: 16),
//                     Text(
//                       'No live sessions available',
//                       style: TextStyle(fontSize: 18, color: Colors.grey),
//                     ),
//                   ],
//                 ),
//               );
//             }

//             return ListView.builder(
//               itemCount: snapshot.data!.length,
//               itemBuilder: (context, index) {
//                 final session = snapshot.data![index];
//                 return Card(
//                   margin: const EdgeInsets.only(bottom: 16),
//                   elevation: 2,
//                   shape: RoundedRectangleBorder(
//                     borderRadius: BorderRadius.circular(12),
//                   ),
//                   child: Padding(
//                     padding: const EdgeInsets.all(16),
//                     child: Column(
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: [
//                         Row(
//                           children: [
//                             Container(
//                               padding: const EdgeInsets.symmetric(
//                                 horizontal: 12,
//                                 vertical: 6,
//                               ),
//                               decoration: BoxDecoration(
//                                 color: const Color(0xFFFFE8EE),
//                                 borderRadius: BorderRadius.circular(20),
//                               ),
//                               child: Row(
//                                 mainAxisSize: MainAxisSize.min,
//                                 children: const [
//                                   Icon(
//                                     Icons.live_tv,
//                                     color: Color(0xFFFF4081),
//                                     size: 18,
//                                   ),
//                                   SizedBox(width: 6),
//                                   Text(
//                                     'LIVE',
//                                     style: TextStyle(
//                                       color: Color(0xFFFF4081),
//                                       fontWeight: FontWeight.bold,
//                                     ),
//                                   ),
//                                 ],
//                               ),
//                             ),
//                           ],
//                         ),
//                         const SizedBox(height: 16),
//                         Text(
//                           session.message,
//                           style: const TextStyle(
//                             fontSize: 18,
//                             fontWeight: FontWeight.bold,
//                           ),
//                         ),
//                         const SizedBox(height: 8),
                 
//                         const SizedBox(height: 16),
//                         ElevatedButton.icon(
//                           onPressed: () {
//                             // Handle joining the meeting
//                             // You can add your meeting join logic here
//                           },
//                           icon: const Icon(Icons.video_call),
//                           label: const Text('Join Meeting'),
//                           style: ElevatedButton.styleFrom(
//                             backgroundColor: const Color(0xFF0098DA),
//                             padding: const EdgeInsets.symmetric(
//                               horizontal: 24,
//                               vertical: 12,
//                             ),
//                             shape: RoundedRectangleBorder(
//                               borderRadius: BorderRadius.circular(8),
//                             ),
//                           ),
//                         ),
//                       ],
//                     ),
//                   ),
//                 );
//               },
//             );
//           },
//         ),
//       ),
//     );
//   }
// }