class Job {
  final int id;
  final String title;
  final String company;
  final String location;
  final String salary;
  final String employmentType;
  final String description;
  final String postedDate;
  final int categoryId;
  final String categoryName;
  final String status;

  Job({
    required this.id,
    required this.title,
    required this.company,
    required this.location,
    required this.salary,
    required this.employmentType,
    required this.description,
    required this.postedDate,
    required this.categoryId,
    required this.categoryName,
    required this.status,
  });

  factory Job.fromJson(Map<String, dynamic> json) {
    return Job(
      id: json['id'],
      title: json['title'],
      company: json['company'],
      location: json['location'],
      salary: json['salary'],
      employmentType: json['employmentType'],
      description: json['description'],
      postedDate: json['postedDate'],
      categoryId: json['categoryId'],
      categoryName: json['categoryName'],
      status: json['status'],
    );
  }
}