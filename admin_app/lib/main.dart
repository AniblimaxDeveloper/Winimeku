import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'config.dart';

void main() => runApp(const AdminApp());

class AdminApp extends StatelessWidget {
  const AdminApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Winimeku Admin',
      debugShowCheckedModeBanner: false,
      theme: ThemeData.dark().copyWith(
        scaffoldBackgroundColor: const Color(0xFF121212),
        primaryColor: Colors.redAccent,
        inputDecorationTheme: const InputDecorationTheme(
          filled: true, fillColor: Color(0xFF1E1E1E),
          border: OutlineInputBorder(borderSide: BorderSide.none),
        ),
      ),
      home: const LoginScreen(),
    );
  }
}

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});
  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _userCtrl = TextEditingController();
  final _passCtrl = TextEditingController();
  bool _loading = false;

  Future<void> _login() async {
    setState(() => _loading = true);
    try {
      final res = await http.post(
        Uri.parse('${AppConfig.baseUrl}/admin/login'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'username': _userCtrl.text, 'password': _passCtrl.text}),
      );
      if (res.statusCode == 200) {
        final token = jsonDecode(res.body)['token'];
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString('token', token);
        if (mounted) Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => const DashboardScreen()));
      } else {
        if (mounted) ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Login Gagal')));
      }
    } catch (e) {
      if (mounted) ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error: $e')));
    }
    setState(() => _loading = false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text("WINIMEKU ADMIN", style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.redAccent)),
            const SizedBox(height: 32),
            TextField(controller: _userCtrl, decoration: const InputDecoration(labelText: 'Username')),
            const SizedBox(height: 16),
            TextField(controller: _passCtrl, decoration: const InputDecoration(labelText: 'Password'), obscureText: true),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: _loading ? null : _login,
              style: ElevatedButton.styleFrom(backgroundColor: Colors.redAccent, minimumSize: const Size(double.infinity, 50)),
              child: _loading ? const CircularProgressIndicator(color: Colors.white) : const Text("LOGIN", style: TextStyle(color: Colors.white)),
            ),
          ],
        ),
      ),
    );
  }
}

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});
  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  final _titleCtrl = TextEditingController();
  final _synopsisCtrl = TextEditingController();
  final _coverCtrl = TextEditingController();
  final _epNumCtrl = TextEditingController();
  final _epUrlCtrl = TextEditingController();
  bool _loading = false;

  Future<void> _addAnime() async {
    setState(() => _loading = true);
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');

    try {
      final res = await http.post(
        Uri.parse('${AppConfig.baseUrl}/admin/anime'),
        headers: {'Content-Type': 'application/json', 'Authorization': 'Bearer $token'},
        body: jsonEncode({
          "title": _titleCtrl.text,
          "synopsis": _synopsisCtrl.text,
          "coverImage": _coverCtrl.text,
          "status": "Ongoing",
          "episodes": [{"number": int.tryParse(_epNumCtrl.text) ?? 1, "videoUrl": _epUrlCtrl.text}]
        }),
      );
      if (res.statusCode == 201) {
        if (mounted) ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Anime Berhasil Ditambahkan!')));
        _titleCtrl.clear(); _synopsisCtrl.clear(); _coverCtrl.clear(); _epNumCtrl.clear(); _epUrlCtrl.clear();
      } else {
        if (mounted) ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Gagal Menambahkan Anime')));
      }
    } catch (e) {
      if (mounted) ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error: $e')));
    }
    setState(() => _loading = false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Tambah Anime Baru"), actions: [
        IconButton(
          icon: const Icon(Icons.logout),
          onPressed: () async {
            final prefs = await SharedPreferences.getInstance();
            await prefs.remove('token');
            if (mounted) Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => const LoginScreen()));
          },
        )
      ]),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(controller: _titleCtrl, decoration: const InputDecoration(labelText: 'Judul Anime')),
            const SizedBox(height: 12),
            TextField(controller: _synopsisCtrl, decoration: const InputDecoration(labelText: 'Sinopsis'), maxLines: 3),
            const SizedBox(height: 12),
            TextField(controller: _coverCtrl, decoration: const InputDecoration(labelText: 'URL Gambar Cover')),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(child: TextField(controller: _epNumCtrl, decoration: const InputDecoration(labelText: 'Eps'), keyboardType: TextInputType.number)),
                const SizedBox(width: 12),
                Expanded(flex: 3, child: TextField(controller: _epUrlCtrl, decoration: const InputDecoration(labelText: 'URL Video MP4/M3U8'))),
              ],
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: _loading ? null : _addAnime,
              style: ElevatedButton.styleFrom(backgroundColor: Colors.redAccent, minimumSize: const Size(double.infinity, 50)),
              child: _loading ? const CircularProgressIndicator(color: Colors.white) : const Text("TAMBAH ANIME", style: TextStyle(color: Colors.white)),
            ),
          ],
        ),
      ),
    );
  }
}
