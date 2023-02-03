import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';

// ignore: must_be_immutable
class UpdateMovie extends StatefulWidget {
  UpdateMovie({
    Key? key,
    required this.id,
    required this.nickname,
    required this.photoUrl,
    required this.sex,
  }) : super(key: key);

  String nickname, photoUrl, id, sex;

  @override
  State<UpdateMovie> createState() => _UpdateMovieState();
}

class _UpdateMovieState extends State<UpdateMovie> {
  String? _filename;
  FilePickerResult? results;
  PlatformFile? pickedFile;
  UploadTask? uploadTask;
  int _RadioSite = 0;
  String? _sex = 'Nam';

  @override
  Widget build(BuildContext context) {
    final TextEditingController nickname =
        TextEditingController(text: widget.nickname);

    String _image = widget.photoUrl;

    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        actions: const [
          SizedBox(
            width: 45,
          ),
        ],
        backgroundColor: const Color.fromARGB(255, 93, 5, 235),
        title: const Center(
          child: Text('Sửa Thông Tin'),
        ),
      ),
      body: SingleChildScrollView(
        child: Container(
          color: const Color.fromARGB(255, 236, 226, 255),
          child: Padding(
            padding: const EdgeInsets.fromLTRB(0.0, 15, 0, 10),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Column(
                  children: [
                    (_filename == null)
                        ? Container(
                            height: 120,
                            width: 120,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(100.0),
                              image: DecorationImage(
                                fit: BoxFit.cover,
                                image: NetworkImage(
                                  widget.photoUrl,
                                ),
                              ),
                            ),
                          )
                        : ClipRRect(
                            borderRadius: BorderRadius.circular(100),
                            child: Image.file(
                              File(pickedFile!.path.toString()),
                              fit: BoxFit.cover,
                              width: 120,
                              height: 120,
                            ),
                          ),
                    TextButton(
                      onPressed: () async {
                        await choseImage();
                      },
                      child: Container(
                        decoration: BoxDecoration(
                          color: const Color.fromARGB(255, 93, 5, 235),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        padding: const EdgeInsets.fromLTRB(6, 3, 6, 3),
                        child: const Text(
                          ' Sửa ',
                          style: TextStyle(color: Colors.white, fontSize: 10),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(
                  height: 20,
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    SizedBox(
                      width: 280,
                      height: 45,
                      child: TextFormField(
                        decoration: const InputDecoration(
                          border: OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.white)),
                          labelText: "Tên của bạn",
                        ),
                        controller: nickname,
                      ),
                    ),
                  ],
                ),
                const SizedBox(
                  height: 10,
                ),
                SizedBox(
                  width: 280,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Radio(
                              activeColor:
                                  const Color.fromARGB(255, 121, 68, 205),
                              value: 0,
                              groupValue: _RadioSite,
                              onChanged: (int? value) {
                                setState(() {
                                  _RadioSite = value!;
                                });
                                _sex = "Nam";
                              }),
                          const Text('Nam'),
                        ],
                      ),
                      Row(
                        children: [
                          Radio(
                              activeColor:
                                  const Color.fromARGB(255, 121, 68, 205),
                              value: 1,
                              groupValue: _RadioSite,
                              onChanged: (int? value) {
                                setState(() {
                                  _RadioSite = value!;
                                });
                                _sex = "Nữ";
                              }),
                          const Text('Nữ'),
                        ],
                      ),
                      Row(
                        children: [
                          Radio(
                              activeColor:
                                  const Color.fromARGB(255, 121, 68, 205),
                              value: 2,
                              groupValue: _RadioSite,
                              onChanged: (int? value) {
                                setState(() {
                                  _RadioSite = value!;
                                });
                                _sex = "Khác";
                              }),
                          const Text('Khác    '),
                        ],
                      )
                    ],
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    TextButton(
                      onPressed: () async {
                        if (nickname.text == '') {
                          _showNot(context);
                        } else {
                          if (pickedFile != null) {
                            final _path = 'profile/${pickedFile!.name}';
                            final _file = File(pickedFile!.path.toString());
                            final ref =
                                FirebaseStorage.instance.ref().child(_path);
                            uploadTask = ref.putFile(_file);
                            final snapshot =
                                await uploadTask!.whenComplete(() => null);
                            final downloadUrl =
                                await snapshot.ref.getDownloadURL();
                            setState(() {
                              _image = downloadUrl;
                            });
                            await FirebaseFirestore.instance
                                .collection("users")
                                .doc(widget.id)
                                .update(
                              {
                                "photoUrl": _image,
                                "nickname": nickname.text,
                                "sex": _sex,
                              },
                            );
                            _showOK(
                                context, 'Chỉnh sửa thông tin thành công !');
                          } else {
                            setState(() {
                              _image = widget.photoUrl;
                            });
                            await FirebaseFirestore.instance
                                .collection("users")
                                .doc(widget.id)
                                .update(
                              {
                                "photoUrl": _image,
                                "nickname": nickname.text,
                                "sex": _sex,
                              },
                            );
                            _showOK(
                                context, 'Chỉnh sửa thông tin thành công !');
                          }
                          Navigator.pop(context);
                        }
                      },
                      child: Container(
                        alignment: Alignment.center,
                        height: 38,
                        width: 200,
                        decoration: const BoxDecoration(
                          borderRadius: BorderRadius.all(Radius.circular(50)),
                          gradient: LinearGradient(
                            colors: [
                              Color.fromARGB(255, 93, 5, 235),
                              Color.fromARGB(255, 84, 20, 186),
                              Color.fromARGB(255, 149, 13, 140),
                            ],
                          ),
                        ),
                        child: const Text(
                          ' Chỉnh sửa ',
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    ),
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future choseImage() async {
    final results = await FilePicker.platform.pickFiles(
      allowMultiple: false,
      type: FileType.custom,
      allowedExtensions: ['png', 'jpg'],
    );
    if (results != null) {
      setState(() {
        pickedFile = results.files.first;
        _filename = results.files.single.name;
      });
    } else {
      debugPrint("No file selected");
    }
  }
}

void _showNot(BuildContext context) {
  showDialog(
    builder: (context) => AlertDialog(
      title: const Text('Thông báo'),
      content: const Text('Vui lòng nhập đủ các trường !'),
      actions: <Widget>[
        TextButton(
          child: Container(
            decoration: BoxDecoration(
              color: const Color.fromARGB(255, 13, 93, 214),
              borderRadius: BorderRadius.circular(20),
            ),
            padding: const EdgeInsets.fromLTRB(16, 6, 16, 6),
            child: const Text(
              'Đồng ý',
              style: TextStyle(color: Colors.white, fontSize: 14),
            ),
          ),
          onPressed: () {
            Navigator.pop(context);
          },
        )
      ],
    ),
    context: context,
  );
}

void _showOK(BuildContext context, String value) {
  // ignore: prefer_const_constructors
  final snack = SnackBar(
    content: Text(
      value,
      style: const TextStyle(fontSize: 14),
      textAlign: TextAlign.center,
    ),
    backgroundColor: const Color.fromARGB(255, 45, 107, 49),
    duration: const Duration(seconds: 2),

    // shape: const StadiumBorder(),
  );
  ScaffoldMessenger.of(context).showSnackBar(snack);
}
