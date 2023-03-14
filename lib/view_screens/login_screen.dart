import 'package:country_picker/country_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:provider_app/view_screens/qr_page.dart';
import '../Services/auth_provider.dart';
import '../Utils/colors.dart';
import '../Utils/utils.dart';
import '../widgets/const_widgets.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({
    Key? key,
  }) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _phoneNumberController = TextEditingController();
  final TextEditingController _smsCodeController = TextEditingController();

  String? otpCode;

  Country country = Country(
    phoneCode: "91",
    countryCode: "IN",
    e164Sc: 0,
    geographic: true,
    level: 1,
    name: "India",
    example: "India",
    displayName: "India",
    displayNameNoCountryCode: "IN",
    e164Key: "",
  );

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  bool isLoading = false;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    _phoneNumberController.selection = TextSelection.fromPosition(
      TextPosition(
        offset: _phoneNumberController.text.length,
      ),
    );
    final isLoading =
        Provider.of<AuthProvider>(context, listen: true).isLoading;

    // final LoginProvider loginProvider = Provider.of<LoginProvider>(context);

    return Scaffold(
      backgroundColor: primary,
      body: SafeArea(
        child: Stack(
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
                            TextFormField(
                              controller: _phoneNumberController,
                              keyboardType: TextInputType.phone,
                              maxLength: 10,
                              style: const TextStyle(color: Colors.white),
                              onChanged: (value) {
                                setState(() {
                                  _phoneNumberController.text = value;
                                });
                              },
                              decoration: InputDecoration(
                                focusedBorder: OutlineInputBorder(
                                  borderSide:
                                      const BorderSide(color: Colors.black87),
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                enabledBorder: UnderlineInputBorder(
                                  borderSide:
                                      const BorderSide(color: Colors.black87),
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                filled: true,
                                fillColor: primary,
                                labelText: 'Enter Phone Number',
                                labelStyle: const TextStyle(color: textColor),
                                prefixIcon: Container(
                                  padding: const EdgeInsets.all(8.0),
                                  child: InkWell(
                                    onTap: () {
                                      showCountryPicker(
                                          context: context,
                                          countryListTheme:
                                              const CountryListThemeData(
                                            bottomSheetHeight: 550,
                                          ),
                                          onSelect: (value) {
                                            setState(() {
                                              country = value;
                                            });
                                          });
                                    },
                                    child: Text(
                                      "${country.flagEmoji} + ${country.phoneCode}",
                                      style: const TextStyle(
                                        fontSize: 18,
                                        color: Colors.white70,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                ),
                                suffixIcon: _phoneNumberController.text.length >
                                        9
                                    ? InkWell(
                                        onTap: () {
                                          sendPhoneNumber();
                                        },
                                        child: Container(
                                          height: 30,
                                          width: 30,
                                          margin: const EdgeInsets.all(10.0),
                                          decoration: const BoxDecoration(
                                            shape: BoxShape.circle,
                                            color: Colors.white70,
                                          ),
                                          child: const Icon(
                                            Icons.done,
                                            color: Colors.green,
                                            size: 20,
                                          ),
                                        ),
                                      )
                                    : null,
                              ),
                            ),
                            const SizedBox(height: 20),
                            const SizedBox(height: 20),
                            inputName("OTP"),
                            const SizedBox(height: 20),
                            isLoading == true
                                ? const SizedBox(
                                    height: 50,
                                    width: 50,
                                    child: Center(
                                      child: CircularProgressIndicator(
                                        color: Colors.purple,
                                      ),
                                    ),
                                  )
                                : TextFormField(
                                    controller: _smsCodeController,
                                    keyboardType: TextInputType.number,
                                    inputFormatters: <TextInputFormatter>[
                                      FilteringTextInputFormatter.digitsOnly,
                                    ],
                                    obscureText: true,
                                    style: const TextStyle(color: Colors.white),
                                    onChanged: (value) {
                                      setState(() {
                                        otpCode = value;
                                      });
                                    },
                                    decoration: InputDecoration(
                                      focusedBorder: OutlineInputBorder(
                                        borderSide: const BorderSide(
                                            color: Colors.black87),
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                      enabledBorder: UnderlineInputBorder(
                                        borderSide: const BorderSide(
                                            color: Colors.black87),
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                      filled: true,
                                      fillColor: primary,
                                      labelText: 'Enter OTP',
                                      labelStyle:
                                          const TextStyle(color: textColor),
                                    ),
                                  ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 50),
                      ActionButton(
                        callback: () {
                          if (otpCode != null) {
                            verifyOtp(context, otpCode!);
                          } else {
                            showSnackBar(context, "Enter OTP Code");
                          }
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
      ),
    );
  }

  // Verify Phone Number
  void sendPhoneNumber() {
    final auth = Provider.of<AuthProvider>(context, listen: false);
    String phoneNumber = _phoneNumberController.text.trim();
    auth.signInWithPhone(context, "+${country.phoneCode}$phoneNumber");
  }

  // verify otp
  void verifyOtp(BuildContext context, String userOtp) {
    final auth = Provider.of<AuthProvider>(context, listen: false);
    auth.verifyOtp(
      context: context,
      userOtp: userOtp,
      onSuccess: () {
        // checking whether user exists in the db
        auth.checkExistingUser().then(
          (value) async {
            if (value == true) {
              // user exists in our app
              auth.getDataFromFirestore().then(
                    (value) => auth.saveUserDataToSP().then(
                          (value) => auth.setSignIn().then(
                                (value) => Navigator.pushAndRemoveUntil(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => const QrPage(
                                          loginTime: '',
                                          loginDate: '',
                                          location: '',
                                          ip: ''),
                                    ),
                                    (route) => false),
                              ),
                        ),
                  );
            } else {
              // new user
              Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (context) => const LoginScreen()),
                  (route) => false);
            }
          },
        );
      },
    );
  }
}
