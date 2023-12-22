class GeneratedTable {
  int? id;
  int tableNumber;
  int upperLimit;
  int lowerLimit;
  List<int> generatedTableEntries;

  GeneratedTable({
    this.id,
    required this.tableNumber,
    required this.upperLimit,
    required this.lowerLimit,
    required this.generatedTableEntries,
  });

  String serializeTableEntries() {
    return generatedTableEntries.join(',');
  }

  void deserializeTableEntries(String entriesString) {
    generatedTableEntries = entriesString.split(',').map(int.parse).toList();
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'tableNumber': tableNumber,
      'upperLimit': upperLimit,
      'lowerLimit': lowerLimit,
      'generatedTableEntries': serializeTableEntries(),
    };
  }

  static GeneratedTable fromMap(Map<String, dynamic> map) {
    var table = GeneratedTable(
      id: map['id'],
      tableNumber: map['tableNumber'],
      upperLimit: map['upperLimit'],
      lowerLimit: map['lowerLimit'],
      generatedTableEntries: [], // Initialize an empty list
    );
    table.deserializeTableEntries(map['generatedTableEntries']);
    return table;
  }

  List<int> generateEntries() {
    List<int> tableEntries = [];

    for (int i = lowerLimit; i <= upperLimit; i++) {
      int result = tableNumber * i;
      tableEntries.add(result);
    }

    return tableEntries;
  }
}
