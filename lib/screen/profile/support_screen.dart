import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class SupportUser extends StatefulWidget {
  const SupportUser({Key? key}) : super(key: key);

  @override
  _SupportUserState createState() => _SupportUserState();
}

class _SupportUserState extends State<SupportUser> {
  CollectionReference getfaUser =
      FirebaseFirestore.instance.collection('users');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 27, 27, 27),
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 23, 35, 39),
        title: const Center(
          child: Text(
            "Trung tâm hỗ trợ     ",
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.fromLTRB(15, 20, 15, 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Khi sử dụng ứng dụng này người sử dụng chấp thuận'
              ' và đồng ý với việc có thể gặp một số rủi'
              ' ro và đồng ý rằng Fire Movie cũng như các bên liên kết '
              ' chịu trách nhiệm xây dựng dịch vụ ứng dụng này sẽ không'
              ' chịu trách nhiệm pháp lý cho bất cứ thiệt hại nào đối với'
              ' với người sử dụng dù là trực tiếp, đặc biệt, ngẫu nhiên, hậu'
              ' quả để lại, bị phạt hay bất kỳ mất mát, phí tổn hoặc chi phí'
              ' có thể phát sinh trực tiếp hay gián tiếp qua việc sử dụng hoặc'
              ' chuyển tải dữ liệu từ ứng dụng này, bao gồm nhưng không giới hạn'
              ' bởi tất cả những ảnh hưởng do mã độc, virus,… tác động hoặc không'
              ' tác động đến thiết bị của người sử dụng như hệ thống mạng, máy tính'
              ' và các thiết bị di động.',
              style: TextStyle(color: Colors.white70),
            ),
            const SizedBox(
              height: 8,
            ),
            const Text(
              'Mọi nhu cầu hỗ trợ liên hệ:',
              style: TextStyle(color: Colors.white70),
            ),
            const SizedBox(
              height: 8,
            ),
            ElevatedButton(
              onPressed: () async {
                final url = Uri.parse('tel:+84 921 580 490');
                if (await canLaunchUrl(url)) {
                  await launchUrl(url);
                } else {
                  throw 'Could not launch $url';
                }
              },
              child: const Text('+84 921 580 490'),
            ),
            ElevatedButton(
                onPressed: () async {
                  final url = Uri.parse(
                      'mailto:datvo0999@gmail.com?subject=Hỗ Trợ Fire Movie&body=Nội dung hỗ trợ');
                  if (await canLaunchUrl(url)) {
                    await launchUrl(url);
                  } else {
                    throw 'Could not launch $url';
                  }
                },
                child: const Text('datvo0999@gmail.com')),
          ],
        ),
      ),
    );
  }
}
