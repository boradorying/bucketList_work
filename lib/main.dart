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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
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
      ),
      body: tab == 0 ? BucketList() : Text('완료된 것'),
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
            label: '이룬 것',
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
                            bucketService.addBucketItem("새로운 버킷 아이템");
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

class BucketList extends StatelessWidget {
  const BucketList({Key? key});

  @override
  Widget build(BuildContext context) {
    final bucketService = Provider.of<BucketService>(context);

    return bucketService.isEmpty()
        ? Center(child: Text('버킷을 만들어보세요'))
        : ListView.builder(
            itemCount: bucketService.bucketItems.length,
            itemBuilder: (context, index) {
              var item = bucketService.bucketItems[index];

              return Container(
                width: double.infinity,
                child: Row(
                  children: [
                    Text(item),
                    Expanded(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          ElevatedButton(
                            onPressed: () {
                              // 완료 버튼을 눌렀을 때의 동작
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
                          ElevatedButton(
                            onPressed: () {
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
