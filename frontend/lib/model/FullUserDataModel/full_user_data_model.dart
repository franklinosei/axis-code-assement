class FullUserDataModel {
  String? employment_date;
  String? designation;
  String? job_grade;
  String? employment_type;
  String? branch;
  String? hod_name;
  String? contract_freq_code;
  String? contract_duration;
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
  String? email;
  bool? is_superuser;
  bool? is_active;

  FullUserDataModel(
      {this.employee_id,
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
      this.employment_date,
      this.designation,
      this.job_grade,
      this.employment_type,
      this.branch,
      this.hod_name,
      this.contract_freq_code,
      this.contract_duration,
      this.email,
      this.is_active,
      this.is_superuser});

  factory FullUserDataModel.fromJson(Map<String, dynamic> json) {
    return FullUserDataModel(
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
      passport_photo: json['passport_photo'],
      employment_date: json['employment_date'],
      designation: json['designation'],
      job_grade: json['job_grade'],
      employment_type: json['employment_type'],
      branch: json['branch'],
      hod_name: json['hod_name'],
      contract_freq_code: json['contract_freq_code'],
      contract_duration: json['contract_duration'],
      email: json['email'],
      is_active: json['is_active'],
      is_superuser: json['is_superuser'],
    );
  }
}
