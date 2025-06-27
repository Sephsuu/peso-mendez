class User {
  final int id;
  final String fullName;
  final String email;
  final String contact;
  final String skills;
  final String documentPath;
  final String username;
  final String password;
  final String role;       
  final DateTime createdAt;
  final bool? isActive;    
  final String status;    

  User({
    required this.id,
    required this.fullName,
    required this.email,
    required this.contact,
    required this.skills,
    required this.documentPath,
    required this.username,
    required this.password,
    required this.role,
    required this.createdAt,
    this.isActive,
    required this.status,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'] is int ? json['id'] : int.tryParse(json['id'].toString()) ?? 0,
      fullName: json['full_name'] ?? '',
      email: json['email'] ?? '',
      contact: json['contact'] ?? '',
      skills: json['skills'] ?? '',
      documentPath: json['document_path'] ?? '',
      username: json['username'] ?? '',
      password: json['password'] ?? '',
      role: json['role'] ?? '',
      createdAt: DateTime.tryParse(json['created_at'] ?? '') ?? DateTime.now(),
      isActive: json['is_active'] == null ? null : (json['is_active'] == 1),
      status: json['status'] ?? '',
    );
  }
}

class Job {
  final int id;
  final String title;
  final String company;
  final String location;
  final String salary;
  final String type;
  final String description;
  final String posted_on;
  final int employer_id;
  final int category_id;
  final String visibility;
  final String status;

  Job({
    required this.id,
    required this.title,
    required this.company,
    required this.location,
    required this.salary,
    required this.type,
    required this.description,
    required this.posted_on,
    required this.employer_id,
    required this.category_id,
    required this.visibility,
    required this.status,
  });

  factory Job.fromJson(Map<String, dynamic> json) {
    return Job(
      id: json['id'] ?? 0,
      title: json['title'] ?? 'No title',
      company: json['company'] ?? 'No company',
      location: json['location'] ?? 'No location',
      salary: json['salary'] ?? 'Not specified',
      type: json['type'] ?? 'Unknown',
      employer_id: json['employer_id'] ?? 0,
      description: json['description'] ?? '',
      posted_on: json['postedDate'] ?? '',
      category_id: json['categoryId'] ?? 0,
      visibility: json['visibility'] ?? '',
      status: json['status'] ?? '',
    );
  }
}

class Application {
  final int id;
  final int jobId;
  final int jobSeekerId;
  final String status;     
  final DateTime? appliedOn; 

  Application({
    required this.id,
    required this.jobId,
    required this.jobSeekerId,
    required this.status,
    this.appliedOn,
  });

  factory Application.fromJson(Map<String, dynamic> json) {
    return Application(
      id: json['id'] is int ? json['id'] : int.tryParse(json['id'].toString()) ?? 0,
      jobId: json['job_id'] is int ? json['job_id'] : int.tryParse(json['job_id'].toString()) ?? 0,
      jobSeekerId: json['job_seeker_id'] is int ? json['job_seeker_id'] : int.tryParse(json['job_seeker_id'].toString()) ?? 0,
      status: json['status'] ?? 'Sent',
      appliedOn: json['applied_on'] == null
          ? null
          : DateTime.tryParse(json['applied_on']) ?? DateTime.now(),
    );
  }
}

