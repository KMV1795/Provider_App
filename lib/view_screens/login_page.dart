import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:geolocator/geolocator.dart';
import 'package:provider/provider.dart';
import 'package:provider_app/view_screens/qr_page.dart';
import '../Model/login_model.dart';
import '../Services/common_services.dart';
import '../Services/login_details_service.dart';
import '../Services/login_provider.dart';
import '../Utils/colors.dart';
import '../widgets/const_widgets.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController _phoneNumberController = TextEditingController();
  final TextEditingController _smsCodeController = TextEditingController();

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  bool isLoading = false;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final LoginProvider loginProvider = Provider.of<LoginProvider>(context);

    return Scaffold(
      backgroundColor: primary,
      body: Stack(
        children: [
          /* Circle at the top right corner */
          const PositionedContainer(),
          /* Login Details Widget */
          Form(
            key: _formKey,
            child: Container(
              height: MediaQuery.of(context).size.height,
              width: MediaQuery.of(context).size.width,
              margin: const EdgeInsets.only(top: 100),
              decoration: const BoxDecoration(
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(30),
                  topRight: Radius.circular(30),
                ),
                color: Colors.black87,
              ),
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    Container(
                      margin: const EdgeInsets.only(top: 100, bottom: 20),
                      padding: const EdgeInsets.symmetric(
                          vertical: 10, horizontal: 30),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          inputName("Phone Number"),
                          const SizedBox(height: 20),
                          phoneFieldWidget(_phoneNumberController),
                          const SizedBox(height: 20),
                          IconButton(
                              onPressed: () async {
                                await loginProvider.verifyPhoneNumber(
                                    _phoneNumberController.text);
                              },
                              icon: const Icon(
                                Icons.check_circle,
                                color: textColor,
                              )),
                          const SizedBox(height: 20),
                          inputName("OTP"),
                          const SizedBox(height: 20),
                          otpFieldWidget(_smsCodeController),
                        ],
                      ),
                    ),
                    const SizedBox(height: 50),
                    ActionButton(
                      callback: () async {
                        // await loginProvider
                        //     .signInWithPhoneNumber(_smsCodeController.text);
                        // if (loginProvider.loggedIn == true) {
                        // ignore: use_build_context_synchronously
                        loginUser(context);
                        // } else {
                        //   if (kDebugMode) {
                        //     print("User====>user is null");
                        //   }
                        // }
                      },
                      actionName: 'LOGIN',
                    ),
                  ],
                ),
              ),
            ),
          ),
          /* Title Widget */
          const TitleWidget(
            title: 'LOGIN',
          ),
        ],
      ),
    );
  }

  // Phone Number TextField

  Widget phoneFieldWidget(TextEditingController controller) {
    return TextFormField(
      controller: controller,
      keyboardType: TextInputType.phone,
      maxLength: 10,
      style: const TextStyle(color: Colors.white),
      decoration: InputDecoration(
        focusedBorder: OutlineInputBorder(
          borderSide: const BorderSide(color: Colors.black87),
          borderRadius: BorderRadius.circular(10),
        ),
        enabledBorder: UnderlineInputBorder(
          borderSide: const BorderSide(color: Colors.black87),
          borderRadius: BorderRadius.circular(10),
        ),
        filled: true,
        fillColor: primary,
        labelText: 'Enter Phone Number',
        labelStyle: const TextStyle(color: textColor),
      ),
    );
  }

  // OTP TextField

  Widget otpFieldWidget(TextEditingController controller) {
    return TextFormField(
      controller: controller,
      keyboardType: TextInputType.number,
      inputFormatters: <TextInputFormatter>[
        FilteringTextInputFormatter.digitsOnly,
      ],
      obscureText: true,
      style: const TextStyle(color: Colors.white),
      decoration: InputDecoration(
        focusedBorder: OutlineInputBorder(
          borderSide: const BorderSide(color: Colors.black87),
          borderRadius: BorderRadius.circular(10),
        ),
        enabledBorder: UnderlineInputBorder(
          borderSide: const BorderSide(color: Colors.black87),
          borderRadius: BorderRadius.circular(10),
        ),
        filled: true,
        fillColor: primary,
        labelText: 'Enter OTP',
        labelStyle: const TextStyle(color: textColor),
      ),
    );
  }

  // Login Funtion after verification

  loginUser(BuildContext context) async {
    if (_phoneNumberController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text("Enter PhoneNumber to Verify"),
      ));
    } else if (_smsCodeController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text("Enter OTP to Login"),
      ));
    } else {
      String loginTime = CommonService().getLoginTime();
      String loginDate = CommonService().getLoginDate();
      Position position;
      position = await CommonService().getLocation();
      String location = await CommonService().getAddressFromLatLong(position);
      String ipAddress = await CommonService().getIpAddress();

      final loginModel = LoginModel(
        time: loginTime,
        date: loginDate,
        ip: ipAddress,
        location: location,
        url: "",
      );
      // ignore: use_build_context_synchronously
      bool result = await UserService().saveUserDetails(loginModel, context);
      return result == true
          ?
          // ignore: use_build_context_synchronously
          Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => QrPage(
                  loginTime: loginTime,
                  loginDate: loginDate,
                  location: location,
                  ip: ipAddress,
                ),
              ),
            )
          : null;
    }
  }
}
