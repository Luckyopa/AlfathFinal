import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';

class TambahKegiatanPage extends StatefulWidget {
  const TambahKegiatanPage({Key? key}) : super(key: key);

  @override
  State<TambahKegiatanPage> createState() => _TambahKegiatanPageState();
}

class _TambahKegiatanPageState extends State<TambahKegiatanPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _namaController = TextEditingController();
  final TextEditingController _tanggalController = TextEditingController();
  final TextEditingController _waktuController = TextEditingController();
  final TextEditingController _tempatController = TextEditingController();
  final TextEditingController _kuotaController = TextEditingController();
  final TextEditingController _cpController = TextEditingController();
  final TextEditingController _deskripsiController = TextEditingController();
  String? fileName;

  Future<void> pickFile() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(type: FileType.image);
    if (result != null) {
      setState(() {
        fileName = result.files.single.name;
      });
    }
  }

  Future<void> _pickTanggal() async {
    DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );
    if (picked != null) {
      _tanggalController.text = "${picked.day}-${picked.month}-${picked.year}";
    }
  }

  Future<void> _pickWaktu() async {
    TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );
    if (picked != null) {
      _waktuController.text = picked.format(context);
    }
  }

  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Form berhasil divalidasi!")),
      );
      Navigator.pop(context);
    }
  }

  InputDecoration _inputDecoration(String hint, IconData? icon) {
    return InputDecoration(
      hintText: hint,
      filled: true,
      fillColor: Colors.white,
      suffixIcon: icon != null ? Icon(icon, color: Colors.grey) : null,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: BorderSide.none,
      ),
    );
  }

  Widget _buildFormField({
    required String label,
    required TextEditingController controller,
    required String hintText,
    IconData? icon,
    int maxLines = 1,
    VoidCallback? onTap,
    bool readOnly = false,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(fontWeight: FontWeight.bold)),
        const SizedBox(height: 6),
        Container(
          decoration: BoxDecoration(
            color: Colors.white,
            boxShadow: [
              BoxShadow(color: Colors.grey.shade300, blurRadius: 6, offset: const Offset(3, 3)),
              const BoxShadow(color: Colors.white, blurRadius: 6, offset: Offset(-3, -3)),
            ],
            borderRadius: BorderRadius.circular(16),
          ),
          child: TextFormField(
            controller: controller,
            validator: (value) => value == null || value.isEmpty ? 'Wajib diisi' : null,
            readOnly: readOnly,
            onTap: onTap,
            maxLines: maxLines,
            decoration: _inputDecoration(hintText, icon),
          ),
        ),
        const SizedBox(height: 14),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffF6F6F6),
      body: Column(
        children: [
          // HEADER
          Container(
            width: double.infinity,
            padding: const EdgeInsets.fromLTRB(16, 50, 16, 24),
            decoration: BoxDecoration(
              color: Colors.red.shade700,
              borderRadius: const BorderRadius.only(
                bottomLeft: Radius.circular(40),
                bottomRight: Radius.circular(40),
              ),
            ),
            child: Row(
              children: [
                IconButton(
                  onPressed: () => Navigator.pop(context),
                  icon: const Icon(Icons.arrow_back, color: Colors.white),
                ),
                const SizedBox(width: 8),
                const Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Kegiatan', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white)),
                    SizedBox(height: 2),
                    Text('Tambah Kegiatan', style: TextStyle(fontSize: 14, color: Colors.white70)),
                  ],
                ),
              ],
            ),
          ),

          // FORM
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(24),
              child: Form(
                key: _formKey,
                child: Column(
                  children: [
                    _buildFormField(label: "Nama Kegiatan", controller: _namaController, hintText: "Masukan Nama Kegiatan"),
                    _buildFormField(
                      label: "Tanggal",
                      controller: _tanggalController,
                      hintText: "Pilih Tanggal",
                      icon: Icons.calendar_today,
                      readOnly: true,
                      onTap: _pickTanggal,
                    ),
                    _buildFormField(
                      label: "Waktu",
                      controller: _waktuController,
                      hintText: "Pilih Waktu",
                      icon: Icons.access_time,
                      readOnly: true,
                      onTap: _pickWaktu,
                    ),
                    _buildFormField(label: "Tempat Kegiatan", controller: _tempatController, hintText: "Masukan Tempat", icon: Icons.location_on),
                    _buildFormField(label: "Kuota Pendaftaran", controller: _kuotaController, hintText: "Masukan Kuota Pendaftaran", icon: Icons.group),
                    _buildFormField(label: "Contact Person", controller: _cpController, hintText: "Masukan kontak penyelenggara", icon: Icons.phone),

                    // FOTO
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text("Masukan Foto Banner", style: TextStyle(fontWeight: FontWeight.bold)),
                        const SizedBox(height: 6),
                        Row(
                          children: [
                            Expanded(
                              child: Container(
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  boxShadow: [
                                    BoxShadow(color: Colors.grey.shade300, blurRadius: 6, offset: const Offset(3, 3)),
                                    const BoxShadow(color: Colors.white, blurRadius: 6, offset: Offset(-3, -3)),
                                  ],
                                  borderRadius: BorderRadius.circular(16),
                                ),
                                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 16),
                                child: Text(fileName ?? 'Masukan Foto', style: TextStyle(color: Colors.grey[600])),
                              ),
                            ),
                            const SizedBox(width: 10),
                            ElevatedButton(
                              onPressed: pickFile,
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.red.shade700,
                                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                              ),
                              child: const Text("Pilih Foto", style: TextStyle(color: Colors.white)),
                            ),
                          ],
                        ),
                      ],
                    ),

                    const SizedBox(height: 14),

                    _buildFormField(
                      label: "Deskripsi Kegiatan",
                      controller: _deskripsiController,
                      hintText: "Masuk Deskripsi Kegiatan",
                      icon: Icons.description_outlined,
                      maxLines: 4,
                    ),

                    Row(
                      children: [
                        Expanded(
                          child: OutlinedButton(
                            onPressed: () => Navigator.pop(context),
                            style: OutlinedButton.styleFrom(
                              side: const BorderSide(color: Colors.black12),
                              padding: const EdgeInsets.symmetric(vertical: 16),
                            ),
                            child: const Text("Batalkan", style: TextStyle(color: Colors.black)),
                          ),
                        ),
                        const SizedBox(width: 20),
                        Expanded(
                          child: ElevatedButton(
                            onPressed: _submitForm,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.red.shade700,
                              padding: const EdgeInsets.symmetric(vertical: 16),
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                            ),
                            child: const Text("Submit", style: TextStyle(color: Colors.white)),
                          ),
                        ),
                      ],
                    )
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
