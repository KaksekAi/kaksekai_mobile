import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class AboutMeScreen extends StatelessWidget {
  const AboutMeScreen({super.key});

  void _launchURL(String url) async {
    final Uri uri = Uri.parse(url);
    if (!await launchUrl(uri, mode: LaunchMode.externalApplication)) {
      throw 'Could not launch $url';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("About the Developer")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const CircleAvatar(
                radius: 50,
                backgroundImage: AssetImage("assets/developer.png"), // Add your profile picture in assets
              ),
              const SizedBox(height: 16),
              Text(
                "HENG BUNKHEANG",
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              Text("📧 Email: bunkheangheng99@gmail.com"),
              Text("📍 Location: Phnom Penh, Cambodia"),
              Text("📞 Phone: 0973556059"),
              const Divider(height: 20, thickness: 2),

              /// EDUCATION
              Text(
                "🎓 Education",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              Text("📍 Bachelor of Computer Science - Fort Hays State University"),
              Text("📍 Bachelor of IT Management - American University of Phnom Penh"),
              const Divider(height: 20, thickness: 2),

              /// SKILLS
              Text(
                "🛠️ Skills",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              Text("✅ Full-Stack Developer: ReactJS, Next.js, Node.js, PHP, SQL, NoSQL"),
              Text("✅ Python: Flask, Pandas, Django"),
              Text("✅ Java: SpringBoot"),
              Text("✅ Flutter & Dart"),
              const Divider(height: 20, thickness: 2),

              /// EXPERIENCE
              Text(
                "💼 Work Experience",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              Text("🔹 2024 - Full Stack Developer at Save the Children Cambodia"),
              Text("🔹 Developed a digital platform for a parenting project"),
              Text("🔹 Created a chatbot with Python for better user engagement"),
              const Divider(height: 20, thickness: 2),

              /// COMPETITIONS & REWARDS
              Text(
                "🏆 Achievements",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              Text("🥇 2023 - Ideathon Top 10 Winner"),
              Text("🥇 2023 - Turing Hackathon Top 5 Winner"),
              Text("🥇 2023 - Clean Energy Hackathon Top 3 Winner"),
              Text("🥇 2023 - Novathon by Save the Children Top 5 Winner"),
              Text("🥇 2024 - Unienterprineur Top 10 Winner"),
              Text("🥇 2024 - SandBox Top 10 Winner"),
              const Divider(height: 20, thickness: 2),

              /// PROJECTS
              Text(
                "🚀 Projects",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              GestureDetector(
                onTap: () => _launchURL("https://sakrean-8b632.web.app/"),
                child: Text("🔗 SakRean - Career Guidance Platform", style: TextStyle(color: Colors.blue)),
              ),
              GestureDetector(
                onTap: () => _launchURL("https://stemii1.web.app/"),
                child: Text("🔗 STEMii - STEM Learning Platform", style: TextStyle(color: Colors.blue)),
              ),
              GestureDetector(
                onTap: () => _launchURL("https://bunkheang-heng.github.io/Portfolio1/"),
                child: Text("🔗 Portfolio Website", style: TextStyle(color: Colors.blue)),
              ),
              GestureDetector(
                onTap: () => _launchURL("https://quick-resume-af9c.vercel.app/"),
                child: Text("🔗 QuickResume - AI Resume Generator", style: TextStyle(color: Colors.blue)),
              ),
              GestureDetector(
                onTap: () => _launchURL("https://vast-eyrie-19878-8ab3229ff3bf.herokuapp.com/"),
                child: Text("🔗 VDetectPhishing - Email Phishing Detection", style: TextStyle(color: Colors.blue)),
              ),
              const Divider(height: 20, thickness: 2),

              /// SOCIAL MEDIA
              Text(
                "🌐 Social Links",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              GestureDetector(
                onTap: () => _launchURL("https://github.com/Bunkheang-heng"),
                child: Text("🔗 GitHub Profile", style: TextStyle(color: Colors.blue)),
              ),
              GestureDetector(
                onTap: () => _launchURL("https://www.linkedin.com/in/bunkheang-heng-200b25297/"),
                child: Text("🔗 LinkedIn Profile", style: TextStyle(color: Colors.blue)),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
