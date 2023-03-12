import 'package:flutter/material.dart';
import '../Model/login_model.dart';
import '../Services/login_details_service.dart';
import '../Utils/colors.dart';
import '../widgets/const_widgets.dart';

class LoginDetails extends StatefulWidget {
  const LoginDetails({Key? key}) : super(key: key);

  @override
  State<LoginDetails> createState() => _LoginDetailsState();
}

class _LoginDetailsState extends State<LoginDetails> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: primary,
      body: Stack(
        children: [
          /* Circle at the top right corner */
          const PositionedContainer(),
          /* Tabs */
          Container(
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
            child: DefaultTabController(
              length: 3,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    margin: const EdgeInsets.only(top: 30),
                    child: const TabBar(
                      indicatorSize: TabBarIndicatorSize.label,
                      labelStyle: TextStyle(color: Colors.white70),
                      indicator: UnderlineTabIndicator(
                        borderSide: BorderSide(
                          width: 4,
                          color: textColor,
                        ),
                      ),
                      tabs: [
                        Tab(
                          text: "TODAY",
                        ),
                        Tab(
                          text: "YESTERDAY",
                        ),
                        Tab(
                          text: "OTHERS",
                        ),
                      ],
                    ),
                  ),
                  Container(
                    height: MediaQuery.of(context).size.height * 0.72,
                    width: MediaQuery.of(context).size.width,
                    margin: const EdgeInsets.only(
                        top: 05, bottom: 10, left: 10, right: 10),
                    child: TabBarView(
                      children: [
                        todayList(),
                        yesterDayList(),
                        otherList(),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          /* Title Widget */
          const TitleWidget(
            title: 'LAST LOGIN',
          ),
          Container(
            margin: const EdgeInsets.only(top: 30),
            padding:
                const EdgeInsets.only(left: 10, right: 10, top: 02, bottom: 05),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                IconButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    icon: const Icon(
                      Icons.arrow_back_ios_sharp,
                      color: textColor,
                    )),
                TextButton(
                  onPressed: () {},
                  child: const Text(
                    "LOGOUT",
                    style: TextStyle(
                        color: textColor,
                        fontSize: 20,
                        fontWeight: FontWeight.w500),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget todayList() {
    return StreamBuilder<List<LoginModel>>(
        stream: UserService().todayLogin(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Center(
              child: Text("Something went wrong ${snapshot.hasError}"),
            );
          } else if (snapshot.hasData) {
            final loginModel = snapshot.data!;
            return ListView.builder(
              itemCount: loginModel.length,
              itemBuilder: (context, index) {
                final data = loginModel[index];
                return Container(
                  padding:
                      const EdgeInsets.symmetric(vertical: 05, horizontal: 05),
                  child: Stack(
                    children: [
                      Container(
                        height: 80,
                        width: MediaQuery.of(context).size.width,
                        margin: const EdgeInsets.only(top: 25),
                        padding: const EdgeInsets.only(
                            left: 10, top: 10, bottom: 10),
                        decoration: const BoxDecoration(
                          borderRadius: BorderRadius.all(Radius.circular(10)),
                          color: actionBox,
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              data.time,
                              style: const TextStyle(color: textColor),
                            ),
                            const Spacer(),
                            Text(
                              "IP: ${data.ip}",
                              style: const TextStyle(color: textColor),
                            ),
                            const Spacer(),
                            Text(
                              data.location.toUpperCase(),
                              style: const TextStyle(color: textColor),
                            ),
                          ],
                        ),
                      ),
                      data.url!.isNotEmpty
                          ? Align(
                              alignment: Alignment.topRight,
                              child: Container(
                                height: 100,
                                width: 100,
                                padding:
                                    const EdgeInsets.only(top: 30, bottom: 05),
                                decoration: const BoxDecoration(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(05)),
                                  color: Colors.white,
                                ),
                                child: Center(
                                    child: Image(
                                  image: NetworkImage(
                                    data.url.toString(),
                                  ),
                                )),
                              ),
                            )
                          : Container(),
                    ],
                  ),
                );
              },
            );
          } else {
            return const Center(child: CircularProgressIndicator());
          }
        });
  }

  Widget yesterDayList() {
    return StreamBuilder<List<LoginModel>>(
        stream: UserService().preLogin(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Center(
              child: Text("Something went wrong ${snapshot.hasError}"),
            );
          } else if (snapshot.hasData) {
            final loginModel = snapshot.data!;
            return ListView.builder(
              itemCount: loginModel.length,
              itemBuilder: (context, index) {
                final data = loginModel[index];
                return Container(
                  padding:
                      const EdgeInsets.symmetric(vertical: 05, horizontal: 05),
                  child: Stack(
                    children: [
                      Container(
                        height: 80,
                        width: MediaQuery.of(context).size.width,
                        margin: const EdgeInsets.only(top: 25),
                        padding: const EdgeInsets.only(
                            left: 10, top: 10, bottom: 10),
                        decoration: const BoxDecoration(
                          borderRadius: BorderRadius.all(Radius.circular(10)),
                          color: actionBox,
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              data.time,
                              style: const TextStyle(color: textColor),
                            ),
                            const Spacer(),
                            Text(
                              "IP: ${data.ip}",
                              style: const TextStyle(color: textColor),
                            ),
                            const Spacer(),
                            Text(
                              data.location.toUpperCase(),
                              style: const TextStyle(color: textColor),
                            ),
                          ],
                        ),
                      ),
                      data.url!.isNotEmpty
                          ? Align(
                              alignment: Alignment.topRight,
                              child: Container(
                                height: 100,
                                width: 100,
                                padding:
                                    const EdgeInsets.only(top: 30, bottom: 05),
                                decoration: const BoxDecoration(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(05)),
                                  color: Colors.white,
                                ),
                                child: Center(
                                    child: Image(
                                  image: NetworkImage(
                                    data.url.toString(),
                                  ),
                                )),
                              ),
                            )
                          : Container(),
                    ],
                  ),
                );
              },
            );
          } else {
            return const Center(child: CircularProgressIndicator());
          }
        });
  }

  Widget otherList() {
    return StreamBuilder<List<LoginModel>>(
        stream: UserService().otherLogin(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Center(
              child: Text("Something went wrong ${snapshot.hasError}"),
            );
          } else if (snapshot.hasData) {
            final loginModel = snapshot.data!;
            return ListView.builder(
              itemCount: loginModel.length,
              itemBuilder: (context, index) {
                final data = loginModel[index];
                return Container(
                  padding:
                      const EdgeInsets.symmetric(vertical: 05, horizontal: 05),
                  child: Stack(
                    children: [
                      Container(
                        height: 80,
                        width: MediaQuery.of(context).size.width,
                        margin: const EdgeInsets.only(top: 25),
                        padding: const EdgeInsets.only(
                            left: 10, top: 10, bottom: 10),
                        decoration: const BoxDecoration(
                          borderRadius: BorderRadius.all(Radius.circular(10)),
                          color: actionBox,
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              data.time,
                              style: const TextStyle(color: textColor),
                            ),
                            const Spacer(),
                            Text(
                              "IP: ${data.ip}",
                              style: const TextStyle(color: textColor),
                            ),
                            const Spacer(),
                            Text(
                              data.location.toUpperCase(),
                              style: const TextStyle(color: textColor),
                            ),
                          ],
                        ),
                      ),
                      data.url!.isNotEmpty
                          ? Align(
                              alignment: Alignment.topRight,
                              child: Container(
                                height: 100,
                                width: 100,
                                padding:
                                    const EdgeInsets.only(top: 30, bottom: 05),
                                decoration: const BoxDecoration(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(05)),
                                  color: Colors.white,
                                ),
                                child: Center(
                                    child: Image(
                                  image: NetworkImage(
                                    data.url.toString(),
                                  ),
                                )),
                              ),
                            )
                          : Container(),
                    ],
                  ),
                );
              },
            );
          } else {
            return const Center(child: CircularProgressIndicator());
          }
        });
  }
}
