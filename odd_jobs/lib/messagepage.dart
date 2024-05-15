// Jyant Productions
// Justin Cheung
// Bryant Hernandez
// CSCI 467 Final Project
// OddJobs

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'sendmsgpage.dart'; 

class MessagePageWidget extends StatefulWidget {
  const MessagePageWidget({super.key});

  @override
  State<MessagePageWidget> createState() => _MessagePageWidgetState();
}

class _MessagePageWidgetState extends State<MessagePageWidget> {
  final scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
        key: scaffoldKey,
        backgroundColor: Theme.of(context).primaryColorLight,
        body: SafeArea(
          top: true,
          child: Column(
            mainAxisSize: MainAxisSize.max,
            children: [
              Align(
                alignment: const AlignmentDirectional(0, -1),
                child: Padding(
                  padding: const EdgeInsets.all(6),
                  child: Text(
                    'Messages',
                    textAlign: TextAlign.start,
                    style: GoogleFonts.readexPro(
                      fontSize: 18,
                    ),
                  ),
                ),
              ),
              Expanded(
                child: StreamBuilder<QuerySnapshot>(
                  stream: FirebaseFirestore.instance.collection('profiles').snapshots(),
                  builder: (context, snapshot) {
                    if (!snapshot.hasData) {
                      return const Center(
                        child: CircularProgressIndicator(),
                      );
                    }
                    var profiles = snapshot.data!.docs;
                    return ListView.builder(
                      padding: EdgeInsets.zero,
                      itemCount: profiles.length,
                      itemBuilder: (context, index) {
                        var profile = profiles[index];
                        var firstName = profile['First name'] ?? 'First name';
                        var lastName = profile['Last name'] ?? 'Last name';
                        var bio = profile['Bio'] ?? 'No bio available';
                        var profilePictureURL = profile['ProfilePictureURL'] ?? 'https://via.placeholder.com/150';

                        return InkWell(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => SendMsgPage(
                                  chatId: profile.id,
                                  contactName: '$firstName $lastName',
                                ),
                              ),
                            );
                          },
                          child: Container(
                            width: double.infinity,
                            height: 100,
                            decoration: BoxDecoration(
                              color: Theme.of(context).cardColor,
                              boxShadow: const [
                                BoxShadow(
                                  blurRadius: 4,
                                  color: Color(0x33000000),
                                  offset: Offset(0, 2),
                                ),
                              ],
                            ),
                            child: Row(
                              children: [
                                Container(
                                  width: 80,
                                  height: 80,
                                  margin: const EdgeInsets.all(10),
                                  clipBehavior: Clip.antiAlias,
                                  decoration: const BoxDecoration(
                                    shape: BoxShape.circle,
                                  ),
                                  child: Image.network(
                                    profilePictureURL,
                                    fit: BoxFit.cover,
                                  ),
                                ),
                                Expanded(
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        '$firstName $lastName',
                                        style: GoogleFonts.readexPro(),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.only(top: 8),
                                        child: Text(
                                          bio,
                                          style: GoogleFonts.readexPro(),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
