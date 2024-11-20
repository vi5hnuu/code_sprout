enum ProblemLanguage {
    CPP(value:"cpp");

    final String value;

    const ProblemLanguage({required this.value});

    static ProblemLanguage? fromValue(String value){
        return ProblemLanguage.values.firstWhere((e) => e.value == value);
    }
}
