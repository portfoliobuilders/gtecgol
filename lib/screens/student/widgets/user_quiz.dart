import 'package:flutter/material.dart';
import 'package:gtec/models/student_model.dart';
import 'package:gtec/provider/student_provider.dart';
import 'package:provider/provider.dart';

class QuizDetailScreen extends StatefulWidget {
  final StudentQuizmodel quiz;

  const QuizDetailScreen({super.key, required this.quiz});

  @override
  State<QuizDetailScreen> createState() => _QuizDetailScreenState();
}

class _QuizDetailScreenState extends State<QuizDetailScreen> {
  final Map<int, int> selectedAnswers = {};
  final Map<int, bool> submittingQuestions = {};
  final Map<int, bool> answeredQuestions = {};

  Future<void> submitSingleAnswer(
    BuildContext context,
    int questionId,
    int answerId,
  ) async {
    setState(() {
      submittingQuestions[questionId] = true;
    });

    try {
      final quizProvider = Provider.of<StudentAuthProvider>(context, listen: false);
      await quizProvider.submitQuizProvider(
        answerId,
        widget.quiz.quizId,
        questionId,
      );

      if (mounted) {
        setState(() {
          answeredQuestions[questionId] = true;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Answer submitted successfully!'),
            backgroundColor: Colors.green,
            duration: Duration(seconds: 1),
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          selectedAnswers.remove(questionId);
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to submit answer: ${e.toString()}'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          submittingQuestions[questionId] = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(16.0),
          children: [
            // Breadcrumb
            Row(
              children: [
                Text(
                  'Home',
                  style: TextStyle(color: Colors.blue[600]),
                ),
                const Icon(Icons.chevron_right, size: 20),
                Text(
                  'Quiz List',
                  style: TextStyle(color: Colors.blue[600]),
                ),
                const Icon(Icons.chevron_right, size: 20),
                Expanded(
                  child: Text(
                    widget.quiz.name,
                    style: const TextStyle(color: Colors.grey),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),

            // Quiz Title
            Text(
              widget.quiz.name,
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Color(0xFF464F60),
              ),
            ),
            const SizedBox(height: 32),

            ...widget.quiz.questions.map((question) {
              bool isSubmitting = submittingQuestions[question.questionId] == true;
              bool isAnswered = answeredQuestions[question.questionId] == true;

              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '${question.questionId}. ${question.text}',
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                      color: Color(0xFF464F60),
                    ),
                  ),
                  const SizedBox(height: 16),
                  
                  ...question.answers.asMap().entries.map((entry) {
                    int index = entry.key;
                    var answer = entry.value;
                    bool isSelected = selectedAnswers[question.questionId] == answer.answerId;
                    String optionLetter = String.fromCharCode(65 + index); // Convert 0->A, 1->B, etc.

                    return Padding(
                      padding: const EdgeInsets.only(bottom: 12.0),
                      child: InkWell(
                        onTap: isSubmitting || isAnswered
                            ? null
                            : () {
                                setState(() {
                                  selectedAnswers[question.questionId] = answer.answerId;
                                });
                              },
                        child: Container(
                          decoration: BoxDecoration(
                            border: Border.all(
                              color: isSelected ? Colors.blue.shade200 : Colors.grey.shade200,
                            ),
                            borderRadius: BorderRadius.circular(8),
                            color: isSelected ? Colors.blue.shade50 : Colors.white,
                          ),
                          child: Row(
                            children: [
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 16,
                                  vertical: 12,
                                ),
                                decoration: BoxDecoration(
                                  color: Colors.blue.shade100,
                                  borderRadius: const BorderRadius.only(
                                    topLeft: Radius.circular(8),
                                    bottomLeft: Radius.circular(8),
                                  ),
                                ),
                                child: Text(
                                  optionLetter,
                                  style: const TextStyle(
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ),
                              Expanded(
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 16,
                                    vertical: 12,
                                  ),
                                  child: Text(answer.text),
                                ),
                              ),
                              if (isSelected)
                                Padding(
                                  padding: const EdgeInsets.only(right: 16),
                                  child: Icon(
                                    Icons.check_circle,
                                    color: Colors.green[600],
                                  ),
                                ),
                            ],
                          ),
                        ),
                      ),
                    );
                  }),

                  const SizedBox(height: 16),
                  if (!isAnswered)
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: selectedAnswers[question.questionId] == null || isSubmitting
                            ? null
                            : () => submitSingleAnswer(
                                  context,
                                  question.questionId,
                                  selectedAnswers[question.questionId]!,
                                ),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.blue[600],
                          padding: const EdgeInsets.symmetric(
                            horizontal: 24,
                            vertical: 12,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        child: isSubmitting
                            ? const SizedBox(
                                width: 20,
                                height: 20,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  color: Colors.white,
                                ),
                              )
                            : const Text(
                                'Submit Answer',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                      ),
                    ),
                  const SizedBox(height: 32),
                ],
              );
            }),
          ],
        ),
      ),
    );
  }
}