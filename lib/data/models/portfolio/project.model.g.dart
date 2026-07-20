// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'project.model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ProjectModel _$ProjectModelFromJson(Map<String, dynamic> json) => ProjectModel(
      id: json['id'] as String,
      title: json['title'] as String,
      description: json['description'] as String,
      techStack: json['techStack'] as String,
      imageUrl: json['imageUrl'] as String?,
      liveUrl: json['liveUrl'] as String?,
      githubUrl: json['githubUrl'] as String?,
      tags:
          (json['tags'] as List<dynamic>?)?.map((e) => e as String).toList() ??
              const [],
      features: (json['features'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const [],
      screenshots: (json['screenshots'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const [],
      bannerAsset: json['bannerAsset'] as String?,
    );

Map<String, dynamic> _$ProjectModelToJson(ProjectModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'title': instance.title,
      'description': instance.description,
      'techStack': instance.techStack,
      'imageUrl': instance.imageUrl,
      'liveUrl': instance.liveUrl,
      'githubUrl': instance.githubUrl,
      'tags': instance.tags,
      'features': instance.features,
      'screenshots': instance.screenshots,
      'bannerAsset': instance.bannerAsset,
    };
