import 'package:json_annotation/json_annotation.dart';

part 'profile.model.g.dart';

@JsonSerializable(explicitToJson: true)
class ProfileModel {
  final String name;
  final String title;
  final String bio;
  final String email;
  final String location;
  final List<String> skills;
  final String? githubUrl;
  final String? linkedInUrl;
  final String? resumeUrl;

  ProfileModel({
    required this.name,
    required this.title,
    required this.bio,
    required this.email,
    required this.location,
    this.skills = const [],
    this.githubUrl,
    this.linkedInUrl,
    this.resumeUrl,
  });

  factory ProfileModel.fromJson(Map<String, dynamic> json) =>
      _$ProfileModelFromJson(json);

  Map<String, dynamic> toJson() => _$ProfileModelToJson(this);
}
