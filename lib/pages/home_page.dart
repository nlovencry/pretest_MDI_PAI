import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pretest_mdi_pai/data/user_list.dart';
import 'package:pretest_mdi_pai/pages/detail_page.dart';
import 'package:pretest_mdi_pai/pages/login_page.dart';
import 'package:pretest_mdi_pai/service/user_preferences.dart';
import '../api/api.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);
  static const routeName = 'home';

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late Future<List<UserList>> _users;
  final limitController = TextEditingController();
  final queryController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _users = Api().searchUser(query: "");
  }

  @override
  Widget build(BuildContext context) {
    logout() {
      UserPreferrences().removeUser(); // <- navigasi ke halaman awal
      Navigator.pushReplacementNamed(context, LoginPage.routeName);
    }

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue,
        title: Row(
          children: [
            Expanded(
              child: ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: Container(
                  width: double.infinity,
                  height: 40,
                  alignment: Alignment.bottomCenter,
                  color: Colors.grey.withOpacity(0.2),
                  child: Center(
                    child: TextField(
                      cursorColor: Colors.white,
                      controller: queryController,
                      // menampilkan data search
                      onChanged: (query) {
                        setState(() {
                          // menampilkan seluruh data
                          if (limitController.text.isEmpty) {
                            _users = Api().searchUser(query: query);
                          } else {
                            // menampilkan data yang dilimit
                            final limit = limitController == ""
                                ? 100
                                : int.parse(limitController.text);
                            _users = Api().searchUser(
                                query: queryController.text, limit: limit);
                          }
                        });
                      },
                      decoration: const InputDecoration(
                        hintText: 'Search',
                        hintStyle: TextStyle(color: Colors.black),
                        prefixIcon: Icon(
                          Icons.search_outlined,
                          color: Colors.black,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
            IconButton(
              onPressed: () {
                showDialog(
                    context: context,
                    builder: (context) {
                      return Dialog(
                        child: Container(
                          width: 200,
                          padding: const EdgeInsets.symmetric(
                            horizontal: 48,
                            vertical: 24,
                          ),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const Text(
                                "Masukan Limit Data:",
                                style: TextStyle(
                                  fontSize: 16,
                                ),
                              ),
                              TextField(
                                // controller limit data
                                controller: limitController,
                                textAlign: TextAlign.center,
                                keyboardType: TextInputType.number,
                              ),
                              const SizedBox(
                                height: 8,
                              ),
                              ClipRRect(
                                borderRadius: BorderRadius.circular(10),
                                child: SizedBox(
                                  width: double.infinity,
                                  height: 40,
                                  child: MaterialButton(
                                    onPressed: () {
                                      setState(() {
                                        // menampilkan seluruh data
                                        if (limitController.text.isEmpty) {
                                          final query = queryController.text;
                                          _users = Api().searchUser(query: query);
                                        } else {
                                          // menampilkan data yang dilimit
                                          final limit = limitController == ""
                                              ? 100
                                              : int.parse(limitController.text);
                                          _users = Api().searchUser(
                                              query: queryController.text,
                                              limit: limit);
                                        }
                                      });

                                      print(limitController.text);
                                      Navigator.pop(context);
                                    },
                                    color: Colors.blue,
                                    child: Text(
                                      "Submit",
                                      style: GoogleFonts.poppins(
                                        color: Colors.white,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ),
                                ),
                              )
                            ],
                          ),
                        ),
                      );
                    });
              },
              icon: const Icon(
                Icons.filter_list,
                size: 30,
                color: Colors.black,
              ),
            ),
            SizedBox(
              width: 36,
              child: IconButton(
                  onPressed: () {
                    showDialog(
                        context: context,
                        builder: (context) {
                          return ClipRRect(
                            borderRadius: BorderRadius.circular(30),
                            child: Dialog(
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(30),
                                child: Container(
                                  width: 150,
                                  height: 150,
                                  padding: const EdgeInsets.all(12.0),
                                  child: Column(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceAround,
                                    children: [
                                       Text(
                                        "Apakah kamu mau keluar?",
                                        style: GoogleFonts.poppins(
                                          fontWeight: FontWeight.w500,
                                          color: Colors.black87,
                                          fontSize: 16,
                                        ),
                                      ),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceEvenly,
                                        children: [
                                          MaterialButton(
                                            onPressed: () {
                                              Navigator.pop(context);
                                              logout();
                                            },
                                            splashColor: Colors.black,
                                            color: Colors.blue,
                                            child: Text(
                                              "Yes",
                                              style: GoogleFonts.poppins(
                                                color: Colors.white,
                                                fontWeight: FontWeight.w600,
                                              ),
                                            ),
                                          ),
                                          MaterialButton(
                                            onPressed: () {
                                              Navigator.pop(context);
                                            },
                                            splashColor: Colors.blue,
                                            color: Colors.blueGrey,
                                            child: Text(
                                              "No",
                                              style: GoogleFonts.poppins(
                                                color: Colors.white,
                                                fontWeight: FontWeight.w600,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          );
                        });
                  },
                  icon: const Icon(
                    Icons.logout,
                    color: Colors.black,
                    size: 25,
                  )),
            )
          ],
        ),
      ),

      body: SafeArea(
        child: FutureBuilder(
          future: _users,
          builder: (context, snapshot) {
            if (snapshot.hasError) {
              return Center(
                child: Text(snapshot.error.toString()),
              );
            } else if (snapshot.hasData) {
              return Padding(
                padding: EdgeInsets.all(8.0),
                child: ListView.builder(
                    itemCount: snapshot.data!.length,
                    itemBuilder: (context, index) {
                      var data = snapshot.data![index];
                      return InkWell(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => DetailPage(userData: data),
                            ),
                          );
                        },
                        child: Column(
                          children: [
                            ListTile(
                              title: Text(
                                    "${data.firstName} ${data.lastName}",
                                    style: GoogleFonts.poppins(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),
                              subtitle: Text(
                                            data.email,
                                            overflow: TextOverflow.ellipsis,
                                            style: GoogleFonts.poppins(
                                              fontSize: 12,
                                            ),
                                          ),
                              leading: ClipRRect(
                                borderRadius: BorderRadius.circular(4),
                                child: Container(
                                  decoration: const BoxDecoration(
                                    shape: BoxShape.rectangle,
                                    color: Colors.blue,
                                  ),
                                  height: 70,
                                  width: 70,
                                  child: Image.network(
                                    data.image,
                                    filterQuality: FilterQuality.high,
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              ),
                              trailing: Text(
                                data.username,
                                overflow: TextOverflow.ellipsis,
                                style: GoogleFonts.poppins(
                                  fontSize: 12,
                                ),
                              ),
                              ),
                          ]

                        ),

                      );
                    }),
              );
            } else {
              return const Center(child: CircularProgressIndicator());
            }
          },
        ),
      ),

    );
  }
}
