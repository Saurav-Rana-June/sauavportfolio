import 'package:saurav_portfolio/data/models/portfolio/experience.model.dart';
import 'package:saurav_portfolio/data/models/portfolio/profile.model.dart';
import 'package:saurav_portfolio/data/models/portfolio/project.model.dart';

class PortfolioService {
  PortfolioService._();

  static Future<ProfileModel> fetchProfile() async {
    await Future<void>.delayed(const Duration(milliseconds: 400));
    return ProfileModel(
      name: 'Saurav Rana',
      title: 'Senior Flutter Developer',
      bio:
          'I am a passionate Senior Flutter Developer with 2+ years of experience specializing in building '
          'high-performance, pixel-perfect, and cross-platform applications. My core expertise lies in '
          'implementing Clean Architecture, robust state management, and elegant UI/UX design patterns. '
          'I love bridging the gap between design and code, crafting seamless user interfaces that delight. '
          'Currently, I am expanding my skill set with backend technologies like FastAPI to build robust, '
          'end-to-end applications that are both scalable and efficient.',
      email: 'sauravsevenjune@gmail.com',
      location: 'Rishikesh, Uttarakhand, India',
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
      githubUrl: 'https://github.com/Saurav-Rana-June',
      linkedInUrl: 'https://www.linkedin.com/in/saurav-rana-841106258',
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
      title: 'Pub Meme',
      description:
          'Welcome to Pub Meme, the ultimate social hub for meme creators, humor enthusiasts, and trendsetters! '
          'Build, generate, and share memes using built-in AI tools and an active social community.',
      techStack: 'Flutter, Firebase, ImageKit, AI Integration',
      tags: const ['Flutter', 'AI Integration', 'Firebase', 'ImageKit'],
      imageUrl: 'assets/images/pubmeme/app_logo.png',
      liveUrl: '#',
      githubUrl: '#',
      bannerAsset: 'assets/images/pubmeme/feature graphic.jpg',
      screenshots: const [
        'assets/images/pubmeme/ss_1.png',
        'assets/images/pubmeme/ss_2.png',
        'assets/images/pubmeme/ss_3.png',
        'assets/images/pubmeme/ss_4.png',
        'assets/images/pubmeme/ss_5.png',
        'assets/images/pubmeme/ss_6.png',
      ],
      features: const [
        'AI-Powered Meme & Image Generation: Describe what you want and generate custom meme templates and images in seconds using advanced AI tools.',
        'Smart AI Captioning: Generate hilarious, witty, and contextual meme text instantly with our smart caption assistant.',
        'Dedicated Social Meme Feed: Share memes, follow creators, browse trending feeds, and stay engaged with a lively community.',
        'Explore by Categories & Tags: Easily browse memes organized by categories like tech humor, daily struggles, gaming, and pop culture.',
        'Build Your Creator Profile: Customize your profile with a name and picture, keep track of your posts, and grow your audience.',
        'Fast Sharing & Downloads: Download memes instantly or share them directly on WhatsApp, Instagram, Telegram, and other platforms.',
        'Safe, Secure & Built for You: Secure auth, optimized ImageKit rendering, and full user control over account and data privacy.'
      ],
    ),
  ];

  static Future<List<ExperienceModel>> fetchExperiences() async {
    await Future<void>.delayed(const Duration(milliseconds: 400));
    return _seedExperiences;
  }

  static final List<ExperienceModel> _seedExperiences = [
    ExperienceModel(
      id: '1',
      role: 'Flutter Developer',
      company: 'EkoDemy',
      period: 'Apr 2025 — Present',
      location: 'Remote',
      description:
          'Developing and maintaining high-quality mobile applications with Flutter. '
          'Working in a remote, collaborative environment to deliver scalable software features.',
      isRemote: true,
      skills: const ['iOS', 'Flutter', 'Dart', 'GetX', 'Git'],
    ),
    ExperienceModel(
      id: '2',
      role: 'Junior Flutter Developer',
      company: 'Qwetzal Technologies',
      period: 'Nov 2024 — Mar 2025',
      location: 'Raipur, Uttarakhand, India',
      description:
          'Worked as a Junior Flutter Developer on Travel & Hospitality products. '
          'Responsible for implementing responsive user interfaces, modular components, and API integrations.',
      isRemote: false,
      skills: const [
        'Flutter',
        'REST APIs',
        'Firebase',
        'State Management',
        'Git',
        'Agile',
      ],
    ),
    ExperienceModel(
      id: '3',
      role: 'Flutter Intern',
      company: 'Qwetzal Technologies',
      period: 'Aug 2024 — Nov 2024',
      location: 'Dehradun, Uttarakhand, India',
      description:
          'Completed a 3-month Flutter internship, originally planned for 6 months. '
          'Focused on training in state management, cross-device compatibility, and code modularization.',
      isRemote: false,
      skills: const [
        'Flutter',
        'Dart',
        'Clean Architecture',
        'API Integration',
        'UI/UX',
      ],
    ),
    ExperienceModel(
      id: '4',
      role: 'Flutter Trainee',
      company: 'Qwetzal Technologies',
      period: 'Jun 2024 — Aug 2024',
      location: 'Raipur, Uttarakhand, India',
      description:
          'Gained hands-on experience developing Flutter applications using Dart. '
          'Mastered basic widgets, routing, and collaborated with senior developers.',
      isRemote: false,
      skills: const ['Flutter', 'Teamwork', 'Dart', 'Git', 'OOP'],
    ),
  ];
}
