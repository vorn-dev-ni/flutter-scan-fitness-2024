class HealthDataPoint {
  String? uuid;
  Value? value;
  String? type;
  String? unit;
  String? dateFrom;
  String? dateTo;
  String? sourcePlatform;
  String? sourceDeviceId;
  String? sourceName;
  String? recordingMethod;

  HealthDataPoint(
      {this.uuid,
      this.value,
      this.type,
      this.unit,
      this.dateFrom,
      this.dateTo,
      this.sourcePlatform,
      this.sourceDeviceId,
      this.sourceName,
      this.recordingMethod});

  HealthDataPoint.fromJson(Map<String, dynamic> json) {
    uuid = json['uuid'];
    value = json['value'] != null ? new Value.fromJson(json['value']) : null;
    type = json['type'];
    unit = json['unit'];
    dateFrom = json['date_from'];
    dateTo = json['date_to'];
    sourcePlatform = json['source_platform'];
    sourceDeviceId = json['source_device_id'];
    sourceName = json['source_name'];
    recordingMethod = json['recording_method'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['uuid'] = this.uuid;
    if (this.value != null) {
      data['value'] = this.value!.toJson();
    }
    data['type'] = this.type;
    data['unit'] = this.unit;
    data['date_from'] = this.dateFrom;
    data['date_to'] = this.dateTo;
    data['source_platform'] = this.sourcePlatform;
    data['source_device_id'] = this.sourceDeviceId;
    data['source_name'] = this.sourceName;
    data['recording_method'] = this.recordingMethod;
    return data;
  }
}

class Value {
  String? sType;
  int? numericValue;

  Value({this.sType, this.numericValue});

  Value.fromJson(Map<String, dynamic> json) {
    sType = json['__type'];
    numericValue = json['numeric_value'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['__type'] = this.sType;
    data['numeric_value'] = this.numericValue;
    return data;
  }
}
