class Dokumen {
  final int id;
  final String judul;
  final String filePath;
  final DateTime tglUpload;
  final User user;

  Dokumen({
    required this.id,
    required this.judul,
    required this.filePath,
    required this.tglUpload,
    required this.user,
  });

  factory Dokumen.fromJson(Map<String, dynamic> json) {
    return Dokumen(
      id: json['id_dokumen'],
      judul: json['judul_dokumen'],
      filePath: json['file_path'],
      tglUpload: DateTime.parse(json['tgl_upload']),
      user: User.fromJson(json['user']),
    );
  }
}

class User {
  final int id;
  final String name;
  final String email;
  final String role;
  final int idFakultas;

  User({
    required this.id,
    required this.name,
    required this.email,
    required this.role,
    required this.idFakultas,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id_user'],
      name: json['name'],
      email: json['email'],
      role: json['role'],
      idFakultas: json['id_fakultas'],
    );
  }
}
