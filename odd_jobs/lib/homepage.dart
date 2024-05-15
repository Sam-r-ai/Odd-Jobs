import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'jobviewpage.dart';

class HomePageWidget extends StatefulWidget {
  const HomePageWidget({super.key});

  @override
  State<HomePageWidget> createState() => _HomePageWidgetState();
}

class _HomePageWidgetState extends State<HomePageWidget> {
  final scaffoldKey = GlobalKey<ScaffoldState>();
  TextEditingController? _searchBarTextController;
  FocusNode? _searchBarFocusNode;
  double? _expDistSliderValue = 1.0;

  @override
  void initState() {
    super.initState();
    _searchBarTextController = TextEditingController();
    _searchBarFocusNode = FocusNode();
  }

  @override
  void dispose() {
    _searchBarTextController?.dispose();
    _searchBarFocusNode?.dispose();
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
        backgroundColor: Colors.white,
        drawer: Drawer(
          elevation: 16,
          child: Column(
            mainAxisSize: MainAxisSize.max,
            children: [
              Container(
                width: 306,
                height: 116,
                decoration: const BoxDecoration(
                  color: Color(0xFF4B39EF),
                  boxShadow: [
                    BoxShadow(
                      blurRadius: 8,
                      color: Color(0x33000000),
                      offset: Offset(0, 2),
                    )
                  ],
                ),
                child: Center(
                  child: Text(
                    'Filters',
                    style: TextStyle(
                      fontFamily: 'Readex Pro',
                      color: Theme.of(context).primaryTextTheme.bodyLarge!.color,
                      fontSize: 23,
                    ),
                  ),
                ),
              ),
              Container(
                width: MediaQuery.of(context).size.width,
                height: 50,
                color: Colors.grey,
                child: const Center(child: Text('Ad Banner Placeholder')),
              ),
              const Padding(
                padding: EdgeInsetsDirectional.fromSTEB(0, 16, 0, 8),
                child: Text(
                  'Pay Range',
                  style: TextStyle(
                    fontFamily: 'Readex Pro',
                    fontSize: 18,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsetsDirectional.fromSTEB(0, 8, 0, 0),
                child: Container(
                  width: 155,
                  height: 51,
                  decoration: BoxDecoration(
                    color: const Color(0xFF39D28A),
                    boxShadow: const [
                      BoxShadow(
                        blurRadius: 4,
                        color: Color(0x33000000),
                        offset: Offset(0, 2),
                      )
                    ],
                    borderRadius: BorderRadius.circular(24),
                  ),
                  child: const Center(
                    child: Text(
                      'Easy: 15 to 50\$',
                      style: TextStyle(
                        fontFamily: 'Readex Pro',
                      ),
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsetsDirectional.fromSTEB(0, 10, 0, 2),
                child: Container(
                  width: 155,
                  height: 51,
                  decoration: BoxDecoration(
                    color: const Color(0xFFD8E74A),
                    boxShadow: const [
                      BoxShadow(
                        blurRadius: 4,
                        color: Color(0x33000000),
                        offset: Offset(0, 2),
                      )
                    ],
                    borderRadius: BorderRadius.circular(24),
                  ),
                  child: const Center(
                    child: Text(
                      'Medium: 50 to 250\$',
                      style: TextStyle(
                        fontFamily: 'Readex Pro',
                      ),
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsetsDirectional.fromSTEB(0, 8, 0, 0),
                child: Container(
                  width: 155,
                  height: 51,
                  decoration: BoxDecoration(
                    color: const Color(0xFFD25139),
                    boxShadow: const [
                      BoxShadow(
                        blurRadius: 4,
                        color: Color(0x33000000),
                        offset: Offset(0, 2),
                      )
                    ],
                    borderRadius: BorderRadius.circular(24),
                  ),
                  child: const Center(
                    child: Text(
                      'Big Boy Jobs \$\$\$',
                      style: TextStyle(
                        fontFamily: 'Readex Pro',
                      ),
                    ),
                  ),
                ),
              ),
              const Padding(
                padding: EdgeInsetsDirectional.fromSTEB(0, 16, 0, 8),
                child: Text(
                  'Location',
                  style: TextStyle(
                    fontFamily: 'Readex Pro',
                    fontSize: 18,
                  ),
                ),
              ),
              ElevatedButton.icon(
                onPressed: () {
                  // Implement your location picker here
                },
                icon: const Icon(Icons.place),
                label: const Text('Select Location'),
              ),
              const Padding(
                padding: EdgeInsetsDirectional.fromSTEB(0, 16, 0, 8),
                child: Text(
                  'Distance',
                  style: TextStyle(
                    fontFamily: 'Readex Pro',
                    fontSize: 18,
                  ),
                ),
              ),
              Slider(
                activeColor: Theme.of(context).primaryColor,
                inactiveColor: Theme.of(context).disabledColor,
                min: 1,
                max: 100,
                value: _expDistSliderValue!,
                onChanged: (newValue) {
                  setState(() {
                    _expDistSliderValue = newValue;
                  });
                },
              ),
              Text(
                'Distance: ${_expDistSliderValue!.toInt()} miles',
                style: const TextStyle(
                  fontFamily: 'Readex Pro',
                ),
              ),
            ],
          ),
        ),
        body: SafeArea(
          top: true,
          child: Column(
            mainAxisSize: MainAxisSize.max,
            children: [
              Row(
                mainAxisSize: MainAxisSize.max,
                children: [
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsetsDirectional.fromSTEB(8, 0, 8, 0),
                      child: TextFormField(
                        controller: _searchBarTextController,
                        focusNode: _searchBarFocusNode,
                        decoration: InputDecoration(
                          labelText: 'Search Here',
                          labelStyle: const TextStyle(
                            fontFamily: 'Readex Pro',
                          ),
                          hintStyle: const TextStyle(
                            fontFamily: 'Readex Pro',
                          ),
                          enabledBorder: UnderlineInputBorder(
                            borderSide: BorderSide(
                              color: Theme.of(context).disabledColor,
                              width: 2,
                            ),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          focusedBorder: UnderlineInputBorder(
                            borderSide: BorderSide(
                              color: Theme.of(context).primaryColor,
                              width: 2,
                            ),
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        style: const TextStyle(
                          fontFamily: 'Readex Pro',
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(4),
                    child: IconButton(
                      icon: Icon(
                        Icons.location_on_sharp,
                        color: Theme.of(context).primaryColor,
                        size: 24,
                      ),
                      onPressed: () {
                        scaffoldKey.currentState!.openDrawer();
                      },
                    ),
                  ),
                ],
              ),
              const Padding(
                padding: EdgeInsetsDirectional.fromSTEB(8, 4, 8, 0),
                child: Row(
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    Text(
                      'Current Location',
                      style: TextStyle(
                        fontFamily: 'Readex Pro',
                        fontSize: 13,
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(4),
                  child: StreamBuilder<QuerySnapshot>(
                    stream: FirebaseFirestore.instance.collection('Jobs').snapshots(),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const Center(child: CircularProgressIndicator());
                      }
                      if (snapshot.hasError) {
                        return const Center(child: Text('Error fetching jobs'));
                      }

                      final jobs = snapshot.data!.docs;

                      return GridView.builder(
                        padding: EdgeInsets.zero,
                        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          crossAxisSpacing: 8,
                          mainAxisSpacing: 8,
                          childAspectRatio: 1,
                        ),
                        itemCount: jobs.length,
                        itemBuilder: (context, index) {
                          final job = jobs[index].data() as Map<String, dynamic>;
                          return InkWell(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => JobViewPage(
                                    jobTitle: job['JobTitle'] ?? 'Job Title',
                                    imageUrl: job['Image'] ?? 'https://picsum.photos/seed/708/600',
                                    description: job['Description'] ?? 'Description',
                                    pay: job['Pay'] ?? 'Pay',
                                  ),
                                ),
                              );
                            },
                            child: Card(
                              clipBehavior: Clip.antiAliasWithSaveLayer,
                              color: Theme.of(context).cardColor,
                              elevation: 4,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Column(
                                mainAxisSize: MainAxisSize.max,
                                children: [
                                  Padding(
                                    padding: const EdgeInsetsDirectional.fromSTEB(0, 4, 0, 0),
                                    child: Container(
                                      width: double.infinity,
                                      height: 25,
                                      decoration: BoxDecoration(
                                        color: Theme.of(context).cardColor,
                                      ),
                                      child: Center(
                                        child: Text(
                                          job['JobTitle'] ?? 'Job Title',
                                          style: const TextStyle(
                                            fontFamily: 'Readex Pro',
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                  Container(
                                    width: 138,
                                    height: 108,
                                    decoration: BoxDecoration(
                                      color: Theme.of(context).cardColor,
                                    ),
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(8),
                                      child: Image.network(
                                        job['Image'] ?? 'https://picsum.photos/seed/708/600',
                                        width: 339,
                                        height: 205,
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsetsDirectional.fromSTEB(0, 8, 0, 0),
                                    child: Text(
                                      job['Pay'] ?? 'Pay',
                                      style: const TextStyle(
                                        fontFamily: 'Readex Pro',
                                      ),
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
              ),
            ],
          ),
        ),
      ),
    );
  }
}

