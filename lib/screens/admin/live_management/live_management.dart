import 'package:flutter/material.dart';
import 'package:gtec/provider/authprovider.dart';
import 'package:gtec/screens/admin/live_management/admin_livebatch.dart';
import 'package:provider/provider.dart';

class Adminlivemanagement extends StatefulWidget {
  const Adminlivemanagement({super.key});

  @override
  State<Adminlivemanagement> createState() => _AdminlivemanagementState();
}

class _AdminlivemanagementState extends State<Adminlivemanagement> {
  int? selectedCourseId;

  void _showAddCourseDialog(
    BuildContext context, {
    String? initialName,
    String? initialDescription,
  }) {
    final TextEditingController nameController =
        TextEditingController(text: initialName);
    final TextEditingController descriptionController =
        TextEditingController(text: initialDescription);

    final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  }

  @override
  Widget build(BuildContext context) {
    final courseProvider = Provider.of<AdminAuthProvider>(context);

    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: LayoutBuilder(
          builder: (context, constraints) {
            return SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'COURSES',
                            style: TextStyle(
                              fontSize: 32,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            'Manage your courses here.',
                            style: Theme.of(context)
                                .textTheme
                                .titleMedium
                                ?.copyWith(color: Colors.grey),
                          ),
                        ],
                      ),
                    ],
                  ),
                  SizedBox(height: 20),
                  Divider(),
                  const SizedBox(height: 20),
                  Wrap(
                    spacing: 16,
                    runSpacing: 16,
                    children: courseProvider.course.map((course) {
                      return GestureDetector(
                        onTap: () {
                          // Navigate to the ModuleAddScreen with the selected courseId
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => AdminliveBatchScreen(
                                courseId: course.courseId,
                              ),
                            ),
                          );
                        },
                        child: SizedBox(
                          width: 225,
                          height: 225,
                          child: Card(
                            elevation: 1,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                SizedBox(
                                  height: 150,
                                  child: ClipRRect(
                                    borderRadius: const BorderRadius.only(
                                      topLeft: Radius.circular(8),
                                      topRight: Radius.circular(8),
                                    ),
                                    child: Image.asset(
                                      'assets/image.jpg', // Placeholder image
                                      width: double.infinity,
                                      height: double.infinity,
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                ),
                                Container(
                                  height: 65,
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 8.0),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        course.name,
                                        style: const TextStyle(
                                          fontSize: 14,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      Spacer(),
                                      // Removed the Row with IconButtons for edit and delete
                                    ],
                                  ),
                                )
                              ],
                            ),
                          ),
                        ),
                      );
                    }).toList(),
                  )
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
