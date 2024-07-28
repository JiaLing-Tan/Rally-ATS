class Request {
  final String id;
  final String employeeId;
  final DateTime timestamp;
  final String header;
  final String body;
  final String tag;
  final String remark;
  final String status;

  Request({required this.id,
    required this.employeeId,
    required this.timestamp,
    required this.header,
    required this.body,
    required this.tag,
    required this.remark,
    required this.status,});

  Request.empty({this.id = "",
    this.employeeId = "",
    this.header = "",
    this.body = "",
    this.tag = "",
    this.remark = "",
    this.status = "",
    DateTime? dateTime})
      : timestamp = dateTime ?? DateTime.now();

  static Request fromJson(Map<String, dynamic> json) =>
      Request(id: json['id'],
          employeeId: json['employeeId'],
          timestamp: DateTime.parse(json['timestamp']),
          header: json['requestHeader'],
          body: json['requestBody'],
          tag: json['tag'],
          remark: json['remark'],
          status: json['status']);
}
