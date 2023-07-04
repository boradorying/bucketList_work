import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'bucketService.dart';

void main() {
  runApp(MultiProvider(
    providers: [
      ChangeNotifierProvider(
        create: (context) => BucketService(),
      )
    ],
    child: MaterialApp(home: MyApp()),
  ));
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  var tab = 0;
  var inputData = TextEditingController();
  late AppBar appBarBucketList;
  late AppBar appBarCompleted;

  @override
  void initState() {
    super.initState();
    appBarBucketList = AppBar(
      title: Text('버킷리스트'),
      centerTitle: true,
      backgroundColor: Colors.transparent,
      flexibleSpace: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Colors.black26,
              Colors.white,
            ],
            begin: Alignment.centerLeft,
            end: Alignment.centerRight,
          ),
        ),
      ),
    );
    appBarCompleted = AppBar(
      title: Text('be completed!'),
      centerTitle: true,
      backgroundColor: Colors.transparent,
      flexibleSpace: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Colors.red.shade300,
              Colors.white,
            ],
            begin: Alignment.centerLeft,
            end: Alignment.centerRight,
          ),
        ),
      ),
    );
  }

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: tab == 0 ? appBarBucketList : appBarCompleted,
      body: tab == 0 ? BucketList() : CompletedPage(),
      bottomNavigationBar: BottomNavigationBar(
        onTap: (i) {
          setState(() {
            tab = i;
          });
        },
        currentIndex: tab,
        items: <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(
              Icons.list_alt,
            ),
            label: '리스트',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.shopping_bag),
            label: '완료한 것들',
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Color.fromARGB(255, 68, 65, 63),
        onPressed: () {
          showDialog(
            context: context,
            builder: (context) {
              return AlertDialog(
                title: Column(
                  children: [
                    Text('원하는 것을 입력하세요!'),
                    TextField(
                      controller: inputData,
                      decoration: InputDecoration(
                        labelText: "ex)해외여행 가기",
                        icon: Icon(Icons.star),
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide.none,
                        ),
                        filled: true,
                        fillColor: Colors.black12,
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        TextButton(
                          onPressed: () {
                            var bucketService = Provider.of<BucketService>(
                                context,
                                listen: false);
                            bucketService.addBucketItem(inputData.text);
                            Navigator.pop(context);
                          },
                          child: Text('등록'),
                          style: TextButton.styleFrom(
                            primary: Color.fromARGB(255, 224, 111, 6),
                            backgroundColor: Colors.white,
                            padding: EdgeInsets.all(12),
                          ),
                        ),
                        TextButton(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          child: Text('취소'),
                          style: TextButton.styleFrom(
                            primary: Color.fromARGB(255, 29, 28, 27),
                            backgroundColor: Colors.white,
                            padding: EdgeInsets.all(12),
                          ),
                        ),
                      ],
                    )
                  ],
                ),
              );
            },
          );
        },
        child: Icon(Icons.add),
      ),
    );
  }
}

class BucketList extends StatefulWidget {
  BucketList({Key? key, this.appBarCompleted}) : super(key: key);
  final appBarCompleted;

  @override
  State<BucketList> createState() => _BucketListState();
}

class _BucketListState extends State<BucketList> {
  @override
  Widget build(BuildContext context) {
    final bucketService = Provider.of<BucketService>(context);

    return bucketService.isEmpty()
        ? Center(
            child: Text(
            '버킷리스트를 작성해보세요~!',
            style: TextStyle(
              fontSize: 16,
            ),
          ))
        : ListView.builder(
            itemCount: bucketService.bucketItems.length,
            itemBuilder: (context, index) {
              var item = bucketService.bucketItems[index];

              return Container(
                width: double.infinity,
                child: Row(
                  children: [
                    SizedBox(
                      width: 8,
                    ),
                    Text(item),
                    Expanded(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          ElevatedButton(
                            onPressed: () {
                              setState(() {
                                bucketService.markAsCompleted(item);
                              });
                            },
                            style: ButtonStyle(
                              backgroundColor: MaterialStateProperty.all<Color>(
                                Colors.white70,
                              ),
                            ),
                            child: Text(
                              '완료',
                              style: TextStyle(color: Colors.black54),
                            ),
                          ),
                          SizedBox(
                            width: 8,
                          ),
                          ElevatedButton(
                            onPressed: () {
                              showDialog(
                                context: context,
                                builder: (context) {
                                  return AlertDialog(
                                    title: Text(
                                      '삭제확인',
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold),
                                    ),
                                    content: Text('이 버킷리스트를 삭제하시겠습니까?'),
                                    actions: [
                                      TextButton(
                                          onPressed: () {
                                            var item = bucketService
                                                .bucketItems[index];
                                            bucketService
                                                .removeBucketItem(item);
                                            Navigator.pop(context);
                                          },
                                          child: Text('Delete',
                                              style: TextStyle(
                                                  fontWeight:
                                                      FontWeight.bold))),
                                      TextButton(
                                          onPressed: () {
                                            Navigator.pop(context);
                                          },
                                          child: Text('Cancel')),
                                    ],
                                  );
                                },
                              );

                              // 삭제 버튼을 눌렀을 때의 동작
                            },
                            style: ButtonStyle(
                              backgroundColor: MaterialStateProperty.all<Color>(
                                Colors.white70,
                              ),
                            ),
                            child: Text(
                              '삭제',
                              style: TextStyle(color: Colors.black54),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              );
            },
          );
  }
}

class CompletedPage extends StatelessWidget {
  const CompletedPage({Key? key, this.appBarCompleted}) : super(key: key);
  final AppBar? appBarCompleted;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBarCompleted,
      body: ListView.builder(
        itemCount: context.watch<BucketService>().completedItems.length,
        itemBuilder: (context, index) {
          var item = context.watch<BucketService>().completedItems[index];

          return ListTile(
            title: Text(item),
          );
        },
      ),
    );
  }
}
