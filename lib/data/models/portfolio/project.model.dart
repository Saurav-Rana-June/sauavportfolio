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
  final List<String> features;
  final List<String> screenshots;
  final String? bannerAsset;
  final String? playStoreUrl;
  final String? appStoreUrl;
  final bool showCode;

  ProjectModel({
    required this.id,
    required this.title,
    required this.description,
    required this.techStack,
    this.imageUrl,
    this.liveUrl,
    this.githubUrl,
    this.tags = const [],
    this.features = const [],
    this.screenshots = const [],
    this.bannerAsset,
    this.playStoreUrl,
    this.appStoreUrl,
    this.showCode = true,
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
    List<String>? features,
    List<String>? screenshots,
    String? bannerAsset,
    String? playStoreUrl,
    String? appStoreUrl,
    bool? showCode,
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
      features: features ?? this.features,
      screenshots: screenshots ?? this.screenshots,
      bannerAsset: bannerAsset ?? this.bannerAsset,
      playStoreUrl: playStoreUrl ?? this.playStoreUrl,
      appStoreUrl: appStoreUrl ?? this.appStoreUrl,
      showCode: showCode ?? this.showCode,
    );
  }
}
