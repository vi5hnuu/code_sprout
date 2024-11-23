enum ProblemCategory {
    EASY(value: "EASY"),
    MEDIUM(value: "MEDIUM"),
    HARD(value: "HARD");

    final String value;

    const ProblemCategory({required this.value});

    static ProblemCategory? fromValue(String value){
        return ProblemCategory.values.firstWhere((e) => e.value == value);
    }
}
