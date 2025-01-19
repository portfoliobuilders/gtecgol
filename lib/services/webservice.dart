import 'dart:convert';
import 'package:gtec/models/admin_model.dart';
import 'package:http/http.dart' as http;

class SuperAdminAPI {
  final String baseUrl = 'https://api.portfoliobuilders.in/api';

  Future<http.Response> loginAdminAPI(String email, String password) async {
    final url = Uri.parse('$baseUrl/login');
    return await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'email': email, 'password': password}),
    );
  }

  Future<http.Response> AdminRegisterAPI(
    String email,
    String password,
    String name,
    String role,
    String phoneNumber,
  ) async {
    final url = Uri.parse('$baseUrl/registerUser');

    try {
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'email': email,
          'password': password,
          'name': name,
          'role': role,
          'phoneNumber': phoneNumber,
        }),
      );

      if (response.statusCode == 200) {
        return response; // Return the response object for further handling
      } else {
        throw Exception('Failed to register user: ${response.body}');
      }
    } catch (e) {
      throw Exception('An error occurred during registration: $e');
    }
  }

  Future<http.Response> logoutAdmin() async {
    final url = Uri.parse('$baseUrl/logoutUser');
    return await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
    );
  }

  Future<List<Admincoursemodel>> AdminfetchCoursesAPI(String token) async {
    final url = Uri.parse('$baseUrl/admin/getAllCourses');
    try {
      final response = await http.get(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      print('Status Code: ${response.statusCode}');
      print('Response Body: ${response.body}');

      if (response.statusCode == 200) {
        final List<dynamic> courses = jsonDecode(response.body)['courses'];
        return courses.map((item) => Admincoursemodel.fromJson(item)).toList();
      } else {
        throw Exception('Failed to fetch courses: ${response.body}');
      }
    } catch (e) {
      print('Error: $e');
      rethrow;
    }
  }

  Future<String> AdmincreateCourseAPI(
      String title, String description, String token) async {
    final url = Uri.parse('$baseUrl/admin/createCourse');
    final response = await http.post(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode({'title': title, 'description': description}),
    );

    if (response.statusCode == 200 || response.statusCode == 201) {
      return response.body;
    } else {
      throw Exception('Failed to create course: ${response.reasonPhrase}');
    }
  }

  Future<String> deleteAdminCourse(int courseId, String token) async {
    final url = Uri.parse("$baseUrl/admin/$courseId");
    try {
      final response = await http.delete(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return data['message'] ?? "Course deleted successfully";
      } else {
        throw Exception(
            "Failed to delete course. Status Code: ${response.statusCode}");
      }
    } catch (e) {
      throw Exception("Error deleting course: $e");
    }
  }

  Future<String> AdminupdateCourseAPI(
      String token, int courseId, String title, String description) async {
    final url = Uri.parse(
        '$baseUrl/admin/updateCourse'); // Ensure this is the correct endpoint for updating a course

    // Prepare the request payload in the correct format
    final payload = jsonEncode({
      'courseId': courseId, // Ensure courseId is passed as a string if required
      'title': title,
      'description': description,
    });

    try {
      final response = await http.put(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: payload,
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        return response.body;
      } else {
        throw Exception('Failed to update course: ${response.reasonPhrase}');
      }
    } catch (e) {
      print('Error updating course: $e');
      rethrow;
    }
  }

  Future<List<AdminModulemodel>> AdminfetchModulesForCourseAPI(
      String token, int courseId, int batchId) async {
    final url = Uri.parse('$baseUrl/admin/getAllModule/$courseId/$batchId');
    try {
      final response = await http.get(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      print('Status Code: ${response.statusCode}');
      print('Response Body: ${response.body}');

      if (response.statusCode == 200) {
        final List<dynamic> modules = jsonDecode(response.body)['modules'];
        // Filter modules for the specific course
        return modules.map((item) => AdminModulemodel.fromJson(item)).toList();
      } else {
        throw Exception('Failed to fetch modules: ${response.body}');
      }
    } catch (e) {
      print('Error: $e');
      rethrow;
    }
  }

  Future<String> AdmincreatemoduleAPI(String token, int courseId, int batchId,
      String content, String title) async {
    final url = Uri.parse('$baseUrl/admin/createModule');
    final response = await http.post(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode({
        'courseId': courseId,
        'batchId': batchId,
        'title': title,
        'content': content
      }),
    );

    if (response.statusCode == 200 || response.statusCode == 201) {
      print(
          'Module created successfully: ${response.body}'); // Log the response body
      return response.body;
    } else {
      print(
          'Failed to create module: ${response.reasonPhrase}'); // Log failure reason
      throw Exception('Failed to create module: ${response.reasonPhrase}');
    }
  }

  Future<String> deleteAdminmodule(
      int courseId, int batchId, String token, int moduleId) async {
    final url =
        Uri.parse("$baseUrl/admin/deleteModule/$courseId/$moduleId/$batchId");
    try {
      final response = await http.delete(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return data['message'] ?? "Module deleted successfully";
      } else {
        throw Exception(
            "Failed to delete Module. Status Code: ${response.statusCode}");
      }
    } catch (e) {
      throw Exception("Error deleting Module: $e");
    }
  }

  Future<String> AdminupdateModuleAPI(String token, int courseId, int batchId,
      String title, String content, int moduleId) async {
    final url = Uri.parse(
        '$baseUrl/admin/updateModule'); // Ensure this is the correct endpoint for updating a course

    // Prepare the request payload in the correct format
    final payload = jsonEncode({
      'courseId': courseId,
      'batchId': batchId,
      'moduleId': moduleId, // Ensure courseId is passed as a string if required
      'title': title,
      'content': content,
    });

    try {
      final response = await http.put(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: payload,
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        return response.body;
      } else {
        throw Exception('Failed to update course: ${response.reasonPhrase}');
      }
    } catch (e) {
      print('Error updating course: $e');
      rethrow;
    }
  }

  Future<List<AdminLessonmodel>> AdminfetchLessonsForModuleAPI(
      String token, int courseId, int batchId, int moduleId) async {
    final url =
        Uri.parse('$baseUrl/admin/getAllLessons/$courseId/$moduleId/$batchId');
    try {
      final response = await http.get(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        final List<dynamic> lessons = jsonDecode(response.body)['lessons'];
        return lessons.map((item) => AdminLessonmodel.fromJson(item)).toList();
      } else {
        throw Exception('Failed to fetch lessons: ${response.body}');
      }
    } catch (e) {
      print('Error: $e');
      rethrow;
    }
  }

  Future<String> AdmincreatelessonseAPI(String token, int courseId, int batchId,
      int moduleId, String content, String title, String videoLink) async {
    final url = Uri.parse('$baseUrl/admin/createLesson');
    try {
      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: jsonEncode({
          'courseId': courseId,
          'batchId': batchId, // Convert to int for API
          'moduleId': moduleId, // Convert to int for API
          'title': title,
          'content': content,
          'videoLink': videoLink,
        }),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        print('Lesson created successfully: ${response.body}');
        return response.body;
      } else {
        print('Failed to create Lesson: ${response.reasonPhrase}');
        throw Exception('Failed to create Lesson: ${response.reasonPhrase}');
      }
    } catch (e) {
      print('Error in createlessonseAPI: $e');
      throw Exception('Failed to create lesson: $e');
    }
  }

  Future<String> AdminuploadLessonFile(String token, int courseId, int batchId,
      String title, String content, int moduleId, int lessonId) async {
    final url = Uri.parse(
        '$baseUrl/admin/uploadLessonFile$courseId/$moduleId/$lessonId/$batchId');

    final payload = jsonEncode({
      'lessonId': lessonId,
      'courseId': courseId,
      'batchId': batchId,
      'moduleId': moduleId,
      'title': title,
      'content': content,
    });

    try {
      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: payload,
      );

      print(
          'Upload Lesson Response: ${response.statusCode} - ${response.body}');

      if (response.statusCode == 200 || response.statusCode == 201) {
        return response.body;
      } else {
        throw Exception(
            'Failed to upload lesson: ${response.statusCode} - ${response.body}');
      }
    } catch (e) {
      print('Error uploading lesson: $e');
      rethrow;
    }
  }

  Future<String> deleteAdminlesson(int courseId, int batchId, String token,
      int moduleId, int lessonId) async {
    final url = Uri.parse(
        "$baseUrl/admin/deleteLesson/$courseId/$moduleId/$lessonId/$batchId");
    try {
      final response = await http.delete(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return data['message'] ?? "Lesson deleted successfull";
      } else {
        throw Exception(
            "Failed to delete Lesson. Status Code: ${response.statusCode}");
      }
    } catch (e) {
      throw Exception("Error deleting Lesson: $e");
    }
  }

  Future<String> AdminupdateLessonAPI(String token, int courseId, int batchId,
      String title, String content, int moduleId, int lessonId) async {
    final url = Uri.parse('$baseUrl/admin/updateLesson');

    final payload = jsonEncode({
      'lessonId': lessonId,
      'courseId': courseId,
      'batchId': batchId,
      'moduleId': moduleId,
      'title': title,
      'content': content,
    });

    try {
      final response = await http.put(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: payload,
      );

      print(
          'Update Lesson Response: ${response.statusCode} - ${response.body}');

      if (response.statusCode == 200 || response.statusCode == 201) {
        return response.body;
      } else {
        throw Exception(
            'Failed to update lesson: ${response.statusCode} - ${response.body}');
      }
    } catch (e) {
      print('Error updating lesson: $e');
      rethrow;
    }
  }

  Future<String> Admincreatebatch(
      String token, int courseId, String batchName) async {
    final url = Uri.parse('$baseUrl/admin/createBatch');
    final response = await http.post(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode({
        'courseId': courseId,
        'name': batchName,
      }),
    );

    if (response.statusCode == 200 || response.statusCode == 201) {
      print(
          'Batch created successfully: ${response.body}'); // Log the response body
      return response.body;
    } else {
      print(
          'Failed to create Batch: ${response.reasonPhrase}'); // Log failure reason
      throw Exception('Failed to create Batch: ${response.reasonPhrase}');
    }
  }

  Future<List<AdminCourseBatch>> AdminfetctBatchForCourseAPI(
      String token, int courseId) async {
    final url = Uri.parse('$baseUrl/admin/getBatchesByCourseId/$courseId');
    try {
      final response = await http.get(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      print('Status Code: ${response.statusCode}');
      print('Response Body: ${response.body}');

      if (response.statusCode == 200) {
        final List<dynamic> Batches = jsonDecode(response.body)['batches'];
        // Filter modules for the specific course
        return Batches.map((item) => AdminCourseBatch.fromJson(item)).toList();
      } else {
        throw Exception('Failed to fetch modules: ${response.body}');
      }
    } catch (e) {
      print('Error: $e');
      rethrow;
    }
  }

  Future<String> AdminupdateBatchAPI(
      String token, int courseId, int batchId, String batchName) async {
    final url = Uri.parse(
        '$baseUrl/admin/updateBatch'); // Ensure this is the correct endpoint for updating a course

    // Prepare the request payload in the correct format
    final payload = jsonEncode({
      'courseId': courseId,
      'batchId': batchId,
      'name': batchName, // Ensure courseId is passed as a string if required
    });

    try {
      final response = await http.put(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: payload,
      );
      print("___________________");
      print(response.body);
      print("___________________");
      if (response.statusCode == 200 || response.statusCode == 201) {
        return response.body;
      } else {
        throw Exception('Failed to update batch: ${response.reasonPhrase}');
      }
    } catch (e) {
      print('Error updating batch: $e');
      rethrow;
    }
  }

  Future<String> deleteAdminBatch(
      int courseId, String token, int batchId) async {
    final url = Uri.parse("$baseUrl/admin/$courseId/$batchId");
    try {
      final response = await http.delete(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return data['message'] ?? "Module deleted successfully";
      } else {
        throw Exception(
            "Failed to delete Module. Status Code: ${response.statusCode}");
      }
    } catch (e) {
      throw Exception("Error deleting Module: $e");
    }
  }

  Future<List<AdminAllusersmodel>> AdminfetchUsersAPI(String token) async {
    final url = Uri.parse('$baseUrl/admin/dashboard');
    try {
      final response = await http.get(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      print('Status Code: ${response.statusCode}');
      print('Response Body: ${response.body}');

      if (response.statusCode == 200) {
        final List<dynamic> users = jsonDecode(response.body)['users'];
        return users.map((item) => AdminAllusersmodel.fromJson(item)).toList();
      } else {
        throw Exception('Failed to fetch users: ${response.body}');
      }
    } catch (e) {
      print('Error: $e');
      rethrow;
    }
  }

  Future<bool> AdminassignUserToBatch({
    required String token,
    required int courseId,
    required int batchId,
    required int userId,
  }) async {
    final url = Uri.parse('$baseUrl/admin/assignUserToBatch');

    try {
      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: jsonEncode({
          'courseId': courseId,
          'batchId': batchId,
          'userId': userId,
        }),
      );

      print('Status Code: ${response.statusCode}');
      print('Response Body: ${response.body}');

      if (response.statusCode == 200) {
        return true; // Indicates success
      } else {
        throw Exception('Failed to assign user to batch: ${response.body}');
      }
    } catch (e) {
      print('Error: $e');
      rethrow;
    }
  }

  Future<bool> AdmindeleteUserFromBatch({
    required String token,
    required int courseId,
    required int batchId,
    required int userId,
  }) async {
    final url = Uri.parse('$baseUrl/admin/deleteUserFromBatch');

    try {
      final response = await http.delete(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: jsonEncode({
          'courseId': courseId,
          'batchId': batchId,
          'userId': userId,
        }),
      );

      print('Status Code: ${response.statusCode}');
      print('Response Body: ${response.body}');

      if (response.statusCode == 200) {
        return true; // Indicates success
      } else {
        throw Exception('Failed to delete user to batch: ${response.body}');
      }
    } catch (e) {
      print('Error: $e');
      rethrow;
    }
  }

  Future<bool> adminApproveUser({
    required String token,
    required String role,
    required int userId,
  }) async {
    final url = Uri.parse('$baseUrl/admin/adminApproveUser');

    try {
      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: jsonEncode({
          'role': role,
          'id': userId,
        }),
      );

      print('Status Code: ${response.statusCode}');
      print('Response Body: ${response.body}');

      if (response.statusCode == 200) {
        return true; // Indicates success
      } else {
        throw Exception('Failed to Approval User : ${response.body}');
      }
    } catch (e) {
      print('Error: $e');
      rethrow;
    }
  }



Future<String> AdminpostLiveLink(
  String token,
  int batchId,
  String liveLink,
  DateTime? liveStartTime, // Make it nullable
) async {
  final url = Uri.parse('$baseUrl/admin/$batchId/postLiveLink');
  
  final response = await http.post(
    url,
    headers: {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token',
    },
    body: jsonEncode({
      'liveLink': liveLink,
      'liveStartTime': liveStartTime?.toUtc().toIso8601String(), // Convert DateTime to ISO 8601 string
    }),
  );

  if (response.statusCode == 200 || response.statusCode == 201) {
    print('Live link posted successfully: ${response.body}');
    return response.body;
  } else {
    print('Failed to create Live link: ${response.reasonPhrase}');
    throw Exception('Failed to create Live link: ${response.reasonPhrase}');
  }
}


  Future<AdminLiveModel> fetchLiveAdmin(String token, int batchId) async {
    final url = Uri.parse('$baseUrl/admin/getLiveLinkbatch/$batchId');
    try {
      final response = await http.get(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        print('Fetched live data: $data');
        return AdminLiveModel.fromJson(data);
      } else {
        throw Exception('Failed to load live link');
      }
    } catch (e) {
      print('Error fetching live data: $e');
      throw Exception('Error fetching live link');
    }
  }
}
