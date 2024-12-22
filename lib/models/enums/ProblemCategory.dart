enum ProblemDifficulty {
    EASY(value: "EASY"),
    MEDIUM(value: "MEDIUM"),
    HARD(value: "HARD");

    final String value;

    const ProblemDifficulty({required this.value});

    static ProblemDifficulty? fromValue(String value){
        return ProblemDifficulty.values.firstWhere((e) => e.value == value);
    }
}
