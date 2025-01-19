import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:gtec/contants/gtec_token.dart';
import 'package:gtec/models/admin_model.dart';
import 'package:gtec/screens/admin/admin_dashboard.dart';
import 'package:gtec/screens/admin/login/admin_login.dart';
import 'package:gtec/services/webservice.dart';

class AdminAuthProvider with ChangeNotifier {
  String? _token;
  String? deleteMessage;
  bool isLoading = false;
  String? message;
  List<Admincoursemodel> _course = []; // Correctly store courses

  int? courseId;

  List<Admincoursemodel> get course => _course;

  String? get token => _token;

  final SuperAdminAPI _apiService = SuperAdminAPI();

  final Map<int, List<AdminModulemodel>> _courseModules = {};

  final Map<int, List<AdminLessonmodel>> _moduleLessons = {};

 final Map<int, AdminLiveModel> _liveBatch = {};

  AdminLiveModel? getLiveSessionForBatch(int batchId) {
    return _liveBatch[batchId];
  }
  List<AdminAllusersmodel> _users =
      []; // Add this line to define the _users variable

  List<AdminAllusersmodel>? get users => _users;

  final Map<int, List<AdminCourseBatch>> _courseBatches =
      {}; // Map for storing course batches

  bool _isLoading = false; // Loading state

  Map<int, List<AdminCourseBatch>> get courseBatches => _courseBatches;

  int? get batchId => null;

  get studentUsers => null;

  get getusers => null;
  List<AdminModulemodel> getModulesForCourse(courseId) {
    return _courseModules[courseId] ?? [];
  }

  List<AdminLessonmodel> getLessonsForModule(int moduleId) {
    return _moduleLessons[moduleId] ?? [];
  }




  // Superadmin login
  Future<void> adminloginprovider(
    String email,
    String password,
    BuildContext context,
  ) async {
    try {
      final response = await _apiService.loginAdminAPI(email, password);

      if (response.statusCode == 200) {
        final responseData = jsonDecode(response.body);
        _token = responseData['token'];

        // Save the token
        await saveToken(_token!);

        // Print token to terminal
        print('Login Successful! Token: $_token');

        // Fetch courses immediately after login
        await AdminfetchCoursesprovider(); // Fetch courses after login

        // Display success message
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Login successful!')),
        );

        // Navigate to the Dashboard
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => AdminDashboardScreen()),
        );

        notifyListeners();
      } else {
        final errorData = jsonDecode(response.body);
        String errorMessage = errorData['message'] ?? 'Login failed.';

        // Print the error message
        print('Login failed: $errorMessage');

        // Show error message in the UI
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(errorMessage)),
        );
        throw Exception(errorMessage);
      }
    } catch (error) {
      print('Error during login: $error');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text('An error occurred. Please check your details.')),
      );
      throw Exception('An error occurred. Please check your details.');
    }
  }

  Future<void> Adminregisterprovider(String email, String password, String name,
      String role, String phoneNumber) async {
    try {
      await _apiService.AdminRegisterAPI(
          email, password, name, role, phoneNumber);
    } catch (e) {
      print('Error creating register: $e');
      throw Exception('Failed to create register');
    }
  }

  // Logout method
  Future<void> logout() async {
    try {
      await clearToken();
      _token = null;
      notifyListeners();
      await _apiService.logoutAdmin();
    } catch (error) {
      print('Error during logout: $error');
      rethrow;
    }
  }

  // Check authentication and automatically fetch courses if authenticated
  Future<void> AdmincheckAuthprovider(BuildContext context) async {
 _token = await getToken();
  
  // Check if the token exists (indicating the user is logged in)
  if (_token != null) {
    // Navigate to StudentLMSHomePage if the user is logged in
 Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => AdminDashboardScreen()),
        );
  } else {
    // Navigate to UserLogin page if the user is not logged in
  Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => AdminLoginScreen()),
        );
  }
  notifyListeners();
  }

  // Fetch courses from the API
  Future<void> AdminfetchCoursesprovider() async {
    if (_token == null) throw Exception('Token is missing');
    try {
      _course = await _apiService.AdminfetchCoursesAPI(
          _token!); // Fetch courses correctly

      // Print the fetched courses to the terminal
      print('Fetched courses: $_course');

      notifyListeners(); // Notify listeners that courses are fetched
    } catch (e) {
      print('Error fetching courses: $e');
    }
  }

  // Create a new course
  Future<void> AdmincreateCourseprovider(
      String title, String description) async {
    if (_token == null) throw Exception('Token is missing');
    try {
      await _apiService.AdmincreateCourseAPI(title, description, _token!);
      await AdminfetchCoursesprovider(); // Refresh the course list after creation
    } catch (e) {
      print('Error creating course: $e');
      throw Exception('Failed to create course');
    }
  }

  Future<void> AdmindeleteCourseprovider(int courseId) async {
    if (_token == null) throw Exception('Token is missing');
    try {
      final result = await _apiService.deleteAdminCourse(courseId, _token!);
      print(result); // Optionally print success message

      // After successful deletion, re-fetch the courses to update the list
      await AdminfetchCoursesprovider();
    } catch (e) {
      print('Error deleting course: $e');
    }
  }

  Future<void> AdminupdateCourse(
      int courseId, String title, String description) async {
    if (_token == null) throw Exception('Token is missing');

    try {
      await _apiService.AdminupdateCourseAPI(
        _token!,
        courseId,
        title,
        description,
      );
      await AdminfetchCoursesprovider(); // Refresh the course list after update
    } catch (e) {
      print('Error updating course: $e');
      throw Exception('Failed to update course');
    }
  }

  Future<void> AdminfetchModulesForCourseProvider(int courseId, int batchId) async {
    if (_token == null) throw Exception('Token is missing');
    try {
      final modules =
          await _apiService.AdminfetchModulesForCourseAPI(_token!, courseId,batchId);
      _courseModules[courseId] = modules;
      _courseModules[batchId] = modules;
      notifyListeners();
    } catch (e) {
      print('Error fetching modules for course: $e');
      throw Exception('Failed to fetch modules for course');
    }
  }

  Future<void> Admincreatemoduleprovider(
      String title, String content, int courseId,int batchId) async {
    if (_token == null) throw Exception('Token is missing');
    try {
      print('Creating module for courseId: $courseId,$batchId');

      // Call API to create the module
      await _apiService.AdmincreatemoduleAPI(_token!, courseId,batchId, title, content);

      print('Module creation successful. Fetching updated modules...');

      // Fetch updated modules after creation
      await AdminfetchModulesForCourseProvider(courseId,batchId);

      print('Modules fetched successfully.');
    } catch (e) {
      print('Error creating module: $e');
      throw Exception('Failed to create module');
    }
  }

  Future<void> admindeletemoduleprovider(int courseId,int batchId, int moduleId) async {
    if (_token == null) throw Exception('Token is missing');
    try {
      final result =
          await _apiService.deleteAdminmodule(courseId,batchId, _token!, moduleId);
      print(result); // Optionally print success message

      if (_courseModules.containsKey(courseId)) {
        _courseModules[courseId]
            ?.removeWhere((module) => module.moduleId == moduleId);
        notifyListeners(); // Notify listeners immediately for UI update
      }
      // After successful deletion, re-fetch the courses to update the list
      await AdminfetchModulesForCourseProvider(courseId,batchId);
    } catch (e) {
      print('Error deleting module: $e');
    }
  }

  Future<void> AdminUpdatemoduleprovider(
      int courseId,int batchId, String title, String content, int moduleId) async {
    if (_token == null) throw Exception('Token is missing');

    try {
      await _apiService.AdminupdateModuleAPI(
          _token!, courseId,batchId, title, content, moduleId);
      await AdminfetchModulesForCourseProvider(
          courseId,batchId); // Refresh the course list after update
    } catch (e) {
      print('Error updating module: $e');
      throw Exception('Failed to update module');
    }
  }

  Future<void> AdminfetchLessonsForModuleProvider(
      int courseId,int batchId, int moduleId) async {
    if (_token == null) throw Exception('Token is missing');
    try {
      final lessons = await _apiService.AdminfetchLessonsForModuleAPI(
          _token!, courseId,batchId, moduleId);
      _moduleLessons[moduleId] = lessons;
      notifyListeners();
    } catch (e) {
      print('Error fetching lessons for module: $e');
      rethrow;
    }
  } 
  

  Future<void> Admincreatelessonprovider(
    int courseId,
    int batchId,
    int moduleId,
    String content,
    String title,
    String videoLink,
  ) async {
    if (_token == null) throw Exception('Token is missing');
    try {
      print('Creating lesson for courseId: $courseId');
      print('Creating lesson for moduleId: $moduleId');

      // Call API to create the lesson
      await _apiService.AdmincreatelessonseAPI(
        _token!,
        courseId,
        batchId,
        moduleId,
        content,
        title,
        videoLink,
      );

      print('Lesson creation successful. Fetching updated lessons...');

      // Fetch updated lessons after creation
      await AdminfetchLessonsForModuleProvider(
          courseId ,batchId, moduleId);

      print('Lessons fetched successfully.');
    } catch (e) {
      print('Error creating lesson: $e');
      throw Exception('Failed to create lesson: $e');
    }
  }

  Future<void> admindeletelessonprovider(
      int courseId, int batchId ,int moduleId, int lessonId) async {
    if (_token == null) throw Exception('Token is missing');
    try {
      final result = await _apiService.deleteAdminlesson(
          courseId,batchId, _token!, moduleId, lessonId);
      print(result); // Optionally print success message

      if (_courseModules.containsKey(courseId)) {
        _moduleLessons[moduleId]
            ?.removeWhere((lesson) => lesson.lessonId == lessonId);
        notifyListeners(); // Notify listeners immediately for UI update
      }
      // After successful deletion, re-fetch the courses to update the list
      await AdminfetchLessonsForModuleProvider(courseId,batchId, moduleId);
    } catch (e) {
      print('Error deleting module: $e');
    }
  }

  Future<void> AdminUpdatelessonprovider(int courseId,int batchId, String title,
      String content, int lessonId, int moduleId) async {
    if (_token == null) throw Exception('Token is missing');

    try {
      await _apiService.AdminupdateLessonAPI(
        _token!,
        courseId,
        batchId,
        title,
        content,
        moduleId,
        lessonId,
      );

      // Refresh the lessons list
      await AdminfetchLessonsForModuleProvider(courseId,batchId, moduleId);

      notifyListeners();
    } catch (e) {
      print('Error updating lesson: $e');
      throw Exception('Failed to update lesson: $e');
    }
  }

  Future<void> AdmincreateBatchprovider(String batchName, int courseId) async {
    if (_token == null) throw Exception('Token is missing');
    try {
      print('Creating Batch for courseId: $courseId');

      // Call API to create the module
      await _apiService.Admincreatebatch(_token!, courseId, batchName);

      print('Batch creation successful. Fetching updated modules...');

      // Fetch updated modules after creation
      await AdminfetchBatchForCourseProvider(courseId);

      print('Batch created successfully.');
    } catch (e) {
      print('Error creating Batch: $e');
      throw Exception('Failed to create Batch');
    }
  }

  Future<void> AdminfetchBatchForCourseProvider(int courseId) async {
    if (_token == null) throw Exception('Token is missing');

    try {
      _isLoading = true; // Set loading to true
      notifyListeners(); // Notify listeners that the loading state has changed

      final Batches =
          await _apiService.AdminfetctBatchForCourseAPI(_token!, courseId);
      _courseBatches[courseId] = Batches; // Store fetched batches

      _isLoading = false; // Set loading to false once data is fetched
      notifyListeners(); // Notify listeners that the loading state has changed
    } catch (e) {
      _isLoading = false; // Set loading to false if there’s an error
      notifyListeners(); // Notify listeners that the loading state has changed
      print('Error fetching batch for course: $e');
      throw Exception('Failed to fetch batch for course');
    }
  }

  Future<void> AdminUpdatebatchprovider(
      int courseId, int batchId, String batchName) async {
    if (_token == null) throw Exception('Token is missing');

    try {
      await _apiService.AdminupdateBatchAPI(
          _token!, courseId, batchId, batchName);
      await AdminfetchBatchForCourseProvider(
          courseId); // Refresh the course list after update
    } catch (e) {
      print('Error updating batch: $e');
      throw Exception('Failed to update batch');
    }
  }

  Future<void> AdmindeleteBatchprovider(int courseId, int batchId) async {
    if (_token == null) throw Exception('Token is missing');
    try {
      final result =
          await _apiService.deleteAdminBatch(courseId, _token!, batchId);
      print(result); // Optionally print success message

      if (_courseBatches.containsKey(courseId)) {
        _courseBatches[courseId]
            ?.removeWhere((Batche) => Batche.batchId == batchId);
        notifyListeners(); // Notify listeners immediately for UI update
      }
      // After successful deletion, re-fetch the courses to update the list
      await AdminfetchModulesForCourseProvider(courseId,batchId);
    } catch (e) {
      print('Error deleting module: $e');
    }
  }

  Future<void> AdminfetchallusersProvider() async {
    if (_token == null) throw Exception('Token is missing');
    try {
      _users = await _apiService.AdminfetchUsersAPI(_token!);

      // Print the fetched users to the terminal
      print('Fetched users: $_users');

      notifyListeners(); // Notify listeners that users are fetched
    } catch (e) {
      print('Error fetching users: $e');
    }
  }

  Future<void> assignUserToBatchProvider({
    required int courseId,
    required int batchId,
    required int userId,
  }) async {
    if (_token == null) throw Exception('Token is missing');

    try {
      final isSuccess = await _apiService.AdminassignUserToBatch(
        token: _token!,
        courseId: courseId,
        batchId: batchId,
        userId: userId,
      );

      if (isSuccess) {
        print('User successfully assigned to batch.');
        notifyListeners(); // Notify listeners if needed
      }
    } catch (e) {
      print('Error assigning user to batch: $e');
    }
  }

  Future<void> AdmindeleteUserFromBatchprovider({
    required int courseId,
    required int batchId,
    required int userId,
  }) async {
    if (_token == null) throw Exception('Token is missing');

    try {
      final isSuccess = await _apiService.AdmindeleteUserFromBatch(
        token: _token!,
        courseId: courseId,
        batchId: batchId,
        userId: userId,
      );

      if (isSuccess) {
        print('User successfully assigned to batch.');
        notifyListeners(); // Notify listeners if needed
      }
    } catch (e) {
      print('Error assigning user to batch: $e');
    }
  }

  Future<void> adminApproveUserprovider({
    required String role,
    required int userId,
  }) async {
    if (_token == null) throw Exception('Token is missing');

    try {
      final isSuccess = await _apiService.adminApproveUser(
        token: _token!,
        role: role,
        userId: userId,
      );

      if (isSuccess) {
        print('User successfully assigned to batch.');
        notifyListeners(); // Notify listeners if needed
      }
    } catch (e) {
      print('Error assigning user to batch: $e');
    }
  }

  Future<void> AdminUploadlessonprovider(int courseId,int batchId,  String title,
      String content, int lessonId, int moduleId) async {
    if (_token == null) throw Exception('Token is missing');

    try {
      await _apiService.AdminuploadLessonFile(
        _token!,
        courseId,
        batchId,
        title,
        content,
        moduleId,
        lessonId,
      );

      // Refresh the lessons list
      await AdminfetchLessonsForModuleProvider(courseId,batchId, moduleId);

      notifyListeners();
    } catch (e) {
      print('Error uploading lesson: $e');
      throw Exception('Failed to upload lesson: $e');
    }
  }
Future<void> AdmincreateLivelinkprovider(
  int batchId,
  int courseId,
  String liveLink,
  DateTime liveStartTime,
) async {
  if (_token == null) throw Exception('Token is missing');
  try {
    print('Creating LiveLink for courseId: $courseId and batchId: $batchId');

    // Call API to create the live link
    await _apiService.AdminpostLiveLink(
      _token!, 
      batchId, 
      liveLink, 
      liveStartTime
    );

    print('LiveLink creation successful. Fetching updated live data...');

    // Fetch updated live data after creation
    await fetchLiveAdmin(batchId);

    print('LiveLink created and data refreshed successfully.');
  } catch (e) {
    print('Error creating LiveLink: $e');
    if (e.toString().contains("Course not found")) {
      throw Exception('Course ID $courseId not found. Please verify.');
    } else {
      throw Exception('Failed to create LiveLink: $e');
    }
  }
}

Future<AdminLiveModel> fetchLiveAdmin(int batchId) async {
  if (_token == null) {
    throw Exception('Token is null. Please authenticate first.');
  }

  try {
    final liveData = await _apiService.fetchLiveAdmin(_token!, batchId);
    _liveBatch[batchId] = liveData;
    notifyListeners();  // Trigger UI rebuild
    return liveData;
  } catch (error) {
    print('Failed to fetch live data: $error');
    rethrow;
  }
}



}




