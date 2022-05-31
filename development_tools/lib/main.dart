import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fijkplayer/fijkplayer.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([
    //强制横屏
    DeviceOrientation.landscapeLeft,
    DeviceOrientation.landscapeRight
  ]);
  runApp(const MyApp());
  SystemUiOverlayStyle systemUiOverlayStyle =
      SystemUiOverlayStyle(statusBarColor: Colors.transparent);
  SystemChrome.setSystemUIOverlayStyle(systemUiOverlayStyle);
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Development Tools',
      theme: ThemeData(
        primarySwatch: Colors.brown,
      ),
      home: const MyHomePage(
        title: 'Development Tools',
        zoneR: 50.0,
        handleR: 25.0,
        onHandleListener: onHandleListener,
      ),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage(
      {Key? key,
      required this.title,
      required this.zoneR,
      required this.handleR,
      required this.onHandleListener})
      : super(key: key);

  final String title;
  final double zoneR;
  final double handleR;
  final Function(double, double) onHandleListener;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  late double zoneR;
  late double handleR;
  double centerX = 0.0;
  double centerY = 0.0;

  bool _switchSelected = true; //维护单选开关状态
  bool _checkboxSelected = true; //维护复选框状态

  final FijkPlayer player = FijkPlayer();

  final path =
      "rtsp://admin:OTAMJC@192.168.53.92:554/h264/ch1/main/av_stream";

  Future<void> _initPlayer() async {
    // ijkPlayer 初始化不启用缓冲，避免RTSP流卡死
    await player.setOption(FijkOption.playerCategory, 'packet-buffering', 0);
    await player.setOption(FijkOption.playerCategory, 'framedrop', 1);
    player.setDataSource(path, autoPlay: true);
  }

  @override
  void initState() {
    super.initState();
    zoneR = widget.zoneR;
    handleR = widget.handleR;
    _initPlayer();
  }

  @override
  void dispose() {
    super.dispose();
    player.release();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Text(widget.title),
        elevation: 0.0,
        leading: IconButton(
          icon: const Icon(Icons.menu),
          tooltip: 'Navigation',
          onPressed: () => debugPrint('Navigation button is pressed.'),
        ),
        actions: <Widget>[
          IconButton(
            icon: const Icon(Icons.settings),
            tooltip: 'Search',
            onPressed: () => debugPrint('settings button is pressed.'),
          ),
        ],
      ),
      body: Flex(
        direction: Axis.horizontal,
        children: [
          // 视频流
          Expanded(
            flex: 2,
            child: Container(
              margin: const EdgeInsets.only(
                  left: 10, top: 10, right: 10, bottom: 10),
              //设置 child 居中
              alignment: const Alignment(0, 0),
              //边框设置
              decoration: BoxDecoration(
                //背景
                color: Colors.black,
                //设置四周边框
                border: Border.all(width: 1, color: Colors.red),
              ),
              child: FijkView(
                player: player,
              ),
            ),
          ),
          // 操控台
          Expanded(
            flex: 1,
            child: Column(
              mainAxisSize: MainAxisSize.max,
              children: <Widget>[
                const SizedBox(height: 10),
                Flex(direction: Axis.horizontal, children: [
                  // 单选开关
                  Expanded(
                    flex: 1,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        const Text('开关'),
                        Switch(
                          value: _switchSelected,
                          onChanged: (value) {
                            setState(() {
                              _switchSelected = value;
                            });
                          },
                        ),
                      ],
                    ),
                  ),
                  // 复选框
                  Expanded(
                    flex: 1,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        const Text('复选框'),
                        Checkbox(
                          value: _checkboxSelected,
                          onChanged: (value) {
                            setState(() {
                              _checkboxSelected = value!;
                            });
                          },
                        ),
                      ],
                    ),
                  ),
                ]),
                Flex(direction: Axis.horizontal, children: [
                  // 1
                  Expanded(
                    flex: 1,
                    child: ElevatedButton.icon(
                      icon: const Icon(Icons.store),
                      label: const Text("1"),
                      onPressed: () {},
                    ),
                  ),
                  const SizedBox(width: 10),
                  // 2
                  Expanded(
                    flex: 1,
                    child: ElevatedButton.icon(
                      icon: const Icon(Icons.thumb_up),
                      label: const Text("2"),
                      onPressed: () {},
                    ),
                  ),
                ]),
                Flex(direction: Axis.horizontal, children: [
                  // Button
                  Expanded(
                    flex: 1,
                    child: OutlinedButton(
                      onPressed: () {},
                      style: ButtonStyle(
                        shape: MaterialStateProperty.all(RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30.0))),
                      ),
                      child: const Text("Button"),
                    ),
                  ),
                  const SizedBox(width: 10),
                  // Button
                  Expanded(
                    flex: 1,
                    child: OutlinedButton(
                      onPressed: () {},
                      style: ButtonStyle(
                        shape: MaterialStateProperty.all(RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30.0))),
                      ),
                      child: const Text("Button"),
                    ),
                  ),
                ]),
                Flex(direction: Axis.horizontal, children: [
                  const SizedBox(width: 10),
                  // 遥控
                  Expanded(
                      flex: 1,
                      child: Image.asset('assets/images/control.png',
                          color: Colors.blue,
                          height: 150)),
                  const SizedBox(width: 10),
                  // 遥感
                  Expanded(
                    flex: 3,
                    child: GestureDetector(
                      onPanEnd: (d) => reset(),
                      onPanUpdate: (d) => parser(d.localPosition),
                      child: SizedBox(
                        width: MediaQuery.of(context).size.width / 7,
                        height: MediaQuery.of(context).size.height / 2.6,
                        child: CustomPaint(
                          size: Size(zoneR, zoneR),
                          painter: _HandleView(
                              zoneR: zoneR,
                              handleR: handleR,
                              centerX: centerX,
                              centerY: centerY),
                        ),
                      ),
                    ),
                  ),
                ]),
              ],
            ),
          ),
        ],
      ),
    );
  }

  double get maxR => zoneR + handleR;

  reset() {
    centerX = 0;
    centerY = 0;
    setState(() {});
  }

  parser(Offset offset) {
    centerX = offset.dx - maxR;
    centerY = offset.dy - maxR;
    var rad = atan2(centerX, centerY);
    if (centerX < 0) {
      rad += 2 * pi;
    }
    var thta = rad - pi / 2; //旋转坐标系90度
    if (sqrt(centerX * centerX + centerY * centerY) > zoneR) {
      centerX = zoneR * cos(thta);
      centerY = -zoneR * sin(thta);
    }
    var len = sqrt(centerX * centerX + centerY * centerY);
    widget.onHandleListener(rad, len / zoneR);
    setState(() {});
  }
}

class _HandleView extends CustomPainter {
  final _paint = Paint();
  var zoneR;
  var handleR;
  var centerX;
  var centerY;

  _HandleView({this.zoneR, this.handleR, this.centerX, this.centerY}) {
    _paint
      ..color = Colors.blue
      ..style = PaintingStyle.fill
      ..isAntiAlias = true;
  }

  double get maxR => zoneR + handleR;

  @override
  void paint(Canvas canvas, Size size) {
    canvas.translate(maxR, maxR);
    _paint.color = _paint.color.withAlpha(100);
    canvas.drawCircle(const Offset(0, 0), zoneR, _paint);
    _paint.color = _paint.color.withAlpha(150);
    canvas.drawCircle(Offset(centerX, centerY), handleR, _paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }
}

void onHandleListener(double rad, double offset) {
  print('角度${rad * 180 / pi},位移:$offset');
}
