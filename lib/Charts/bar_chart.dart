class Sales {
  // final String income;
  // final String spend;
  //
  //
  // Sales.fromMap(Map<String, dynamic> map)
  //     : assert(map['income'] != null),
  //       assert(map['spend'] != null),
  //       income = map['income'],
  //       spend = map['spend'];
  //
  //
  // @override
  // String toString() => "Record<$income:$spend>";

  final String value;
  final String details;
  final String colorVal;


  Sales.fromMap(Map<String, dynamic> map)
      : assert(map['value'] != null),
        assert(map['details'] != null),
        assert(map['colorVal'] != null),
        value = map['value'],
        details = map['details'],
        colorVal=map['colorVal'];



  @override
  String toString() => "Record<$value:$details$colorVal>";
}