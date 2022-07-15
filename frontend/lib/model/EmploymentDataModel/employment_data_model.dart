class EmploymentDataModel {
  String? employment_date;
  String? designation;
  String? job_grade;
  String? employment_type;
  String? branch;
  String? hod_name;
  String? contract_freq_code;
  String? contract_duration;

  EmploymentDataModel({
    this.employment_date,
    this.designation,
    this.job_grade,
    this.employment_type,
    this.branch,
    this.hod_name,
    this.contract_freq_code,
    this.contract_duration,
  });

  factory EmploymentDataModel.fromJson(Map<String, dynamic> json) {
    return EmploymentDataModel(
      employment_date: json['employment_date'],
      designation: json['designation'],
      job_grade: json['job_grade'],
      employment_type: json['employment_type'],
      branch: json['branch'],
      hod_name: json['hod_name'],
      contract_freq_code: json['contract_freq_code'],
      contract_duration: json['contract_duration'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "employment_date": employment_date,
      "designation": designation,
      "job_grade": job_grade,
      "employment_type": employment_type,
      "branch": branch,
      "hod_name": hod_name,
      "contract_freq_code": contract_freq_code,
      "contract_duration": contract_duration,
    };
  }
}
