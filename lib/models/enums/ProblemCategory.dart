enum ProblemCategory {
    EASY(value: "easy"),
    MEDIUM(value: "medium"),
    HARD(value: "hard");

    final String value;

    const ProblemCategory({required this.value});

    static ProblemCategory? fromValue(String value){
        return ProblemCategory.values.firstWhere((e) => e.value == value);
    }
}
