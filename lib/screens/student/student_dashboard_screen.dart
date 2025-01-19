import 'package:flutter/material.dart';
import 'package:gtec/models/student_model.dart';
import 'package:gtec/provider/student_provider.dart';
import 'package:gtec/screens/student/studentlogin.dart';
import 'package:gtec/screens/student/widgets/assignmentscreen.dart';
import 'package:gtec/screens/student/widgets/studentprofile.dart';
import 'package:gtec/screens/student/widgets/user_quiz.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

class StudentLMSHomePage extends StatelessWidget {
  const StudentLMSHomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 1,
        title: Row(
          children: [
            Container(
              height: 35,
              width: 75,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(4),
                image: DecorationImage(
                  image: AssetImage('assets/golblack.png'), // Replace with your asset path
                  fit: BoxFit.cover,
                ),
              ),
            ),
            const SizedBox(width: 8), // Spacing between images
            Container(
              height: 35,
              width: 35,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(4),
                image: DecorationImage(
                  image: AssetImage('assets/gtecwhite.png'), // Replace with your asset path
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications_outlined, color: Color(0xFF0098DA), size: 28),
            onPressed: () {},
          ),
          const SizedBox(width: 8),
          Container(
            margin: const EdgeInsets.only(right: 16),
            child: CircleAvatar(
              backgroundColor: const Color.fromARGB(255, 66, 142, 228), // Updated to a blue theme
              radius: 22, // Slightly larger for better appearance
              child: PopupMenuButton<String>(
                icon: const Icon(Icons.person_outline, color: Colors.white, size: 24),
                color: const Color(0xFFE3F2FD), // Light blue background for the dropdown
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12), // Rounded edges for the dropdown
                ),
                onSelected: (String value) async {
                  if (value == 'Profile') {
                    // Navigator.push(
                    //   context,
                    //   MaterialPageRoute(
                    //     builder: (context) => StudentProfileScreen(),
                    //   ),
                    // );
                  } else if (value == 'Logout') {
                    // Logout logic
                    await Provider.of<StudentAuthProvider>(context, listen: false).logout();
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(builder: (context) => UserLoginScreen()),
                    );
                  }
                },
                itemBuilder: (BuildContext context) => [
                  PopupMenuItem<String>(
                    value: 'Profile',
                    child: Row(
                      children: [
                        Icon(Icons.person, color: const Color.fromARGB(255, 75, 132, 198)), // Blue icon
                        const SizedBox(width: 10),
                        const Text(
                          'Profile',
                          style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                        ),
                      ],
                    ),
                  ),
                  PopupMenuItem<String>(
                    value: 'Logout',
                    child: Row(
                      children: [
                        Icon(Icons.logout_rounded, color: const Color.fromARGB(255, 71, 132, 203)), // Blue icon
                        const SizedBox(width: 10),
                        const Text(
                          'Logout',
                          style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
      body: const SplitView(),
    );
  }
}

class SplitView extends StatefulWidget {
  const SplitView({super.key});

  @override
  State<SplitView> createState() => _SplitViewState();
}

class _SplitViewState extends State<SplitView> {
  StudentModel? selectedCourse;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    final isMobile = MediaQuery.of(context).size.width < 768;

    Widget buildCoursesList() {
      return Container(
        width: isMobile ? double.infinity : 300,
        child: Card(
          margin: const EdgeInsets.all(8),
          elevation: 2,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          child: CoursesList(
            onCourseSelected: (course) {
              setState(() {
                selectedCourse = course;
              });
              if (isMobile) {
                Navigator.pop(context); // Close the drawer after selection
              }
            },
            selectedCourse: selectedCourse,
          ),
        ),
      );
    }

    Widget buildMainContent() {
      return Expanded(
        child: Column(
          children: [
            if (selectedCourse != null)
              Card(
                margin: const EdgeInsets.all(8),
                elevation: 2,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                child: LiveSessionsList(course: selectedCourse!),
              ),
            Expanded(
              child: Card(
                margin: const EdgeInsets.all(8),
                elevation: 2,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                child: selectedCourse == null
                    ? Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.school_outlined,
                              size: 48,
                              color: Colors.grey[400],
                            ),
                            const SizedBox(height: 16),
                            Text(
                              'Select a course to view modules',
                              style: TextStyle(
                                fontSize: 16,
                                color: Colors.grey[600],
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                      )
                    : ModulesList(course: selectedCourse!),
              ),
            ),
          ],
        ),
      );
    }

    if (isMobile) {
      return Scaffold(
        key: _scaffoldKey,
        appBar: AppBar(
          leading: IconButton(
            icon: const Icon(Icons.menu),
            onPressed: () => _scaffoldKey.currentState?.openDrawer(),
          ),
          title: Text(
            selectedCourse?.courseName ?? 'Select a Course',
            style: const TextStyle(
              fontWeight: FontWeight.bold,
            ),
          ),
          elevation: 0,
          backgroundColor: Colors.white,
          foregroundColor: Colors.black87,
          actions: [
            if (selectedCourse != null)
              IconButton(
                icon: const Icon(Icons.refresh),
                onPressed: () {
                  // Add refresh functionality
                },
              ),
          ],
        ),
        drawer: Drawer(
          child: SafeArea(
            child: Column(
              children: [
                Container(
                  padding: const EdgeInsets.all(16),
                  color: Colors.blue[50],
                  child: const Column(
                    children: [
                      Icon(
                        Icons.school,
                        size: 48,
                        color: Colors.blue,
                      ),
                      SizedBox(height: 12),
                      Text(
                        'Your Courses',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: buildCoursesList(),
                ),
              ],
            ),
          ),
        ),
        body: Row(
          children: [
            Expanded(
              child: selectedCourse == null
                  ? Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.school_outlined,
                            size: 48,
                            color: Colors.grey[400],
                          ),
                          const SizedBox(height: 16),
                          Text(
                            'Select a course from the menu',
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.grey[600],
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    )
                  : Column(
                      children: [
                        if (selectedCourse != null)
                          Card(
                            margin: const EdgeInsets.all(8),
                            elevation: 2,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: LiveSessionsList(course: selectedCourse!),
                          ),
                        Expanded(
                          child: Card(
                            margin: const EdgeInsets.all(8),
                            elevation: 2,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: ModulesList(course: selectedCourse!),
                          ),
                        ),
                      ],
                    ),
            ),
          ],
        ),
      );
    }

    // Desktop layout remains unchanged
    return Scaffold(
      body: Row(
        children: [
          buildCoursesList(),
          buildMainContent(),
        ],
      ),
    );
  }
}




class LiveSessionsList extends StatelessWidget {
  final StudentModel course;

  const LiveSessionsList({super.key, required this.course});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: Provider.of<StudentAuthProvider>(context, listen: false)
          .fetchliveForSelectedCourse(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Container(
            height: 200,
            padding: const EdgeInsets.all(20),
            child: const Center(
              child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(Colors.blue),
              ),
            ),
          );
        }

        return Consumer<StudentAuthProvider>(
          builder: (context, provider, child) {
            final liveSessions = provider.live;

            if (liveSessions.isEmpty) {
              return Container(
              
                height: 100,
                padding: const EdgeInsets.all(20),
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.event_busy, 
                        size: 48, 
                        color: Colors.grey[400]
                      ),
                      const SizedBox(height: 16),
                      Text(
                        'No live sessions scheduled',
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.grey[600],
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }

            return Container(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 12,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.red.shade50,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: Colors.red.shade100,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: const Icon(
                            Icons.live_tv,
                            color: Colors.blue,
                            size: 20,
                          ),
                        ),
                        const SizedBox(width: 12),
                        const Text(
                          'Live Sessions',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.blue,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),
                  SizedBox(
                    height: 180,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: liveSessions.length,
                      itemBuilder: (context, index) {
                        final live = liveSessions[index];
                        return Container(
                          width: 300,
                          margin: const EdgeInsets.only(right: 16),
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: [
                                Colors.red.shade50,
                                Colors.white,
                              ],
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                            ),
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(
                              color: Colors.blue.shade100,
                              width: 1,
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.blue.shade100.withOpacity(0.3),
                                blurRadius: 10,
                                offset: const Offset(0, 4),
                              ),
                            ],
                          ),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(16),
                            child: Container(
                              padding: const EdgeInsets.all(20),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      Container(
                                        width: 8,
                                        height: 8,
                                        decoration: BoxDecoration(
                                          color: Colors.blue,
                                          shape: BoxShape.circle,
                                          boxShadow: [
                                            BoxShadow(
                                              color: Colors.blue.withOpacity(0.3),
                                              blurRadius: 4,
                                              spreadRadius: 2,
                                            ),
                                          ],
                                        ),
                                      ),
                                      const SizedBox(width: 8),
                                      Expanded(
                                        child: Text(
                                          live.message,
                                          style: const TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 16,
                                          ),
                                          maxLines: 2,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 16),
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 12,
                                      vertical: 6,
                                    ),
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(20),
                                      border: Border.all(
                                        color: Colors.blue.shade200,
                                      ),
                                    ),
                                    child: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Icon(
                                          Icons.access_time,
                                          size: 16,
                                          color: Colors.blue.shade400,
                                        ),
                                        const SizedBox(width: 6),
                                        Text(
                                          live.liveStartTime.toString(),
                                          style: TextStyle(
                                            color: Colors.blue.shade400,
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  const Spacer(),
                                  SizedBox(
                                    width: double.infinity,
                                    child: ElevatedButton.icon(
                                      onPressed: () {
                                        if (live.liveLink.isNotEmpty) {
                                          launchUrl(Uri.parse(live.liveLink));
                                        } else {
                                          ScaffoldMessenger.of(context).showSnackBar(
                                            const SnackBar(
                                              content: Text('No live link available'),
                                              backgroundColor: Colors.blue,
                                            ),
                                          );
                                        }
                                      },
                                      icon: const Icon(Icons.play_circle_outline),
                                      label: const Text('Join Live Session'),
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: Colors.blue,
                                        foregroundColor: Colors.white,
                                        elevation: 0,
                                        padding: const EdgeInsets.symmetric(
                                          vertical: 12,
                                        ),
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(12),
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }
}

class CoursesList extends StatelessWidget {
  final Function(StudentModel) onCourseSelected;
  final StudentModel? selectedCourse;

  const CoursesList({
    super.key,
    required this.onCourseSelected,
    required this.selectedCourse,
  });

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: Provider.of<StudentAuthProvider>(context, listen: false)
          .studentLoadCourses(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        }

        return Consumer<StudentAuthProvider>(
          builder: (context, provider, child) {
            if (provider.studentCourses.isEmpty) {
              return const Center(child: Text('No courses available.'));
            }
            return ListView.builder(
              itemCount: provider.studentCourses.length,
              itemBuilder: (context, index) {
                final course = provider.studentCourses[index];
                final isSelected = selectedCourse?.courseId == course.courseId;

                return GestureDetector(
                  onTap: () {
                    // Clear previous module data when selecting a new course
                    provider.clearModuleData();
                    provider.setSelectedCourseId(course.courseId, course.batchId);
                    onCourseSelected(course);
                  },
                  child: Container(
                    margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: isSelected ? Colors.blue.shade50 : Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: isSelected ? Colors.blue : Colors.grey.shade300,
                        width: isSelected ? 2 : 1,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.05),
                          blurRadius: 4,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          course.courseName,
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                            color: isSelected ? Colors.blue : Colors.black,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          course.courseDescription,
                          style: const TextStyle(
                            fontSize: 14,
                            color: Colors.grey,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            );
          },
        );
      },
    );
  }
}

class ModulesList extends StatelessWidget {
  final StudentModel course;

  const ModulesList({super.key, required this.course});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: Provider.of<StudentAuthProvider>(context, listen: false)
          .fetchModulesForSelectedCourse(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        }

        return Consumer<StudentAuthProvider>(
          builder: (context, provider, child) {
            if (provider.modules.isEmpty) {
              return const Center(child: Text('No modules available'));
            }
            return ListView.builder(
              itemCount: provider.modules.length,
              itemBuilder: (context, index) {
                final module = provider.modules[index];
                return ModuleExpansionTile(
                  module: module,
                  courseId: course.courseId,
                  batchId: course.batchId,
                );
              },
            );
          },
        );
      },
    );
  }
}

class ModuleExpansionTile extends StatefulWidget {
  final StudentModuleModel module;
  final int courseId;
  final int batchId;

  const ModuleExpansionTile({
    super.key,
    required this.module,
    required this.courseId,
    required this.batchId,
  });

  @override
  State<ModuleExpansionTile> createState() => _ModuleExpansionTileState();
}
class _ModuleExpansionTileState extends State<ModuleExpansionTile> {
  bool isExpanded = false;
  bool isLoading = false;
  List<StudentLessonModel> lessons = [];
  List<StudentAssignmentModel> assignments = [];
  List<StudentQuizmodel> quizzes = [];

  Future<void> loadModuleContent() async {
    if (isLoading) return;

    setState(() {
      isLoading = true;
    });

    try {
      final provider = Provider.of<StudentAuthProvider>(context, listen: false);
      provider.setSelectedModuleId(widget.module.moduleId);
      await provider.fetchLessonsAndAssignmentsquiz();
      await provider.fetchliveForSelectedCourse();

      if (mounted) {
        setState(() {
          lessons = provider.lessons;
          assignments = provider.assignments;
          quizzes = provider.quiz;
          isLoading = false;
        });
      }
    } catch (e) {
      print('Error loading module content: $e');
      if (mounted) {
        setState(() {
          isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFEEEEEE)),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.15),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Module Header Row
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // Progress Circle
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: Colors.blueAccent,
                    width: 3,
                  ),
                  gradient: LinearGradient(
                    colors: [Colors.blueAccent.withOpacity(0.3), const Color.fromARGB(255, 255, 255, 255).withOpacity(0.6)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                ),
                child: Center(
                  child: Text(
                    lessons.length.toString(),
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: Colors.blueAccent,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 16),
              // Title
              Expanded(
                child: Text(
                  widget.module.title ?? 'No title available',
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    color: Colors.black87,
                  ),
                ),
              ),
              IconButton(
                icon: Icon(
                  isExpanded
                      ? Icons.keyboard_arrow_up
                      : Icons.keyboard_arrow_down,
                  color: const Color(0xFF666666),
                ),
                onPressed: () {
                  setState(() {
                    isExpanded = !isExpanded;
                  });

                  if (isExpanded) {
                    loadModuleContent();
                  }
                },
              ),
            ],
          ),
          if (isExpanded) ...[
            const SizedBox(height: 16),
            const Divider(color: Color(0xFFEEEEEE)),
            isLoading
                ? const Center(child: CircularProgressIndicator())
                : Column(
                    children: [
                      ...lessons.map((lesson) => _buildExpandedContent(
                            title: lesson.title,
                            content: lesson.content,
                            icon: Icons.book_outlined,
                            buttonText: "View Lesson",
                            onPressed: () async {
                              final Uri url = Uri.parse(lesson.videoLink);
                              if (await canLaunchUrl(url)) {
                                await launchUrl(url, mode: LaunchMode.externalApplication);
                              } else {
                                throw 'Could not launch ${lesson.videoLink}';
                              }
                            },
                          )),
                      ...assignments.map((assignment) => _buildExpandedContent(
                            title: assignment.title,
                            content: assignment.description,
                            icon: Icons.assignment_outlined,
                            buttonText: "View Assignment",
                            onPressed: () {
                              // Navigate to AssignmentDetailsPage
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>
                                      AssignmentSubmissionPage(assignment: assignment),
                                ),
                              );
                            },
                          )),
                      ...quizzes.map((quiz) => _buildExpandedContent(
                            title: quiz.name,
                            content: quiz.description,
                            icon: Icons.quiz_outlined,
                            buttonText: "Start Quiz",
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>
                                      QuizDetailScreen(quiz: quiz),
                                ),
                              );
                            },
                          )),
                    ],
                  ),
          ],
        ],
      ),
    );
  }

  Widget _buildExpandedContent({
    required String title,
    required String content,
    required IconData icon,
    required String buttonText,
    required VoidCallback onPressed,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      margin: const EdgeInsets.only(top: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
        border: Border.all(color: const Color(0xFFE0E0E0)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            decoration: BoxDecoration(
              color: Colors.blueAccent.withOpacity(0.2),
              shape: BoxShape.circle,
            ),
            padding: const EdgeInsets.all(12),
            child: Icon(icon, color: Colors.blueAccent, size: 28),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    color: Colors.black87,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  content,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w400,
                    color: Colors.black54,
                  ),
                ),
              ],
            ),
          ),
          ElevatedButton(
            onPressed: onPressed,
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.blueAccent,
              foregroundColor: Colors.white,
              elevation: 0,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            child: Text(
              buttonText,
              style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
            ),
          ),
        ],
      ),
    );
  }
}
