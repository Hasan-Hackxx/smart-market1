import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:smartmarket1/Chat/message_list_View.dart';
import 'package:smartmarket1/cloudDatabase/cloud_service.dart';
import 'package:smartmarket1/components/mytextfield.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class Chatpage extends StatefulWidget {
  final String email;
  final String otheruserId;
  final String otheruserEmail;
  final String userId;
  const Chatpage({
    super.key,
    required this.email,
    required this.otheruserId,
    required this.otheruserEmail,
    required this.userId,
  });

  @override
  State<Chatpage> createState() => _ChatpageState();
}

class _ChatpageState extends State<Chatpage> {
  late final TextEditingController message;

  final currentuserId = Supabase.instance.client.auth.currentUser!.id;
  final email = Supabase.instance.client.auth.currentUser!.email;

  FocusNode myfocusnode = FocusNode();

  @override
  void initState() {
    message = TextEditingController();

    if (myfocusnode.hasFocus) {
      Future.delayed(const Duration(milliseconds: 300), () => scrollDown());
    }
    super.initState();
  }

  @override
  void dispose() {
    message.dispose();
    myfocusnode.dispose();
    super.dispose();
  }

  ScrollController controller = ScrollController();
  void scrollDown() {
    controller.animateTo(
      controller.position.maxScrollExtent,
      duration: const Duration(milliseconds: 100),
      curve: Curves.fastOutSlowIn,
    );
  }

  void sendmessage() async {
    if (message.text.isNotEmpty && currentuserId == widget.userId) {
      await CloudService().sendMessage(
        widget.otheruserId,
        message.text,
        widget.otheruserEmail,
      );
      await CloudService().storePeoplewhotextme(
        currentuserId,
        email!,
        widget.otheruserEmail,
        widget.otheruserId,
      );
      message.clear();
    }
    scrollDown();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(widget.email),
        backgroundColor: Colors.grey,
      ),
      body: Column(
        children: [
          Expanded(
            child: StreamBuilder(
              stream: CloudService().getMessage(
                currentuserId,
                widget.otheruserId,
              ),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return const SizedBox.shrink();
                }

                if (snapshot.hasData) {
                  final messages = snapshot.data!;

                  return MessageListView(
                    messages: messages,
                    controller: controller,
                  );
                } else {
                  return Center(child: CircularProgressIndicator());
                }
              },
            ),
          ),

          _buildmessageinput(),
        ],
      ),
    );
  }

  Widget _buildmessageinput() {
    return Padding(
      padding: const EdgeInsets.all(6.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Expanded(
            child: Mytextfield(
              controller: message,
              hintText: 'Type a message',
              obscureText: false,
            ),
          ),
          SizedBox(width: 15.w),
          Container(
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.blue,
            ),
            child: IconButton(onPressed: sendmessage, icon: Icon(Icons.send)),
          ),
        ],
      ),
    );
  }
}
