import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
void main()=>runApp(const GameAtlas());
class GameAtlas extends StatelessWidget {
 const GameAtlas({super.key});
 @override Widget build(BuildContext context)=>MaterialApp(title:'GameAtlas',debugShowCheckedModeBanner:false,theme:ThemeData.dark(useMaterial3:true),home:const Games());
}
class Games extends StatelessWidget {
 const Games({super.key});
 @override Widget build(BuildContext context)=>Scaffold(appBar:AppBar(title:const Text('GameAtlas')),body:ListView(children:['Dark Souls 1','The Witcher 3'].map((g)=>ListTile(leading:const Icon(Icons.map),title:Text(g),subtitle:const Text('Demo map • local progress'),trailing:const Icon(Icons.chevron_right),onTap:()=>Navigator.push(context,MaterialPageRoute(builder:(_)=>GameMap(game:g))))).toList()));
}
class GameMap extends StatefulWidget {
 final String game;
 const GameMap({super.key,required this.game});
 @override State<GameMap> createState()=>_GameMapState();
}
class _GameMapState extends State<GameMap>{
 late final List<Offset> points;
 Set<int> found={};
 @override void initState(){super.initState();points=List.generate(32,(i)=>Offset(60+(i*137)%820.0,70+(i*211)%800.0));load();}
 Future<void> load()async{final p=await SharedPreferences.getInstance();if(mounted)setState(()=>found=(p.getStringList(widget.game)??[]).map(int.parse).toSet());}
 Future<void> toggle(int i)async{setState(()=>found.contains(i)?found.remove(i):found.add(i));final p=await SharedPreferences.getInstance();await p.setStringList(widget.game,found.map((x)=>x.toString()).toList());}
 @override Widget build(BuildContext context)=>Scaffold(appBar:AppBar(title:Text(widget.game),actions:[Center(child:Padding(padding:const EdgeInsets.all(12),child:Text('${found.length}/${points.length} found')))]),body:InteractiveViewer(minScale:.5,maxScale:6,constrained:false,child:SizedBox(width:1000,height:1000,child:Stack(children:[Container(decoration:const BoxDecoration(gradient:LinearGradient(begin:Alignment.topLeft,end:Alignment.bottomRight,colors:[Color(0xff283a32),Color(0xff121b25)]))),for(int i=0;i<points.length;i++)Positioned(left:points[i].dx,top:points[i].dy,child:IconButton(tooltip:'Point ${i+1}',onPressed:()=>toggle(i),icon:Icon(found.contains(i)?Icons.check_circle:Icons.location_on,color:found.contains(i)?Colors.greenAccent:Colors.amber,size:34)))]))),bottomNavigationBar:const SafeArea(child:Padding(padding:EdgeInsets.all(12),child:Text('Demo coordinates. Tap a marker to mark it found. Progress is saved on this device.',textAlign:TextAlign.center))));
}
