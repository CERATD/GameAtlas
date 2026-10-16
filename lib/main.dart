import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

void main() => runApp(const GameAtlas());

class GameAtlas extends StatelessWidget {
  const GameAtlas({super.key});
  @override
  Widget build(BuildContext context) => MaterialApp(
    title: 'GameAtlas',
    debugShowCheckedModeBanner: false,
    theme: ThemeData.dark(useMaterial3: true),
    home: const GameCatalog(),
  );
}

class GameCatalog extends StatelessWidget {
  const GameCatalog({super.key});
  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(title: const Text('GameAtlas')),
    body: ListView(children: [
      const Padding(
        padding: EdgeInsets.all(16),
        child: Text('Real game maps • community project • no advertisements added'),
      ),
      ListTile(
        leading: const Icon(Icons.map_outlined),
        title: const Text('The Witcher 3'),
        subtitle: const Text('Interactive world map and real POI locations'),
        trailing: const Icon(Icons.chevron_right),
        onTap: () => Navigator.of(context).push(MaterialPageRoute(
          builder: (_) => const WitcherMap(),
        )),
      ),
      const ListTile(
        leading: Icon(Icons.construction),
        title: Text('Dark Souls 1'),
        subtitle: Text('Accurate map data is being prepared'),
      ),
      const Padding(
        padding: EdgeInsets.all(16),
        child: Text('The Witcher 3 map is provided by the independent witcher3map.com project (CC BY-NC-SA). Game assets belong to CD PROJEKT RED. The website needs internet. Cloud account sync is not implemented yet.'),
      ),
    ]),
  );
}

class WitcherMap extends StatefulWidget {
  const WitcherMap({super.key});
  @override
  State<WitcherMap> createState() => _WitcherMapState();
}

class _WitcherMapState extends State<WitcherMap> {
  late final WebViewController controller;
  int progress = 0;
  @override
  void initState() {
    super.initState();
    controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setNavigationDelegate(NavigationDelegate(
        onProgress: (value) {
          if (mounted) setState(() => progress = value);
        },
        onWebResourceError: (error) {
          if (error.isForMainFrame == true && mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Map loading failed: ${error.description}')),
            );
          }
        },
      ))
      ..loadRequest(Uri.parse('https://witcher3map.com/'));
  }
  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(
      title: const Text('The Witcher 3'),
      actions: [
        IconButton(
          tooltip: 'Reload',
          icon: const Icon(Icons.refresh),
          onPressed: () => controller.reload(),
        ),
      ],
    ),
    body: Column(children: [
      if (progress < 100) LinearProgressIndicator(value: progress / 100),
      Expanded(child: WebViewWidget(controller: controller)),
    ]),
  );
}
