import 'package:saurav_portfolio/data/models/portfolio/profile.model.dart';
import 'package:saurav_portfolio/data/models/portfolio/project.model.dart';

class PortfolioService {
  PortfolioService._();

  static Future<ProfileModel> fetchProfile() async {
    await Future<void>.delayed(const Duration(milliseconds: 400));
    return ProfileModel(
      name: 'Saurav',
      title: 'Senior Flutter Developer',
      bio:
          'I build performant, scalable cross-platform applications with Flutter. '
          'Passionate about clean architecture, thoughtful UX, and shipping products that matter.',
      email: 'hello@saurav.dev',
      location: 'India',
      skills: const [
        'Flutter',
        'Dart',
        'GetX',
        'Clean Architecture',
        'Firebase',
        'REST APIs',
        'Web',
        'System Design',
      ],
      githubUrl: 'https://github.com/saurav',
      linkedInUrl: 'https://linkedin.com/in/saurav',
      resumeUrl: '#',
    );
  }

  static Future<List<ProjectModel>> fetchProjects() async {
    await Future<void>.delayed(const Duration(milliseconds: 500));
    return _seedProjects;
  }

  static Future<ProjectModel?> fetchProjectById(String id) async {
    await Future<void>.delayed(const Duration(milliseconds: 300));
    try {
      return _seedProjects.firstWhere((project) => project.id == id);
    } catch (_) {
      return null;
    }
  }

  static Future<bool> submitContactForm({
    required String name,
    required String email,
    required String message,
  }) async {
    await Future<void>.delayed(const Duration(milliseconds: 800));
    return name.isNotEmpty && email.isNotEmpty && message.isNotEmpty;
  }

  static final List<ProjectModel> _seedProjects = [
    ProjectModel(
      id: '1',
      title: 'Portfolio Web App',
      description:
          'A responsive Flutter Web portfolio built with GetX and Clean Architecture. '
          'Features route-based navigation, dark theme, and modular feature layout.',
      techStack: 'Flutter, GetX, Dio, GetStorage',
      tags: ['Flutter Web', 'GetX', 'Clean Architecture'],
      liveUrl: '#',
      githubUrl: '#',
    ),
    ProjectModel(
      id: '2',
      title: 'E-Commerce Mobile App',
      description:
          'Cross-platform shopping experience with cart management, payment integration, '
          'and real-time order tracking.',
      techStack: 'Flutter, Firebase, Stripe',
      tags: ['Mobile', 'Firebase', 'Payments'],
      liveUrl: '#',
      githubUrl: '#',
    ),
    ProjectModel(
      id: '3',
      title: 'Task Management Dashboard',
      description:
          'Team productivity dashboard with kanban boards, analytics, and role-based access control.',
      techStack: 'Flutter Web, REST API, PostgreSQL',
      tags: ['Web', 'Dashboard', 'REST'],
      liveUrl: '#',
      githubUrl: '#',
    ),
    ProjectModel(
      id: '4',
      title: 'Social Content Platform',
      description:
          'Content sharing platform with infinite scroll feeds, media uploads, and AI-assisted creation.',
      techStack: 'Flutter, GetX, Dio, Cloud Storage',
      tags: ['Social', 'Media', 'AI'],
      liveUrl: '#',
      githubUrl: '#',
    ),
  ];
}
