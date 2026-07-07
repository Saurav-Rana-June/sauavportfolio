import 'package:json_annotation/json_annotation.dart';

part 'project.model.g.dart';

@JsonSerializable(explicitToJson: true)
class ProjectModel {
  final String id;
  final String title;
  final String description;
  final String techStack;
  final String? imageUrl;
  final String? liveUrl;
  final String? githubUrl;
  final List<String> tags;

  ProjectModel({
    required this.id,
    required this.title,
    required this.description,
    required this.techStack,
    this.imageUrl,
    this.liveUrl,
    this.githubUrl,
    this.tags = const [],
  });

  factory ProjectModel.fromJson(Map<String, dynamic> json) =>
      _$ProjectModelFromJson(json);

  Map<String, dynamic> toJson() => _$ProjectModelToJson(this);

  ProjectModel copyWith({
    String? title,
    String? description,
    String? techStack,
    String? imageUrl,
    String? liveUrl,
    String? githubUrl,
    List<String>? tags,
  }) {
    return ProjectModel(
      id: id,
      title: title ?? this.title,
      description: description ?? this.description,
      techStack: techStack ?? this.techStack,
      imageUrl: imageUrl ?? this.imageUrl,
      liveUrl: liveUrl ?? this.liveUrl,
      githubUrl: githubUrl ?? this.githubUrl,
      tags: tags ?? this.tags,
    );
  }
}
