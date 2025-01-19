class Admincoursemodel {
  final int courseId;
  final String name;
  final String description;

  Admincoursemodel({
    required this.courseId,
    required this.name,
    required this.description,
  });

  factory Admincoursemodel.fromJson(Map<String, dynamic> json) {
    return Admincoursemodel(
      courseId: json['courseId'], // Matches the field in the API response
      name: json['name'],
      description: json['description'],
    );
  }
}

class AdminModulemodel {
  final int batchId;
  final int moduleId;
  final String title;
  final String content;

  AdminModulemodel({
    required this.batchId,
    required this.moduleId,
    required this.title,
    required this.content,
  });

  // Factory constructor to create a Course instance from JSON
  factory AdminModulemodel.fromJson(Map<String, dynamic> json) {
    return AdminModulemodel(
      batchId: json['batchId'],
      moduleId: json['moduleId'],
      content: json['content'],
      title: json['title'],
    );
  }
}

class AdminLessonmodel {
  final int lessonId;
  final int moduleId;
  final int courseId;
  final int batchId;
  final String title;
  final String content;
  final String videoLink;
  final String? pdfPath; // Nullable
  final String status;

  AdminLessonmodel({
    required this.lessonId,
    required this.moduleId,
    required this.courseId,
    required this.batchId,
    required this.title,
    required this.content,
    required this.videoLink,
    this.pdfPath, // Nullable
    required this.status,
  });

  factory AdminLessonmodel.fromJson(Map<String, dynamic> json) {
    return AdminLessonmodel(
      lessonId: int.parse(json['lessonId']?.toString() ?? '0'), // Fallback to 0
      moduleId: int.parse(json['moduleId']?.toString() ?? '0'), // Fallback to 0
      courseId: int.parse(json['courseId']?.toString() ?? '0'), // Fallback to 0
      batchId: int.parse(json['batchId']?.toString() ?? '0'), // Fallback to 0
      title: json['title'] ?? '', // Default to empty string
      content: json['content'] ?? '', // Default to empty string
      videoLink: json['videoLink'] ?? '', // Default to empty string
      pdfPath: json['pdfPath'], // Nullable field
      status: json['status'] ?? '', // Default to empty string
    );
  }
}

class AdminCourseBatch {
  final int batchId;
  final String batchName;

  AdminCourseBatch({
    required this.batchId,
    required this.batchName,
  });

  // Factory constructor to create CourseBatch from JSON
  factory AdminCourseBatch.fromJson(Map<String, dynamic> json) {
    return AdminCourseBatch(
      batchId: json['batchId'],
      batchName: json['batchName'],
    );
  }
}

class AdminAllusersmodel {
  final String name;
  final String email;
  final String phoneNumber;
  final String role;
  final int userId;

  AdminAllusersmodel({
    required this.name,
    required this.email,
    required this.phoneNumber,
    required this.role,
    required this.userId,
  });

  factory AdminAllusersmodel.fromJson(Map<String, dynamic> json) {
    return AdminAllusersmodel(
      name: json['name'],
      email: json['email'],
      phoneNumber: json['phoneNumber'],
      role: json['role'],
      userId: json['userId'],
    );
  }
}


class AdminLiveModel {
  final String message;
  final String liveLink;
  final DateTime liveStartTime;

  AdminLiveModel({
    required this.message,
    required this.liveLink,
    required this.liveStartTime,
  });

  // Factory method to create a model from JSON
  factory AdminLiveModel.fromJson(Map<String, dynamic> json) {
    return AdminLiveModel(
      message: json['message'] ?? '', // Handle null or missing values
      liveLink: json['liveLink'] ?? '', // Handle null or missing values
      liveStartTime: DateTime.parse(json['liveStartTime']), // Parse String to DateTime
    );
  }
}


