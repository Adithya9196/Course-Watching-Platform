import 'package:flutter/material.dart';
import 'package:interview/Authentication/Ui/LoginPage.dart';
import 'package:interview/Authentication/Provider/_authprovider.dart';
import 'package:interview/Course/Ui/video_player_screen.dart';
import 'package:provider/provider.dart';
import 'package:interview/Course/Provider/course_provider.dart';
import 'package:interview/Course/Model/module_model.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String? _selectedModuleId;

  @override
  Widget build(BuildContext context) {
    final courseProvider = Provider.of<CourseProvider>(context);
    final modules = courseProvider.modules;

    final selectedModule = _selectedModuleId == null
        ? null
        : modules.firstWhere((m) => m.id == _selectedModuleId, orElse: () => modules.first);

    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(onPressed: (){
            final authProvider = context.read<AuthProvider>();
            authProvider.logout();
            Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(builder: (context) => const LoginPage()),
                  (route) => false,
            );
          }, icon: Icon(Icons.logout,color: Colors.white,))
        ],
        title: const Text(
          "Flutter Course",
          style: TextStyle(
            color: Colors.white,
            fontSize: 28,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: Colors.blue,
      ),
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Image.asset(
              'assets/flutter.jpeg',
              fit: BoxFit.cover,
              height: 180,
              width: double.infinity,
            ),
            const SizedBox(height: 20),
            const Text(
              "Modules",
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12.0),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10.0),
                border: Border.all(color: Colors.grey),
              ),
              child: DropdownButton<String>(
                value: _selectedModuleId,
                hint: const Text("Select a Module"),
                isExpanded: true,
                underline: const SizedBox(),
                items: modules.map((module) {
                  return DropdownMenuItem<String>(
                    value: module.id,
                    child: Text(module.title),
                  );
                }).toList(),
                onChanged: (String? newValue) {
                  setState(() {
                    _selectedModuleId = newValue;
                  });
                },
              ),
            ),
            if (selectedModule != null) ...[
              const SizedBox(height: 20),
              Expanded(
                child: ListView(
                  children: [
                    if (selectedModule.videos.isNotEmpty) ...[
                      const Text(
                        "Videos",
                        style: TextStyle(
                            fontSize: 20, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 10),
                      ...selectedModule.videos.asMap().entries.map((entry) {
                        final index = entry.key;
                        final video = entry.value;
                        final isLocked = index > 0 &&
                            !selectedModule.videos[index - 1].isCompleted;

                        return ListTile(
                          leading: Icon(
                            video.isCompleted
                                ? Icons.check_circle
                                : Icons.video_library,
                            color: video.isCompleted ? Colors.green : null,
                          ),
                          title: Text(video.title),
                          trailing: isLocked ? const Icon(Icons.lock) : null,
                          enabled: !isLocked,
                          onTap: () {
                            if (!isLocked) {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => VideoPlayerScreen(
                                    moduleId: selectedModule.id,
                                    videoId: video.id,
                                    youtubeUrl: video.youtubeUrl,
                                    title: video.title,
                                  ),
                                ),
                              );
                            }
                          },
                        );
                      }),
                    ],
                    if (selectedModule.quizzes.isNotEmpty) ...[
                      const SizedBox(height: 20),
                      const Text(
                        "Quizzes",
                        style: TextStyle(
                            fontSize: 20, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 10),
                      ...selectedModule.quizzes.map((quiz) => ListTile(
                            leading: const Icon(Icons.quiz),
                            title: Text(quiz.title),
                            onTap: () {
                              // TODO: Implement quiz functionality
                            },
                          )),
                    ],
                  ],
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
