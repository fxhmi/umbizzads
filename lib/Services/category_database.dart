

class Ads {
  final String adsVal;
  final String adsDetails;
  final String colorVal;


  Ads.fromMap(Map<String, dynamic> map)
      : assert(map['adsDetail'] != null),
        assert(map['adsVal'] != null),
        assert(map['colorVal'] != null),
        adsDetails = map['adsDetail'],
        adsVal = map['adsVal'],
        colorVal=map['colorVal'];



  @override
  String toString() => "Record<$adsVal:$adsDetails:$colorVal>";
}
