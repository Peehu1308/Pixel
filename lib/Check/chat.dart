class Message {
  final String id;
  final String content;
  final bool markAsRead;
  final String Userfrom;
  final String UserTo;
  final DateTime createdAt;
  final bool isMine;

  Message({
    required this.id,
    required this.content,
    required this.markAsRead,
    required this.Userfrom,
    required this.UserTo,
    required this.createdAt,
    required this.isMine,
  });
  Message.create({
    
    required this.content,
    
    required this.Userfrom,
    required this.UserTo,
    
  }) : id="",
  markAsRead = false,
  createdAt = DateTime.now(),
  isMine = true;

  Message.fromJson(Map<String,dynamic>json,String userId):id=json['id'],
  content = json['content'],
  markAsRead = json['markAsRead'],
  Userfrom = json['Userfrom'],
  UserTo = json['UserTo'],
  createdAt = DateTime.parse(json['createdAt']),
  isMine = json['Userfrom'] == userId;

  Map toMap(){
    return{
      'content': content,
      'markAsRead': markAsRead,
      'Userfrom': Userfrom,
      'UserTo': UserTo,
    };
  }
}
