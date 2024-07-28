class OpenPosition {
  final String id;
  final String role;
  final String department;
  final List<String> skill;
  final int experience;
  final String interviewerId;
  final int minBudget;
  final int maxBudget;
  final String status;

  OpenPosition(
      {required this.id,
      required this.role,
      required this.department,
      required this.skill,
      required this.experience,
      required this.interviewerId,
      required this.minBudget,
      required this.maxBudget,
      required this.status});

  OpenPosition.empty(
      {this.id = "",
      this.role = "",
      this.department = "",
      this.skill = const [],
      this.experience = 0,
      this.interviewerId = "",
      this.minBudget = 0,
      this.maxBudget = 0,
      this.status = ""});

  static OpenPosition fromJson(Map<String, dynamic> json) => OpenPosition(
      id: json['id'],
      role: json['role'],
      department: json['department'],
      skill: json['skill'].split(";"),
      experience: json['experience'],
      interviewerId: json['interviewerId'],
      minBudget: json['minBudget'],
      maxBudget: json['maxBudget'],
      status: json['status']);
}
