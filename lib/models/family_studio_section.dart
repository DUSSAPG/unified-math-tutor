import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';

/// The 10 sections of the Family Studio hub. Mirrors
/// [MathStudioPillarMeta]'s shape/registry pattern exactly, for the parent
/// hub rather than the child one.
enum FamilyStudioSectionId {
  todaysActivity,
  homeworkCompanion,
  whatYourChildIsLearning,
  explainThisMethod,
  conversationStarters,
  parentRecallCards,
  fractionsAndRatio,
  mentalMathsTogether,
  cubeAndSpatial,
  progressSnapshot,
  tutorTools,
}

class FamilyStudioSectionMeta {
  const FamilyStudioSectionMeta({
    required this.id,
    required this.icon,
    required this.iconColor,
    required this.routeSuffix,
    this.teacherOnly = false,
  });

  final FamilyStudioSectionId id;
  final IconData icon;
  final Color iconColor;

  /// Relative to `/family-studio/`.
  final String routeSuffix;

  /// True only for Tutor Tools — most useful to the teacher/tutor role,
  /// still reachable by anyone (never hidden — "no dead cards").
  final bool teacherOnly;

  static const registry = <FamilyStudioSectionId, FamilyStudioSectionMeta>{
    FamilyStudioSectionId.todaysActivity: FamilyStudioSectionMeta(
      id: FamilyStudioSectionId.todaysActivity,
      icon: LucideIcons.sun,
      iconColor: Color(0xFFFFBD00),
      routeSuffix: 'today',
    ),
    FamilyStudioSectionId.homeworkCompanion: FamilyStudioSectionMeta(
      id: FamilyStudioSectionId.homeworkCompanion,
      icon: LucideIcons.bookOpen,
      iconColor: Color(0xFF3D7EFF),
      routeSuffix: 'homework-companion',
    ),
    FamilyStudioSectionId.whatYourChildIsLearning: FamilyStudioSectionMeta(
      id: FamilyStudioSectionId.whatYourChildIsLearning,
      icon: LucideIcons.graduationCap,
      iconColor: Color(0xFF34C759),
      routeSuffix: 'learning',
    ),
    FamilyStudioSectionId.explainThisMethod: FamilyStudioSectionMeta(
      id: FamilyStudioSectionId.explainThisMethod,
      icon: LucideIcons.lightbulb,
      iconColor: Color(0xFFE85DAA),
      routeSuffix: 'explain',
    ),
    FamilyStudioSectionId.conversationStarters: FamilyStudioSectionMeta(
      id: FamilyStudioSectionId.conversationStarters,
      icon: LucideIcons.messageCircle,
      iconColor: Color(0xFF7C5FFF),
      routeSuffix: 'conversation-starters',
    ),
    FamilyStudioSectionId.parentRecallCards: FamilyStudioSectionMeta(
      id: FamilyStudioSectionId.parentRecallCards,
      icon: LucideIcons.heart,
      iconColor: Color(0xFFFF9F5B),
      routeSuffix: 'parent-recall-cards',
    ),
    FamilyStudioSectionId.fractionsAndRatio: FamilyStudioSectionMeta(
      id: FamilyStudioSectionId.fractionsAndRatio,
      icon: LucideIcons.pieChart,
      iconColor: Color(0xFFFF7A45),
      routeSuffix: 'fractions-and-ratio',
    ),
    FamilyStudioSectionId.mentalMathsTogether: FamilyStudioSectionMeta(
      id: FamilyStudioSectionId.mentalMathsTogether,
      icon: LucideIcons.brain,
      iconColor: Color(0xFF5B8EFF),
      routeSuffix: 'mental-maths-together',
    ),
    FamilyStudioSectionId.cubeAndSpatial: FamilyStudioSectionMeta(
      id: FamilyStudioSectionId.cubeAndSpatial,
      icon: LucideIcons.box,
      iconColor: Color(0xFF00B8A9),
      routeSuffix: 'cube-and-spatial',
    ),
    FamilyStudioSectionId.progressSnapshot: FamilyStudioSectionMeta(
      id: FamilyStudioSectionId.progressSnapshot,
      icon: LucideIcons.trendingUp,
      iconColor: Color(0xFF34C759),
      routeSuffix: 'progress',
    ),
    FamilyStudioSectionId.tutorTools: FamilyStudioSectionMeta(
      id: FamilyStudioSectionId.tutorTools,
      icon: LucideIcons.clipboardList,
      iconColor: Color(0xFF8A9DC0),
      routeSuffix: 'tutor-tools',
      teacherOnly: true,
    ),
  };
}
