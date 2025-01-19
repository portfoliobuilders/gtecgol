import 'package:flutter/material.dart';
import 'package:gtec/provider/authprovider.dart';
import 'package:gtec/screens/admin/batch_management/admin_batch_add.dart';
import 'package:provider/provider.dart';

class AdminAddStudent extends StatefulWidget {
  const AdminAddStudent({super.key});

  @override
  State<AdminAddStudent> createState() => _AdminAddStudentState();
}

class _AdminAddStudentState extends State<AdminAddStudent> {
  void _showAddCourseDialog(
    BuildContext context, {
    String? initialName,
    String? initialDescription,
    int? courseId,
  }) {
    final TextEditingController nameController =
        TextEditingController(text: initialName);
    final TextEditingController descriptionController =
        TextEditingController(text: initialDescription);

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(courseId == null ? 'Add Course' : 'Edit Course'),
          content: SingleChildScrollView(
            child: Column(
              children: [
                TextField(
                  controller: nameController,
                  decoration: const InputDecoration(labelText: 'Course Name'),
                ),
                TextField(
                  controller: descriptionController,
                  decoration: const InputDecoration(labelText: 'Description'),
                  maxLines: 3,
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () async {
                String courseName = nameController.text.trim();
                String courseDescription = descriptionController.text.trim();

                if (courseName.isNotEmpty && courseDescription.isNotEmpty) {
                  try {
                    final provider =
                        Provider.of<AdminAuthProvider>(context, listen: false);

                    if (courseId == null) {
                      await provider.AdmincreateCourseprovider(
                          courseName, courseDescription);
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                            content: Text('Course added successfully!')),
                      );
                    } else {
                      await provider.AdminupdateCourse(
                          courseId, courseName, courseDescription);
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                            content: Text('Course updated successfully!')),
                      );
                    }

                    await provider.AdminfetchCoursesprovider();
                    Navigator.of(context).pop();
                  } catch (error) {
                    Navigator.of(context).pop();
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Failed to save course: $error')),
                    );
                  }
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Please fill in all fields!')),
                  );
                }
              },
              child: const Text('Save'),
            ),
          ],
        );
      },
    );
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
                            'Courses',
                            style: Theme.of(context).textTheme.headlineSmall,
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
                      ElevatedButton(
                        onPressed: () => _showAddCourseDialog(context),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.blue,
                          padding: const EdgeInsets.symmetric(
                              vertical: 10, horizontal: 20),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8)),
                        ),
                        child: const Text('Create Course',
                            style: TextStyle(color: Colors.white)),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  Wrap(
                    spacing: 16,
                    runSpacing: 16,
                    children: courseProvider.course.map((course) {
                      return GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => AdminCreateBatchScreen(
                                courseId: course.courseId,
                              ),
                            ),
                          );
                        },
                        child: SizedBox(
                          width: 200,
                          child: Card(
                            elevation: 6,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(15)),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                ClipRRect(
                                  borderRadius: const BorderRadius.only(
                                    topLeft: Radius.circular(15),
                                    topRight: Radius.circular(15),
                                  ),
                                  child: Image.asset(
                                    'assets/golblack.png',
                                    width: double.infinity,
                                    height: 100,
                                    fit: BoxFit.cover,
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(10.0),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        course.name,
                                        style: const TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      const SizedBox(height: 4),
                                      Text(
                                        course.description,
                                        style: const TextStyle(
                                          fontSize: 12,
                                          color: Colors.grey,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
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
