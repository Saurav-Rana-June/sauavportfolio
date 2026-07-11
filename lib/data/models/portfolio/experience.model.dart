class ExperienceModel {
  final String id;
  final String role;
  final String company;
  final String period;
  final String location;
  final String description;
  final bool isRemote;
  final List<String> skills;

  ExperienceModel({
    required this.id,
    required this.role,
    required this.company,
    required this.period,
    required this.location,
    required this.description,
    this.isRemote = false,
    this.skills = const [],
  });

  factory ExperienceModel.fromJson(Map<String, dynamic> json) => ExperienceModel(
        id: json['id'] as String,
        role: json['role'] as String,
        company: json['company'] as String,
        period: json['period'] as String,
        location: json['location'] as String,
        description: json['description'] as String,
        isRemote: json['isRemote'] as bool? ?? false,
        skills: (json['skills'] as List<dynamic>?)
                ?.map((e) => e as String)
                .toList() ??
            const [],
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'role': role,
        'company': company,
        'period': period,
        'location': location,
        'description': description,
        'isRemote': isRemote,
        'skills': skills,
      };
}
