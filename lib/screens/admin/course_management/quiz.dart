// import 'package:flutter/material.dart';
// import 'package:lms/models/admin_model.dart';
// import 'package:lms/provider/authprovider.dart';
// import 'package:provider/provider.dart';

// class QuizCreatorScreen extends StatefulWidget {
//   final int courseId;
//   final int moduleId;
//   final int batchId;

//   const QuizCreatorScreen({
//     Key? key,
//     required this.courseId,
//     required this.moduleId,
//     required this.batchId,
//   }) : super(key: key);

//   @override
//   _QuizCreatorScreenState createState() => _QuizCreatorScreenState();
// }

// class _QuizCreatorScreenState extends State<QuizCreatorScreen> {
//   final _formKey = GlobalKey<FormState>();
//   bool _isLoading = false;
//   bool _isCreating = true; // Toggle between create and display mode
//   final TextEditingController _nameController = TextEditingController();
//   final TextEditingController _descriptionController = TextEditingController();
//   List<Map<String, dynamic>> questions = [];
//   List<Quizmodel> quizzes = [];

//   @override
//   void initState() {
//     super.initState();
//     _loadQuizzes();
//   }

//   Future<void> _loadQuizzes() async {
//     setState(() => _isLoading = true);
//     try {
//       final fetchedQuizzes = await Provider.of<AdminAuthProvider>(context, listen: false)
//           .fetchQuizzes(courseId: widget.courseId, moduleId: widget.moduleId);
//       setState(() {
//         quizzes = fetchedQuizzes;
//       });
//     } catch (e) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(content: Text('Error loading quizzes: $e')),
//       );
//     } finally {
//       setState(() => _isLoading = false);
//     }
//   }

//   @override
//   void dispose() {
//     _nameController.dispose();
//     _descriptionController.dispose();
//     super.dispose();
//   }

//   void _addNewQuestion() {
//     setState(() {
//       questions.add({
//         "text": "",
//         "answers": [
//           {"text": "", "isCorrect": false},
//           {"text": "", "isCorrect": false},
//           {"text": "", "isCorrect": false},
//           {"text": "", "isCorrect": false},
//         ]
//       });
//     });
//   }

//   void _updateQuestionText(int questionIndex, String text) {
//     setState(() {
//       questions[questionIndex]["text"] = text;
//     });
//   }

//   void _updateAnswerText(int questionIndex, int answerIndex, String text) {
//     setState(() {
//       questions[questionIndex]["answers"][answerIndex]["text"] = text;
//     });
//   }

//   void _updateCorrectAnswer(int questionIndex, int answerIndex, bool value) {
//     setState(() {
//       for (var answer in questions[questionIndex]["answers"]) {
//         answer["isCorrect"] = false;
//       }
//       questions[questionIndex]["answers"][answerIndex]["isCorrect"] = value;
//     });
//   }

//   bool _validateQuestions() {
//     if (questions.isEmpty) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         const SnackBar(content: Text('Please add at least one question')),
//       );
//       return false;
//     }

//     for (var question in questions) {
//       if (question["text"].toString().trim().isEmpty) {
//         ScaffoldMessenger.of(context).showSnackBar(
//           const SnackBar(content: Text('All questions must have text')),
//         );
//         return false;
//       }

//       bool hasCorrectAnswer = false;
//       for (var answer in question["answers"]) {
//         if (answer["text"].toString().trim().isEmpty) {
//           ScaffoldMessenger.of(context).showSnackBar(
//             const SnackBar(content: Text('All answers must have text')),
//           );
//           return false;
//         }
//         if (answer["isCorrect"]) {
//           hasCorrectAnswer = true;
//         }
//       }

//       if (!hasCorrectAnswer) {
//         ScaffoldMessenger.of(context).showSnackBar(
//           const SnackBar(content: Text('Each question must have one correct answer')),
//         );
//         return false;
//       }
//     }

//     return true;
//   }

//   Future<void> _saveQuiz() async {
//     if (!_formKey.currentState!.validate() || !_validateQuestions()) {
//       return;
//     }

//     setState(() => _isLoading = true);

//     try {
//       await Provider.of<AdminAuthProvider>(context, listen: false)
//           .createQuizProvider(
//         batchId: widget.batchId,
//         courseId: widget.courseId,
//         moduleId: widget.moduleId,
//         name: _nameController.text,
//         description: _descriptionController.text,
//         questions: questions,
//       );

//       ScaffoldMessenger.of(context).showSnackBar(
//         const SnackBar(content: Text('Quiz created successfully!')),
//       );
      
//       // Reset form and reload quizzes
//       setState(() {
//         _nameController.clear();
//         _descriptionController.clear();
//         questions.clear();
//         _isCreating = false;
//       });
//       await _loadQuizzes();
//     } catch (e) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(content: Text('Error creating quiz: $e')),
//       );
//     } finally {
//       setState(() => _isLoading = false);
//     }
//   }

//   Widget _buildCreatorView() {
//     return Form(
//       key: _formKey,
//       child: SingleChildScrollView(
//         padding: const EdgeInsets.all(16.0),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             TextFormField(
//               controller: _nameController,
//               decoration: const InputDecoration(
//                 labelText: 'Quiz Name',
//                 border: OutlineInputBorder(),
//               ),
//               validator: (value) {
//                 if (value == null || value.trim().isEmpty) {
//                   return 'Please enter a quiz name';
//                 }
//                 return null;
//               },
//             ),
//             const SizedBox(height: 16),
//             TextFormField(
//               controller: _descriptionController,
//               decoration: const InputDecoration(
//                 labelText: 'Quiz Description',
//                 border: OutlineInputBorder(),
//               ),
//               maxLines: 3,
//               validator: (value) {
//                 if (value == null || value.trim().isEmpty) {
//                   return 'Please enter a quiz description';
//                 }
//                 return null;
//               },
//             ),
//             const SizedBox(height: 24),
//             Row(
//               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//               children: [
//                 const Text(
//                   'Questions',
//                   style: TextStyle(
//                     fontSize: 20,
//                     fontWeight: FontWeight.bold,
//                   ),
//                 ),
//                 ElevatedButton.icon(
//                   onPressed: _addNewQuestion,
//                   icon: const Icon(Icons.add),
//                   label: const Text('Add Question'),
//                 ),
//               ],
//             ),
//             const SizedBox(height: 16),
//             ...List.generate(
//               questions.length,
//               (questionIndex) => QuestionCard(
//                 questionIndex: questionIndex,
//                 questionData: questions[questionIndex],
//                 onQuestionTextChanged: (text) =>
//                     _updateQuestionText(questionIndex, text),
//                 onAnswerTextChanged: (answerIndex, text) =>
//                     _updateAnswerText(questionIndex, answerIndex, text),
//                 onCorrectAnswerChanged: (answerIndex, value) =>
//                     _updateCorrectAnswer(questionIndex, answerIndex, value),
//                 onDelete: () {
//                   setState(() {
//                     questions.removeAt(questionIndex);
//                   });
//                 },
//               ),
//             ),
//             const SizedBox(height: 24),
//             SizedBox(
//               width: double.infinity,
//               child: ElevatedButton(
//                 onPressed: _isLoading ? null : _saveQuiz,
//                 style: ElevatedButton.styleFrom(
//                   padding: const EdgeInsets.symmetric(vertical: 16),
//                 ),
//                 child: const Text('Save Quiz'),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   Widget _buildDisplayView() {
//     if (quizzes.isEmpty) {
//       return const Center(child: Text('No quizzes available'));
//     }

//     return ListView.builder(
//       padding: const EdgeInsets.all(16.0),
//       itemCount: quizzes.length,
//       itemBuilder: (context, index) {
//         final quiz = quizzes[index];
//         return Card(
//           margin: const EdgeInsets.only(bottom: 16),
//           child: ExpansionTile(
//             title: Text(quiz.name),
//             subtitle: Text(quiz.description),
//             children: [
//               Padding(
//                 padding: const EdgeInsets.all(16.0),
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: quiz.questions.map((question) {
//                     return Column(
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: [
//                         Text(
//                           question.text,
//                           style: const TextStyle(
//                             fontSize: 16,
//                             fontWeight: FontWeight.bold,
//                           ),
//                         ),
//                         const SizedBox(height: 8),
//                         ...question.answers.map((answer) => ListTile(
//                           leading: Icon(
//                             answer.isCorrect
//                                 ? Icons.check_circle
//                                 : Icons.radio_button_unchecked,
//                             color: answer.isCorrect ? Colors.green : null,
//                           ),
//                           title: Text(answer.text),
//                         )),
//                         const Divider(),
//                       ],
//                     );
//                   }).toList(),
//                 ),
//               ),
//             ],
//           ),
//         );
//       },
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text(_isCreating ? 'Create Quiz' : 'View Quizzes'),
//         actions: [
//           IconButton(
//             icon: Icon(_isCreating ? Icons.view_list : Icons.add),
//             onPressed: () {
//               setState(() {
//                 _isCreating = !_isCreating;
//                 if (_isCreating) {
//                   _nameController.clear();
//                   _descriptionController.clear();
//                   questions.clear();
//                 }
//               });
//             },
//           ),
//         ],
//       ),
//       body: _isLoading
//           ? const Center(child: CircularProgressIndicator())
//           : _isCreating
//               ? _buildCreatorView()
//               : _buildDisplayView(),
//     );
//   }
// }


// class QuestionCard extends StatelessWidget {
//   final int questionIndex;
//   final Map<String, dynamic> questionData;
//   final Function(String) onQuestionTextChanged;
//   final Function(int, String) onAnswerTextChanged;
//   final Function(int, bool) onCorrectAnswerChanged;
//   final VoidCallback onDelete;

//   const QuestionCard({
//     Key? key,
//     required this.questionIndex,
//     required this.questionData,
//     required this.onQuestionTextChanged,
//     required this.onAnswerTextChanged,
//     required this.onCorrectAnswerChanged,
//     required this.onDelete,
//   }) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return Card(
//       margin: const EdgeInsets.only(bottom: 16),
//       child: Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Row(
//               children: [
//                 Expanded(
//                   child: Text(
//                     'Question ${questionIndex + 1}',
//                     style: const TextStyle(
//                       fontSize: 18,
//                       fontWeight: FontWeight.bold,
//                     ),
//                   ),
//                 ),
//                 IconButton(
//                   icon: const Icon(Icons.delete),
//                   onPressed: onDelete,
//                   color: Colors.red,
//                 ),
//               ],
//             ),
//             const SizedBox(height: 8),
//             TextFormField(
//               initialValue: questionData["text"],
//               decoration: const InputDecoration(
//                 labelText: 'Question Text',
//                 border: OutlineInputBorder(),
//               ),
//               onChanged: onQuestionTextChanged,
//             ),
//             const SizedBox(height: 16),
//             const Text(
//               'Answers',
//               style: TextStyle(
//                 fontSize: 16,
//                 fontWeight: FontWeight.bold,
//               ),
//             ),
//             const SizedBox(height: 8),
//             ...List.generate(
//               questionData["answers"].length,
//               (answerIndex) => Padding(
//                 padding: const EdgeInsets.only(bottom: 8),
//                 child: Row(
//                   children: [
//                     Expanded(
//                       child: TextFormField(
//                         initialValue: questionData["answers"][answerIndex]["text"],
//                         decoration: InputDecoration(
//                           labelText: 'Answer ${answerIndex + 1}',
//                           border: const OutlineInputBorder(),
//                         ),
//                         onChanged: (text) =>
//                             onAnswerTextChanged(answerIndex, text),
//                       ),
//                     ),
//                     Checkbox(
//                       value: questionData["answers"][answerIndex]["isCorrect"],
//                       onChanged: (value) =>
//                           onCorrectAnswerChanged(answerIndex, value ?? false),
//                     ),
//                     const Text('Correct'),
//                   ],
//                 ),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }