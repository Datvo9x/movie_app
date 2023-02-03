import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';

class FeedbackUser extends StatefulWidget {
  const FeedbackUser({Key? key}) : super(key: key);

  @override
  _FeedbackUserState createState() => _FeedbackUserState();
}

class _FeedbackUserState extends State<FeedbackUser> {
  final formkey = GlobalKey<FormState>();

  final TextEditingController email = TextEditingController();
  final TextEditingController name = TextEditingController();
  final TextEditingController vde = TextEditingController();
  final TextEditingController nd = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 27, 27, 27),
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 23, 35, 39),
        title: const Center(
          child: Text(
            "Phản hồi về ứng dụng     ",
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.fromLTRB(15, 20, 15, 10),
        child: SingleChildScrollView(
          child: Form(
            key: formkey,
            autovalidateMode: AutovalidateMode.onUserInteraction,
            child: Column(
              children: [
                Container(
                  decoration: BoxDecoration(
                    color: const Color.fromARGB(255, 53, 53, 53),
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: TextFormField(
                    validator: (ema) {
                      if (ema != null && !EmailValidator.validate(ema)) {
                        return 'Vui lòng nhập đúng định dạng @';
                      } else
                        return null;
                    },
                    style: const TextStyle(color: Colors.white),
                    decoration: const InputDecoration(
                      contentPadding: EdgeInsets.fromLTRB(10, 0, 5, 0),
                      hintText: 'Nhập Email',
                      hintStyle: TextStyle(
                        color: Colors.white70,
                      ),
                      border: InputBorder.none,
                      focusedBorder: InputBorder.none,
                      enabledBorder: InputBorder.none,
                      errorBorder: InputBorder.none,
                      disabledBorder: InputBorder.none,
                    ),
                    controller: email,
                  ),
                ),
                const SizedBox(
                  height: 15,
                ),
                Container(
                  decoration: BoxDecoration(
                    color: const Color.fromARGB(255, 53, 53, 53),
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: TextFormField(
                    validator: (nam) {
                      if (nam != null && nam.length < 8) {
                        return 'Tên phải dài hơn 8 ký tự';
                      } else
                        return null;
                    },
                    style: const TextStyle(color: Colors.white),
                    decoration: const InputDecoration(
                      contentPadding: EdgeInsets.fromLTRB(10, 0, 5, 0),
                      hintText: 'Nhập tên của bạn',
                      hintStyle: TextStyle(
                        color: Colors.white70,
                      ),
                      border: InputBorder.none,
                      focusedBorder: InputBorder.none,
                      enabledBorder: InputBorder.none,
                      errorBorder: InputBorder.none,
                      disabledBorder: InputBorder.none,
                    ),
                    controller: name,
                  ),
                ),
                const SizedBox(
                  height: 15,
                ),
                Container(
                  decoration: BoxDecoration(
                    color: const Color.fromARGB(255, 53, 53, 53),
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: TextFormField(
                    validator: (vade) {
                      if (vade != null && vade.length < 15) {
                        return 'Nội dung phải dài hơn 15 ký tự';
                      } else
                        return null;
                    },
                    style: const TextStyle(color: Colors.white),
                    decoration: const InputDecoration(
                      contentPadding: EdgeInsets.fromLTRB(10, 0, 5, 0),
                      hintText: 'Nhập vấn đề',
                      hintStyle: TextStyle(
                        color: Colors.white70,
                      ),
                      border: InputBorder.none,
                      focusedBorder: InputBorder.none,
                      enabledBorder: InputBorder.none,
                      errorBorder: InputBorder.none,
                      disabledBorder: InputBorder.none,
                    ),
                    controller: vde,
                  ),
                ),
                const SizedBox(
                  height: 15,
                ),
                Container(
                  padding: const EdgeInsets.fromLTRB(0, 10, 0, 10),
                  decoration: BoxDecoration(
                    color: const Color.fromARGB(255, 53, 53, 53),
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: TextFormField(
                    validator: (ndu) {
                      if (ndu != null && ndu.length < 50) {
                        return 'Nội dung cần chi tiết hơn';
                      } else
                        return null;
                    },
                    maxLines: 8,
                    style: const TextStyle(color: Colors.white),
                    decoration: const InputDecoration(
                      contentPadding: EdgeInsets.fromLTRB(10, 0, 5, 0),
                      hintText: 'Nhập nội dung',
                      hintStyle: TextStyle(
                        color: Colors.white70,
                      ),
                      border: InputBorder.none,
                      focusedBorder: InputBorder.none,
                      enabledBorder: InputBorder.none,
                      errorBorder: InputBorder.none,
                      disabledBorder: InputBorder.none,
                    ),
                    controller: nd,
                  ),
                ),
                const SizedBox(
                  height: 15,
                ),
                GestureDetector(
                  onTap: () {
                    final isValidForm = formkey.currentState!.validate();
                    if (isValidForm) {
                      print('tap gui');
                      setState(() {
                        FirebaseFirestore.instance.collection("feedback").add(
                          {
                            "email": email.text,
                            "name": name.text,
                            "vde": vde.text,
                            "nd": nd.text,
                          },
                        );
                      });
                      email.clear();
                      name.clear();
                      vde.clear();
                      nd.clear();
                      _showOK(context);
                      Navigator.pop(context);
                    } else
                      print('loi roi');
                  },
                  child: Container(
                    height: 50,
                    decoration: const BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(5)),
                      gradient: LinearGradient(
                        colors: [
                          Color.fromARGB(255, 226, 69, 16),
                          Color.fromRGBO(232, 87, 9, 1),
                          Color.fromRGBO(241, 110, 16, 1),
                        ],
                      ),
                    ),
                    child: const Center(
                      child: Text(
                        'Gửi',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w700,
                          color: Color.fromARGB(255, 219, 217, 216),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _showOK(BuildContext context) {
    // ignore: prefer_const_constructors
    final snack = SnackBar(
      content: const Text(
        'Đã nhận phản hồi từ bạn !',
        style: TextStyle(fontSize: 14),
        textAlign: TextAlign.center,
      ),
      backgroundColor: const Color.fromARGB(255, 10, 149, 137),
      duration: const Duration(seconds: 2),

      // shape: const StadiumBorder(),
    );
    ScaffoldMessenger.of(context).showSnackBar(snack);
  }
}
