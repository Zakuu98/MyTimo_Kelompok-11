import 'package:flutter/material.dart';
import '../models/treatment_model.dart';

/// Provider untuk modul Treatment & Prevention Management
/// Anggota 3: Athaya Nasywa Mahira - 2411523028
class TreatmentProvider extends ChangeNotifier {
  List<TreatmentPlan> _plans = [];

  TreatmentProvider() {
    _plans = List.from(TreatmentDummyData.samplePlans);
  }

  // =========================================================================
  // Getters
  // =========================================================================

  List<TreatmentPlan> get plans => List.unmodifiable(_plans);

  List<TreatmentPlan> get activePlans => _plans
      .where((p) =>
          p.status == TreatmentStatus.sedangBerjalan ||
          p.status == TreatmentStatus.belumDimulai)
      .toList();

  List<TreatmentPlan> get completedPlans =>
      _plans.where((p) => p.status == TreatmentStatus.selesai).toList();

  List<TreatmentPlan> get overduePlans =>
      _plans.where((p) => p.isOverdue).toList();

  // =========================================================================
  // CRUD Operations
  // =========================================================================

  void createPlan(TreatmentPlan plan) {
    _plans.insert(0, plan);
    notifyListeners();
  }

  void updatePlan(TreatmentPlan updatedPlan) {
    final index = _plans.indexWhere((p) => p.id == updatedPlan.id);
    if (index != -1) {
      _plans[index] = updatedPlan;
      notifyListeners();
    }
  }

  void deletePlan(String planId) {
    _plans.removeWhere((p) => p.id == planId);
    notifyListeners();
  }

  TreatmentPlan? getPlanById(String planId) {
    try {
      return _plans.firstWhere((p) => p.id == planId);
    } catch (_) {
      return null;
    }
  }

  // =========================================================================
  // Step Operations
  // =========================================================================

  void updateStepStatus(String planId, String stepId, bool isCompleted) {
    final planIndex = _plans.indexWhere((p) => p.id == planId);
    if (planIndex == -1) return;

    final plan = _plans[planIndex];
    final updatedSteps = plan.steps.map((step) {
      if (step.id == stepId) {
        return step.copyWith(
          isCompleted: isCompleted,
          completedAt: isCompleted ? DateTime.now() : null,
        );
      }
      return step;
    }).toList();

    final allCompleted = updatedSteps.every((s) => s.isCompleted);
    final anyCompleted = updatedSteps.any((s) => s.isCompleted);
    TreatmentStatus newStatus = plan.status;

    if (allCompleted) {
      newStatus = TreatmentStatus.selesai;
    } else if (anyCompleted && plan.status == TreatmentStatus.belumDimulai) {
      newStatus = TreatmentStatus.sedangBerjalan;
    }

    _plans[planIndex] = plan.copyWith(steps: updatedSteps, status: newStatus);
    notifyListeners();
  }

  // =========================================================================
  // Progress
  // =========================================================================

  TreatmentProgress getProgressForPlan(String planId) {
    final plan = getPlanById(planId);
    if (plan == null) {
      return TreatmentProgress(
        planId: planId,
        completedSteps: 0,
        totalSteps: 0,
        lastUpdated: DateTime.now(),
      );
    }

    final completed = plan.steps.where((s) => s.isCompleted).length;
    DateTime lastUpdated = plan.createdAt;
    for (final step in plan.steps) {
      if (step.completedAt != null && step.completedAt!.isAfter(lastUpdated)) {
        lastUpdated = step.completedAt!;
      }
    }

    return TreatmentProgress(
      planId: planId,
      completedSteps: completed,
      totalSteps: plan.steps.length,
      lastUpdated: lastUpdated,
    );
  }

  // =========================================================================
  // Utility
  // =========================================================================

  String generateId() => 'tp-${DateTime.now().millisecondsSinceEpoch}';

  String generateStepId() => 'step-${DateTime.now().millisecondsSinceEpoch}';
}

