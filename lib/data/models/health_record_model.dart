/// Health Record data model
/// Represents a single day's health tracking entry
class HealthRecord {
  final int? id;
  final String date; // ISO 8601 format: yyyy-MM-dd
  final int steps;
  final int calories;
  final int water; // in milliliters
  final String createdAt; // ISO 8601 timestamp
  final String updatedAt; // ISO 8601 timestamp

  HealthRecord({
    this.id,
    required this.date,
    required this.steps,
    required this.calories,
    required this.water,
    required this.createdAt,
    required this.updatedAt,
  });

  // ==================== FACTORY CONSTRUCTORS ====================

  /// Create HealthRecord from database map
  factory HealthRecord.fromMap(Map<String, dynamic> map) {
    return HealthRecord(
      id: map['id'] as int?,
      date: map['date'] as String,
      steps: map['steps'] as int,
      calories: map['calories'] as int,
      water: map['water'] as int,
      createdAt: map['created_at'] as String,
      updatedAt: map['updated_at'] as String,
    );
  }

  /// Create a new HealthRecord with current timestamp
  factory HealthRecord.create({
    required String date,
    required int steps,
    required int calories,
    required int water,
  }) {
    final now = DateTime.now().toIso8601String();
    return HealthRecord(
      date: date,
      steps: steps,
      calories: calories,
      water: water,
      createdAt: now,
      updatedAt: now,
    );
  }

  // ==================== CONVERSION METHODS ====================

  /// Convert HealthRecord to database map (for INSERT/UPDATE)
  Map<String, dynamic> toMap() {
    return {
      if (id != null) 'id': id,
      'date': date,
      'steps': steps,
      'calories': calories,
      'water': water,
      'created_at': createdAt,
      'updated_at': updatedAt,
    };
  }

  /// Convert to map for update (excludes id and created_at)
  Map<String, dynamic> toUpdateMap() {
    return {
      'date': date,
      'steps': steps,
      'calories': calories,
      'water': water,
      'updated_at': DateTime.now().toIso8601String(),
    };
  }

  // ==================== COPY METHODS ====================

  /// Create a copy of this record with optional updated fields
  HealthRecord copyWith({
    int? id,
    String? date,
    int? steps,
    int? calories,
    int? water,
    String? createdAt,
    String? updatedAt,
  }) {
    return HealthRecord(
      id: id ?? this.id,
      date: date ?? this.date,
      steps: steps ?? this.steps,
      calories: calories ?? this.calories,
      water: water ?? this.water,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  /// Create an updated copy with new values and current timestamp
  HealthRecord update({
    int? steps,
    int? calories,
    int? water,
    String? date,
  }) {
    return HealthRecord(
      id: id,
      date: date ?? this.date,
      steps: steps ?? this.steps,
      calories: calories ?? this.calories,
      water: water ?? this.water,
      createdAt: createdAt,
      updatedAt: DateTime.now().toIso8601String(),
    );
  }

  // ==================== HELPER GETTERS ====================

  /// Get DateTime object from date string
  DateTime get dateTime {
    return DateTime.parse(date);
  }

  /// Get DateTime object from createdAt string
  DateTime get createdAtDateTime {
    return DateTime.parse(createdAt);
  }

  /// Get DateTime object from updatedAt string
  DateTime get updatedAtDateTime {
    return DateTime.parse(updatedAt);
  }

  /// Check if this record is for today
  bool get isToday {
    final now = DateTime.now();
    final recordDate = dateTime;
    return now.year == recordDate.year &&
        now.month == recordDate.month &&
        now.day == recordDate.day;
  }

  /// Get total health score (simple calculation for demo)
  /// This is a basic health score calculation
  int get healthScore {
    // Simple scoring: 30% steps, 30% calories, 40% water
    final stepsScore = (steps / 10000 * 30).clamp(0, 30).toInt();
    final caloriesScore = (calories / 2500 * 30).clamp(0, 30).toInt();
    final waterScore = (water / 2000 * 40).clamp(0, 40).toInt();
    return stepsScore + caloriesScore + waterScore;
  }

  // ==================== COMPARISON & EQUALITY ====================

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is HealthRecord &&
        other.id == id &&
        other.date == date &&
        other.steps == steps &&
        other.calories == calories &&
        other.water == water;
  }

  @override
  int get hashCode {
    return Object.hash(
      id,
      date,
      steps,
      calories,
      water,
    );
  }

  // ==================== STRING REPRESENTATION ====================

  @override
  String toString() {
    return 'HealthRecord(id: $id, date: $date, steps: $steps, '
        'calories: $calories, water: $water, '
        'createdAt: $createdAt, updatedAt: $updatedAt)';
  }

  /// Get a human-readable summary
  String toSummary() {
    return 'Date: $date\n'
        'Steps: $steps\n'
        'Calories: $calories kcal\n'
        'Water: ${water}ml';
  }

  // ==================== VALIDATION ====================

  /// Validate if the record has valid values
  bool get isValid {
    return steps >= 0 &&
        steps <= 50000 &&
        calories >= 0 &&
        calories <= 10000 &&
        water >= 0 &&
        water <= 10000 &&
        date.isNotEmpty;
  }

  /// Get validation errors (if any)
  List<String> get validationErrors {
    final errors = <String>[];

    if (date.isEmpty) {
      errors.add('Date is required');
    }

    if (steps < 0) {
      errors.add('Steps cannot be negative');
    } else if (steps > 50000) {
      errors.add('Steps value is too high (max: 50,000)');
    }

    if (calories < 0) {
      errors.add('Calories cannot be negative');
    } else if (calories > 10000) {
      errors.add('Calories value is too high (max: 10,000)');
    }

    if (water < 0) {
      errors.add('Water cannot be negative');
    } else if (water > 10000) {
      errors.add('Water value is too high (max: 10,000ml)');
    }

    return errors;
  }
}