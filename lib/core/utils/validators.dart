abstract final class Validators {
  static String? validateDisplayName(String value) {
    final trimmed = value.trim();
    if (trimmed.isEmpty) {
      return 'Display name is required.';
    }
    if (trimmed.length > 30) {
      return 'Display name must be 30 characters or fewer.';
    }
    return null;
  }

  static String? validateCaseDescription(String value) {
    final trimmed = value.trim();
    if (trimmed.length < 50) {
      return 'Description must be at least 50 characters.';
    }
    if (trimmed.length > 500) {
      return 'Description must be 500 characters or fewer.';
    }
    return null;
  }

  static String? validateQuestion(String value) {
    final trimmed = value.trim();
    if (trimmed.isEmpty) {
      return 'Question is required.';
    }
    if (trimmed.length > 100) {
      return 'Question must be 100 characters or fewer.';
    }
    return null;
  }
}
