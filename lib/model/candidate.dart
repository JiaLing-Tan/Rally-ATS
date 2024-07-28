import 'dart:convert';

import 'package:http/http.dart' as http;

class Candidate {
  final String id;
  final String name;
  final String email;
  final String role;
  final DateTime date;
  final int rating;
  final List<String> skills;
  final List<String> education;
  final List<String> experience;
  final String explanation;
  final String status;
  final String contactNumber;
  final String resumeId;

  const Candidate(
      {required this.id,
      required this.name,
      required this.email,
      required this.role,
      required this.date,
      required this.rating,
      required this.skills,
      required this.education,
      required this.experience,
      required this.explanation,
      required this.status,
      required this.contactNumber,
      required this.resumeId});

  Candidate.empty(
      {this.id = "",
      this.name = "",
      this.email = "",
      this.role = "",
      this.rating = 0,
      this.skills = const [""],
      this.education = const [""],
      this.experience = const [""],
      this.explanation = "",
      this.status = "",
      this.contactNumber = "",
      this.resumeId = "",
      DateTime? dateTime})
      : date = dateTime ?? DateTime.now();

  static Candidate fromJson(Map<String, dynamic> json) => Candidate(
      id: json['id'],
      name: json['name'],
      email: json['email'],
      role: json['role'],
      date: DateTime.parse(json['date']),
      rating: json['rating'],
      skills: json['skills'].split(";"),
      education: json['education'].split(";"),
      experience: json['experience'].split(";"),
      explanation: json['explanation'],
      status: json['status'],
      contactNumber: json['contactNumber'].toString(),
  resumeId: json['resumeId'].toString());
}
