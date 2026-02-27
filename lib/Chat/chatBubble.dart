import 'package:flutter/widgets.dart';

class Chatbubble extends StatelessWidget {
  final String message;
  final bool iscurrentuser;
  final String userId;
  final String otheruserId;
  const Chatbubble({
    super.key,
    required this.message,
    required this.iscurrentuser,
    required this.userId,
    required this.otheruserId,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        color: iscurrentuser
            ? Color.fromARGB(255, 255, 0, 0)
            : Color.fromARGB(255, 0, 0, 0),
      ),
      padding: EdgeInsets.all(10),
      margin: EdgeInsets.symmetric(vertical: 5, horizontal: 10),
      child: Text(
        message,
        style: TextStyle(
          color: Color.fromARGB(255, 255, 255, 255),
          fontWeight: FontWeight.w900,
        ),
      ),
    );
  }
}
