// @dart=2.9

class Ads {
  final int adsVal;
  final String adsDetail;
  final String colorVal;
  Ads(this.adsDetail,this.adsVal,this.colorVal);

  Ads.fromMap(Map<String, dynamic> map)
      : assert(map['adsDetail'] != null),
        assert(map['adsVal'] != null),
        assert(map['colorVal'] != null),
        adsDetail = map['adsDetail'],
        adsVal = map['adsVal'],
        colorVal=map['colorVal'];

  @override
  String toString() => "Record<$adsVal:$adsDetail>";
}