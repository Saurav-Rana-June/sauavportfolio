// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'profile.model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ProfileModel _$ProfileModelFromJson(Map<String, dynamic> json) => ProfileModel(
  name: json['name'] as String,
  title: json['title'] as String,
  bio: json['bio'] as String,
  email: json['email'] as String,
  location: json['location'] as String,
  skills:
      (json['skills'] as List<dynamic>?)?.map((e) => e as String).toList() ??
      const [],
  githubUrl: json['githubUrl'] as String?,
  linkedInUrl: json['linkedInUrl'] as String?,
  resumeUrl: json['resumeUrl'] as String?,
);

Map<String, dynamic> _$ProfileModelToJson(ProfileModel instance) =>
    <String, dynamic>{
      'name': instance.name,
      'title': instance.title,
      'bio': instance.bio,
      'email': instance.email,
      'location': instance.location,
      'skills': instance.skills,
      'githubUrl': instance.githubUrl,
      'linkedInUrl': instance.linkedInUrl,
      'resumeUrl': instance.resumeUrl,
    };
