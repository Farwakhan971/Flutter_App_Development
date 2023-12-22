class CalculatorBrain {
  CalculatorBrain({
    required this.table_number,
    required this.upper_limit,
    required this.lower_limit,
  });

  final int table_number;
  final int upper_limit;
  final int lower_limit;

  List<int> generateTable() {
    List<int> tableEntries = [];

    for (int i = lower_limit; i <= upper_limit; i++) {
      int result = table_number * i;
      tableEntries.add(result);
    }

    return tableEntries;
  }
}
