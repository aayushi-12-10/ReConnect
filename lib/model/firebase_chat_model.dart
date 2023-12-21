class FirebaseChatModel {
  final String uid;
  final String name;
  final String email;
  final String image;
  final String about;
  final DateTime lastActive;
  final bool isOnline;

  const FirebaseChatModel({
    required this.name,
    required this.image,
    required this.lastActive,
    required this.uid,
    required this.email,
    required this.about,
    this.isOnline = false,
  });

  factory FirebaseChatModel.fromJson(Map<String, dynamic> json) =>
      FirebaseChatModel(
        uid: json['uid'],
        name: json['name'],
        image: json['image'],
        email: json['email'],
        about: json['about'],
        isOnline: json['isOnline'] ?? false,
        lastActive: json['lastActive'].toDate(),
      );

  Map<String, dynamic> toJson() => {
        'uid': uid,
        'name': name,
        'image': image,
        'email': email,
        'about': about,
        'isOnline': isOnline,
        'lastActive': lastActive,
      };
}
