import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:provider_app/Services/auth_provider.dart';
import 'package:qr_flutter/qr_flutter.dart';
import '../Model/login_model.dart';
import '../Services/common_services.dart';
import '../Services/login_details_service.dart';
import '../Services/qr_storage_service.dart';
import '../Utils/colors.dart';
import '../Utils/utils.dart';
import '../widgets/const_widgets.dart';
import 'login_details_page.dart';
import 'login_screen.dart';

class QrPage extends StatefulWidget {
  final String? loginTime;
  final String? loginDate;
  final String? location;
  final String? ip;
  const QrPage({
    Key? key,
    required this.loginTime,
    required this.loginDate,
    required this.location,
    required this.ip,
  }) : super(key: key);

  @override
  State<QrPage> createState() => _QrPageState();
}

class _QrPageState extends State<QrPage> {
  late String loginTime;
  late String loginDate;
  late String location;
  late String ip;

  String randomNum = '';

  @override
  void initState() {
    randomNum = CommonService().randomAlphaNum();
    loginTime = widget.loginTime!;
    loginDate = widget.loginDate!;
    location = widget.location!;
    ip = widget.ip!;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: primary,
      body: Stack(
        children: [
          /* Circle at the top right corner */
          const PositionedContainer(),
          /* Random Qr generation with Save Button */
          Container(
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
            margin: const EdgeInsets.only(
              top: 100,
            ),
            decoration: const BoxDecoration(
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(30),
                topRight: Radius.circular(30),
              ),
              color: Colors.black87,
            ),
            child: Stack(
              children: [
                /* Save Button */
                Container(
                  margin: const EdgeInsets.only(bottom: 20),
                  child: ActionButton(
                    callback: () async {
                      await loginUser(context);
                    },
                    actionName: 'SAVE',
                  ),
                ),
                /* Last Login Time */
                Align(
                  alignment: Alignment.bottomCenter,
                  child: Container(
                    height: 60,
                    width: 280,
                    margin: const EdgeInsets.only(bottom: 100),
                    decoration: BoxDecoration(
                      borderRadius: const BorderRadius.all(
                        Radius.circular(15),
                      ),
                      border: Border.all(
                        color: textColor,
                      ),
                    ),
                    child: Center(
                      child: Text(
                        "Last Login Today, $loginTime",
                        style: const TextStyle(
                            color: textColor,
                            fontWeight: FontWeight.normal,
                            fontSize: 20),
                      ),
                    ),
                  ),
                ),
                /* Image at the Center */
                const ImageContainer(),
                /* Qr Image */
                Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Container(
                      height: 200,
                      width: 200,
                      margin: const EdgeInsets.only(top: 100, left: 70),
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        borderRadius: const BorderRadius.all(
                          Radius.circular(15),
                        ),
                        color: Colors.white.withOpacity(0.7),
                      ),
                      child: Center(
                        child: SizedBox(
                          height: 200,
                          width: 200,
                          child: QrImage(
                            data: randomNum,
                            version: QrVersions.auto,
                            size: 220.0,
                          ),
                        ),
                      ),
                    ),
                    Container(
                      margin: const EdgeInsets.all(18),
                      padding: const EdgeInsets.only(
                        left: 60,
                      ),
                      child: const Text(
                        "Generated Number",
                        style: TextStyle(
                            color: textColor,
                            fontWeight: FontWeight.normal,
                            fontSize: 23),
                      ),
                    ),
                    Container(
                      margin: const EdgeInsets.all(13),
                      padding: const EdgeInsets.only(
                        left: 60,
                      ),
                      child: Text(
                        randomNum,
                        style: const TextStyle(
                            color: textColor,
                            fontWeight: FontWeight.normal,
                            fontSize: 30),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          /* Title Widget */
          const TitleWidget(
            title: 'PLUGIN',
          ),
          /* Logout Button */
          LogoutButton(
            callback: () {
              final auth = Provider.of<AuthProvider>(context, listen: false);
              auth.userSignOut(context).whenComplete(() => Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const LoginScreen(),
                    ),
                  ));
            },
          ),
        ],
      ),
    );
  }

  // Login Funtion after verification

  loginUser(BuildContext context) async {
    String url = await QrStorageService()
        .covertQrtoImage(randomNum, loginDate, loginTime);

    final loginModel = LoginModel(
      time: loginTime,
      date: loginDate,
      ip: ip,
      location: location,
      url: url,
    );
    // ignore: use_build_context_synchronously
    bool result = await UserService().saveUserDetails(loginModel, context);
    result == true
        ?
        // ignore: use_build_context_synchronously
        showSnackBar(context, "Login Details saved Successfully")
        // ignore: use_build_context_synchronously
        : showSnackBar(context, "Login Details not saved");
    return result == true
        ?
        // ignore: use_build_context_synchronously
        Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const LoginDetails(),
            ),
          )
        // ignore: use_build_context_synchronously
        : false;
  }
}
