class FlashMessage {
  String id;
  String messageTitle;
  String messageBody;

  FlashMessage({this.id, this.messageTitle, this.messageBody});

  FlashMessage.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    messageTitle = json['message_title'];
    messageBody = json['message_body'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['message_title'] = this.messageTitle;
    data['message_body'] = this.messageBody;
    return data;
  }
}
