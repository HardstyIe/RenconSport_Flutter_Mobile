class Message {
  final String id;
  final String chatGroupId;
  final String senderId;
  final String content;
  final DateTime sendAt;

  Message(
    this.id,
    this.chatGroupId,
    this.senderId,
    this.content,
    this.sendAt,
  );
  Message.fromJson(Map<String, dynamic> json)
      : id = json["id"],
        chatGroupId = json["chatGroupId"],
        senderId = json["senderId"],
        content = json["content"],
        sendAt = json["sendAt"];
}