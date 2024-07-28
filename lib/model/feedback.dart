import 'package:rally/model/candidate.dart';

class InterviewFeedback {
  final String interviewerId;
  final String candidateId;
  final int education;
  final int training;
  final int workExperience;
  final int companyKnowledge;
  final int technicalSkills;
  final int multitaskingSkills;
  final int communicationSkills;
  final int teamwork;
  final int stressTolerance;
  final int cultureFit;
  final String overallOpinion;

  InterviewFeedback(
      {required this.interviewerId,
      required this.candidateId,
      required this.education,
      required this.training,
      required this.workExperience,
      required this.companyKnowledge,
      required this.technicalSkills,
      required this.multitaskingSkills,
      required this.communicationSkills,
      required this.teamwork,
      required this.stressTolerance,
      required this.cultureFit,
      required this.overallOpinion});

  InterviewFeedback.empty(
      {this.interviewerId = "",
      this.candidateId = "",
      this.education = 0,
      this.training = 0,
      this.workExperience = 0,
      this.companyKnowledge = 0,
      this.technicalSkills = 0,
      this.multitaskingSkills = 0,
      this.communicationSkills = 0,
      this.teamwork = 0,
      this.stressTolerance = 0,
      this.cultureFit = 0,
      this.overallOpinion = ""});

  static InterviewFeedback fromJson(Map<String, dynamic> json) =>
      InterviewFeedback(
          interviewerId: json['interviewerId'].toString(),
          candidateId: json['candidateId'],
          education: json['education'],
          training: json['training'],
          workExperience: json['workExperience'],
          companyKnowledge: json['companyKnowledge'],
          technicalSkills: json['technicalSkills'],
          multitaskingSkills: json['multitaskingSkills'],
          communicationSkills: json['communicationSkills'],
          teamwork: json['teamwork'],
          stressTolerance: json['stressTolerance'],
          cultureFit: json['cultureFit'],
          overallOpinion: json['overallOpinion']);

  int getTotal() => (education+
      training+
      workExperience+
      companyKnowledge+
      technicalSkills+
      multitaskingSkills+
      communicationSkills+
      teamwork+
      stressTolerance+
      cultureFit);
}
