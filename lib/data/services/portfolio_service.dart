import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:saurav_portfolio/data/models/portfolio/experience.model.dart';
import 'package:saurav_portfolio/data/models/portfolio/profile.model.dart';
import 'package:saurav_portfolio/data/models/portfolio/project.model.dart';

class ContactSubmissionResult {
  final bool isSuccess;
  final String message;
  final bool needsActivation;

  const ContactSubmissionResult({
    required this.isSuccess,
    required this.message,
    this.needsActivation = false,
  });
}

class PortfolioService {
  PortfolioService._();

  static final Dio _dio = Dio(
    BaseOptions(
      connectTimeout: const Duration(seconds: 15),
      receiveTimeout: const Duration(seconds: 15),
      headers: {
        'Accept': 'application/json',
        'Content-Type': 'application/json',
        'Referer': 'https://saurav-rana-june.github.io/',
        'Origin': 'https://saurav-rana-june.github.io',
      },
    ),
  );

  static Future<ProfileModel> fetchProfile() async {
    await Future<void>.delayed(const Duration(milliseconds: 400));
    return ProfileModel(
      name: 'Saurav Rana',
      title: 'Senior Flutter Developer',
      bio:
          'I am a passionate Senior Flutter Developer with 2.5+ years of experience specializing in building '
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
      resumeUrl: 'assets/cv/SAURAV_RANA_RESUME_01.pdf',
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

  static Future<ContactSubmissionResult> submitContactForm({
    required String name,
    required String email,
    required String message,
  }) async {
    try {
      final response = await _dio.post(
        'https://formsubmit.co/ajax/sauravsevenjune@gmail.com',
        data: {
          'name': name,
          'email': email,
          '_replyto': email,
          'message': message,
          '_subject': 'Portfolio Inquiry from $name',
          '_template': 'table',
          '_captcha': 'false',
        },
      );

      dynamic data = response.data;
      if (data is String) {
        try {
          data = jsonDecode(data);
        } catch (_) {}
      }

      if (data is Map) {
        final successVal = data['success'];
        final isSuccess = successVal == true ||
            successVal == 'true' ||
            successVal == 1 ||
            successVal == '1';
        final msg = data['message']?.toString() ?? '';

        if (isSuccess) {
          return ContactSubmissionResult(
            isSuccess: true,
            message: msg.isNotEmpty ? msg : 'Message sent successfully!',
          );
        } else {
          final isActivation = msg.toLowerCase().contains('activation') ||
              msg.toLowerCase().contains('activate');
          return ContactSubmissionResult(
            isSuccess: false,
            message: msg.isNotEmpty ? msg : 'Could not send message.',
            needsActivation: isActivation,
          );
        }
      }

      if (response.statusCode == 200) {
        return const ContactSubmissionResult(
          isSuccess: true,
          message: 'Message sent successfully!',
        );
      }

      return ContactSubmissionResult(
        isSuccess: false,
        message: 'Submission failed (status: ${response.statusCode})',
      );
    } on DioException catch (dioError) {
      String errorMsg = 'Network error: please check your connection.';
      final respData = dioError.response?.data;
      if (respData is Map && respData['message'] != null) {
        errorMsg = respData['message'].toString();
      } else if (dioError.message != null && dioError.message!.isNotEmpty) {
        errorMsg = dioError.message!;
      }
      return ContactSubmissionResult(
        isSuccess: false,
        message: errorMsg,
      );
    } catch (e) {
      return ContactSubmissionResult(
        isSuccess: false,
        message: 'An unexpected error occurred: $e',
      );
    }
  }

  static final List<ProjectModel> _seedProjects = [
    ProjectModel(
      id: '1',
      title: 'Schoolbox',
      description:
          'SchoolBox – Fresh, Delicious Tiffins Delivered Daily. '
          'The Smart Lunchbox Solution for Busy Families! '
          'Make school mornings simpler with SchoolBox. Skip the daily hassle of deciding what to pack, planning meals, and preparing lunchboxes. '
          'We deliver fresh, nutritious, and delicious tiffins right to your doorstep, ensuring your child enjoys a balanced meal every day. '
          'With SchoolBox, you can save time, reduce morning stress, and focus on what matters most—spending quality time with your family while we take care of the lunchbox.',
      techStack:
          'Flutter, BLoC, PHP Laravel, Playstore AppStore, Razorpay, Firebase Cloud Messaging',
      tags: const [
        'Flutter',
        'BLoC',
        'PHP Laravel',
        'Playstore',
        'AppStore',
        'Razorpay SDK',
        'FCM',
      ],
      imageUrl: 'assets/images/schoolbox/app_logo.png',
      liveUrl: '#',
      githubUrl: '#',
      showCode: false,
      bannerAsset: 'assets/images/schoolbox/feature graphic.png',
      playStoreUrl:
          'https://play.google.com/store/apps/details?id=com.schoolbox.schoolbox',
      appStoreUrl:
          'https://apps.apple.com/in/app/schoolbox-doorstep-lunchbox/id6754038198',
      screenshots: const [
        'assets/images/schoolbox/ss_1.png',
        'assets/images/schoolbox/ss_2.png',
        'assets/images/schoolbox/ss_3.png',
        'assets/images/schoolbox/ss_4.png',
        'assets/images/schoolbox/ss_5.png',
        'assets/images/schoolbox/ss_6.png',
        'assets/images/schoolbox/ss_7.png',
        'assets/images/schoolbox/ss_8.png',
        'assets/images/schoolbox/ss_9.png',
        'assets/images/schoolbox/ss_10.png',
        'assets/images/schoolbox/ss_11.png',
      ],
      features: const [
        'Fresh, Delicious Tiffins Delivered Daily: High quality, nutritious lunchboxes delivered directly to your doorstep.',
        'The Smart Lunchbox Solution for Busy Families: Takes care of daily meal planning and food prep to save you time.',
        'Stress-Free Mornings: Skip the morning rush of deciding what to pack and preparing school meals.',
        'Balanced & Nutritious Meals: Ensures children enjoy healthy, tasty, and well-rounded meals every single day.',
      ],
    ),
    ProjectModel(
      id: '2',
      title: 'Mentora',
      description:
          'Mentora – Your Path to Well-being. '
          'A comprehensive mental health and mindfulness mobile application designed to help users manage stress, build healthy habits, and improve emotional wellness. '
          'Features intelligent daily mood tracking, personalized growth analytics, guided meditation and breathing exercises with audio playback, an empathetic AI-powered companion (Mentora AI) for mental well-being support, and seamless 1-on-1 session scheduling with licensed clinical psychologists.',
      techStack:
          'Flutter, Dart, GetX, Clean Architecture, AI Assistant API, Audio Streaming, Data Visualization',
      tags: const [
        'Flutter',
        'Dart',
        'GetX',
        'Clean Architecture',
        'AI Assistant',
        'Audio Streaming',
        'Mindfulness',
      ],
      imageUrl: 'assets/images/mentora/app_logo.png',
      liveUrl: '#',
      githubUrl: '#',
      showCode: false,
      bannerAsset: 'assets/images/mentora/feature graphic.png',
      playStoreUrl: '#',
      appStoreUrl: '#',
      isInDevelopment: true,
      screenshots: const [
        'assets/images/mentora/ss_1.png',
        'assets/images/mentora/ss_2.png',
        'assets/images/mentora/ss_3.png',
        'assets/images/mentora/ss_4.png',
        'assets/images/mentora/ss_5.png',
        'assets/images/mentora/ss_6.png',
        'assets/images/mentora/ss_7.png',
        'assets/images/mentora/ss_8.png',
        'assets/images/mentora/ss_9.png',
        'assets/images/mentora/ss_10.png',
        'assets/images/mentora/ss_11.png',
        'assets/images/mentora/ss_12.png',
        'assets/images/mentora/ss_13.png',
        'assets/images/mentora/ss_14.png',
        'assets/images/mentora/ss_15.png',
        'assets/images/mentora/ss_16.png',
        'assets/images/mentora/ss_17.png',
        'assets/images/mentora/ss_18.png',
        'assets/images/mentora/ss_19.png',
      ],
      features: const [
        'Daily Mood Tracking & Check-ins: Log emotions, track active streaks, monitor weekly mood trends, and identify wellness triggers.',
        'Mentora AI Mental Health Companion: A safe conversational space powered by AI to provide immediate support, guidance, and stress relief exercises.',
        'Guided Meditation & Audio Tracks: Curated audio sessions for Morning Clarity, Deep Restful Sleep, Stress Relief, and focused breathing with real-time player controls.',
        'Personalized Growth Insights: Detailed radar and progress metrics measuring mental health, mindfulness, relationships, and self-awareness.',
        '1-on-1 Professional Therapy Sessions: Integrated scheduling and direct voice/video call session management with clinical psychologists.',
        'Sleep & Breathing Exercises: Interactive relaxation timers, guided sleep routines, and daily journaling to foster lasting well-being habits.',
      ],
    ),
    ProjectModel(
      id: '3',
      title: 'Mentora CMS',
      description:
          'Mentora CMS – Administrative Control Center & Content Management Suite for the Mentora Ecosystem. '
          'A modern, high-performance, and fully responsive administrative web platform built with Flutter to manage all platform operations, mental health content, audio streaming libraries, and practitioner registries. '
          'Features comprehensive real-time dashboard analytics, guided meditation session curation with audio duration and category tagging, customizable sleep soundscapes and ambient audio track manager, interactive breathwork pattern editor (cycle timings: inhale/hold/exhale), dynamic daily mindfulness journaling prompt scheduler, platform diagnostics, dual Light/Dark theme support, and enterprise role-based access control (RBAC).',
      techStack:
          'Flutter Web, Dart, GetX, Clean Architecture, REST API Gateway, Responsive Web Design, Audio Asset Management, Role-Based Access Control (RBAC), Theme Switching (Light/Dark)',
      tags: const [
        'Flutter Web',
        'GetX',
        'Clean Architecture',
        'REST API',
        'Responsive UI',
        'Admin CMS',
        'Audio Management',
        'Light/Dark Theme',
      ],
      imageUrl: 'assets/images/mentora_cms/app_logo.png',
      liveUrl: 'https://saurav-rana-june.github.io/mentora/',
      githubUrl: '#',
      showCode: false,
      bannerAsset: 'assets/images/mentora_cms/feature graphic.png',
      playStoreUrl: '#',
      appStoreUrl: '#',
      isInDevelopment: true,
      screenshots: const [
        'assets/images/mentora_cms/Screenshot 2026-10-04 214632.png',
        'assets/images/mentora_cms/Screenshot 2026-10-04 214750.png',
        'assets/images/mentora_cms/Screenshot 2026-10-04 214836.png',
        'assets/images/mentora_cms/Screenshot 2026-10-04 214855.png',
        'assets/images/mentora_cms/Screenshot 2026-10-04 214911.png',
        'assets/images/mentora_cms/Screenshot 2026-10-04 214922.png',
        'assets/images/mentora_cms/Screenshot 2026-10-04 214938.png',
        'assets/images/mentora_cms/Screenshot 2026-10-04 214955.png',
        'assets/images/mentora_cms/Screenshot 2026-10-04 215005.png',
        'assets/images/mentora_cms/Screenshot 2026-10-04 215023.png',
        'assets/images/mentora_cms/Screenshot 2026-10-04 215034.png',
        'assets/images/mentora_cms/Screenshot 2026-10-04 215044.png',
        'assets/images/mentora_cms/Screenshot 2026-10-04 215054.png',
      ],
      features: const [
        '⚡ Responsive Admin Console: Fully responsive layout adapting effortlessly across widescreen desktop monitors, laptops, and tablets.',
        '📊 Real-Time Dashboard Overview: Instant operational visibility into active users, audio libraries, verified therapy doctors, and module health.',
        '🧘 Guided Meditations Management: Publish, categorize, and organize mindfulness audio tracks, duration meters, and featured meditation playlists.',
        '🌙 Sleep & Ambient Soundscapes: Centralized catalog for nature audio, soothing sleep music, and bedtime story narrations.',
        '🫁 Breathwork Technique Editor: Fine-tune inhale, hold, and exhale durations with real-time cycle calculation for Box Breathing, 4-7-8, and custom patterns.',
        '📝 Daily Journaling Prompt Scheduler: Manage and publish reflective daily journaling prompts presented to users in their mindfulness log.',
        '🌓 Seamless Theme Switcher: Built-in instant switching between dark and light themes with custom curated color palettes.',
        '🔐 Secure Role-Based Access & Diagnostics: 256-bit encrypted authentication, REST API status monitor, environment switching, and super admin privileges.',
      ],
    ),
    ProjectModel(
      id: '4',
      title: 'Pub Meme',
      description:
          'Welcome to Pub Meme, the ultimate social hub for meme creators, humor enthusiasts, and trendsetters! '
          'Build, generate, and share memes using built-in AI tools and an active social community.',
      techStack: 'Flutter, GetX, FastAPI, Replicate API, ImgFlip, ImageKit',
      tags: const [
        'Flutter',
        'GetX',
        'FastAPI',
        'Replicate API',
        'ImgFlip',
        'ImageKit',
      ],
      imageUrl: 'assets/images/pubmeme/app_logo.png',
      liveUrl: '#',
      githubUrl: '#',
      bannerAsset: 'assets/images/pubmeme/feature graphic.jpg',
      playStoreUrl:
          'https://drive.google.com/file/d/1J3bX0hr6vcCzpXOwSl5fderBbMR5cU3H/view?usp=drive_link',
      appStoreUrl: '#',
      isInDevelopment: true,
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
        'Safe, Secure & Built for You: Secure auth, optimized ImageKit rendering, and full user control over account and data privacy.',
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
      company: 'Qwetzal Technologies Pvt. Ltd.',
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
      company: 'Qwetzal Technologies Pvt. Ltd.',
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
      company: 'Qwetzal Technologies Pvt. Ltd.',
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
