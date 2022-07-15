class BioDataModel {
  String? employee_id;
  String? staff_no;
  String? appointment_date;
  String? ssnit_no;
  String? dob;
  String? title;
  String? surname;
  String? other_name;
  String? gender_code;
  String? marital_status;
  String? cellphone;
  String? address;
  dynamic passport_photo;

  BioDataModel({
    this.employee_id,
    this.staff_no,
    this.appointment_date,
    this.ssnit_no,
    this.dob,
    this.title,
    this.surname,
    this.other_name,
    this.gender_code,
    this.marital_status,
    this.cellphone,
    this.address,
    this.passport_photo,
  });

  factory BioDataModel.fromJson(Map<String, dynamic> json) {
    return BioDataModel(
        employee_id: json['employee_id'],
        staff_no: json['staff_no'],
        appointment_date: json['appointment_date'],
        ssnit_no: json['ssnit_no'],
        dob: json['dob'],
        title: json['title'],
        surname: json['surname'],
        other_name: json['other_name'],
        gender_code: json['gender_code'],
        marital_status: json['marital_status'],
        cellphone: json['cellphone'],
        address: json['address'],
        passport_photo: json['passport_photo']
    );
  }

  Map<String, dynamic> toJson() {
    return {
        "employee_id": employee_id,
        "staff_no": staff_no,
        "appointment_date": appointment_date,
        "ssnit_no": ssnit_no,
        "dob": dob,
        "title": title,
        "surname": surname,
        "other_name": other_name,
        "gender_code": gender_code,
        "marital_status": marital_status,
        "cellphone": cellphone,
        "address": address,
        "passport_photo": passport_photo,
    };
  }
}
