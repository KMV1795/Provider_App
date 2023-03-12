class LoginModel {
  String id;
  String time;
  String date;
  String ip;
  String location;
  String? url;

  LoginModel({
    this.id = '',
    required this.time,
    required this.date,
    required this.ip,
    required this.location,
    this.url,
  });

  Map<String, dynamic> toJson() => {
        'id': id,
        'time': time,
        'date': date,
        'ip': ip,
        'location': location,
        'url': url,
      };

  static LoginModel fromJson(Map<String, dynamic> json) => LoginModel(
        id: json['id'],
        time: json['time'],
        date: json['date'],
        ip: json['ip'],
        location: json['location'],
        url: json['url'],
      );
}
