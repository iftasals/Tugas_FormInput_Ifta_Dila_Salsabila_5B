import 'package:flutter/material.dart';

class FormPenilaianPage extends StatefulWidget {
  const FormPenilaianPage({super.key});

  @override
  _FormPenilaianPageState createState() => _FormPenilaianPageState();
}

class _FormPenilaianPageState extends State<FormPenilaianPage> {
  final _formKey = GlobalKey<FormState>();

  String _nama = '';
  String _email = '';
  String _mataKuliah = '';
  double _nilaiTugas = 0;
  double _nilaiUts = 0;
  double _nilaiUas = 0;
  String _komentar = '';

  final List<String> _daftarMataKuliah = [
    'Pemrograman Mobile',
    'Basis Data',
    'Jaringan Komputer',
    'Sistem Operasi',
    'Pemrograman Web',
    'Kecerdasan Buatan',
  ];

  List<Map<String, dynamic>> _dataPenilaian = [];
  int? _selectedIndex; 

  double _hitungNilaiAkhir() {
    return (_nilaiTugas * 0.3) + (_nilaiUts * 0.3) + (_nilaiUas * 0.4);
  }

  String _getGrade(double nilai) {
    if (nilai >= 85) return 'A';
    if (nilai >= 75) return 'B';
    if (nilai >= 65) return 'C';
    if (nilai >= 55) return 'D';
    return 'E';
  }

  Color _getGradeColor(String grade) {
    switch (grade) {
      case 'A':
        return const Color(0xFF4CAF50);
      case 'B':
        return const Color(0xFF8BC34A);
      case 'C':
        return const Color(0xFFFFC107);
      case 'D':
        return const Color(0xFFFF9800);
      case 'E':
        return const Color(0xFFF44336);
      default:
        return Colors.grey;
    }
  }

  void _tambahData() {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();

      double nilaiAkhir = _hitungNilaiAkhir();
      String grade = _getGrade(nilaiAkhir);

      Map<String, dynamic> dataBaru = {
        'nama': _nama,
        'email': _email,
        'mataKuliah': _mataKuliah,
        'nilaiTugas': _nilaiTugas,
        'nilaiUts': _nilaiUts,
        'nilaiUas': _nilaiUas,
        'nilaiAkhir': nilaiAkhir,
        'grade': grade,
        'komentar': _komentar,
        'tanggal': DateTime.now(),
      };

      setState(() {
        _dataPenilaian.add(dataBaru);
      });

      _resetForm();
      _showSnackbar('Data berhasil ditambahkan!');
    }
  }

  void _lihatDetailMobile(int index) {
    Map<String, dynamic> data = _dataPenilaian[index];

    showDialog(
      context: context,
      builder: (context) => Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        child: ConstrainedBox(
          constraints: BoxConstraints(
            maxHeight: MediaQuery.of(context).size.height * 0.8,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.grey.shade800,
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(15),
                    topRight: Radius.circular(15),
                  ),
                ),
                child: Row(
                  children: [
                    CircleAvatar(
                      backgroundColor: _getGradeColor(data['grade']),
                      child: Text(
                        data['grade'],
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Detail Nilai',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w600,
                              color: Colors.white,
                            ),
                          ),
                          Text(
                            data['nama'],
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.grey.shade300,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      _buildDetailSectionMobile(
                        'Informasi Mahasiswa',
                        Icons.person,
                        [
                          _buildDetailRowMobile('Nama', data['nama']),
                          _buildDetailRowMobile('Email', data['email']),
                        ],
                      ),

                      const SizedBox(height: 15),

                      // Info Mata Kuliah
                      _buildDetailSectionMobile(
                        'Mata Kuliah',
                        Icons.menu_book,
                        [
                          _buildDetailRowMobile(
                            'Mata Kuliah',
                            data['mataKuliah'],
                          ),
                        ],
                      ),

                      const SizedBox(height: 15),

                      _buildDetailSectionMobile(
                        'Detail Nilai',
                        Icons.assessment,
                        [
                          Row(
                            children: [
                              Expanded(
                                child: _buildDetailRowMobile(
                                  'Nilai Tugas',
                                  '${data['nilaiTugas']}',
                                ),
                              ),
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 8,
                                  vertical: 4,
                                ),
                                decoration: BoxDecoration(
                                  color: Colors.grey.shade200,
                                  borderRadius: BorderRadius.circular(4),
                                ),
                                child: Text(
                                  '30%',
                                  style: TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.w600,
                                    color: Colors.grey.shade800,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          Row(
                            children: [
                              Expanded(
                                child: _buildDetailRowMobile(
                                  'Nilai UTS',
                                  '${data['nilaiUts']}',
                                ),
                              ),
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 8,
                                  vertical: 4,
                                ),
                                decoration: BoxDecoration(
                                  color: Colors.grey.shade200,
                                  borderRadius: BorderRadius.circular(4),
                                ),
                                child: Text(
                                  '30%',
                                  style: TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.w600,
                                    color: Colors.grey.shade800,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          Row(
                            children: [
                              Expanded(
                                child: _buildDetailRowMobile(
                                  'Nilai UAS',
                                  '${data['nilaiUas']}',
                                ),
                              ),
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 8,
                                  vertical: 4,
                                ),
                                decoration: BoxDecoration(
                                  color: Colors.grey.shade200,
                                  borderRadius: BorderRadius.circular(4),
                                ),
                                child: Text(
                                  '40%',
                                  style: TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.w600,
                                    color: Colors.grey.shade800,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const Divider(height: 20),
                          _buildDetailRowMobile(
                            'Nilai Akhir',
                            '${data['nilaiAkhir'].toStringAsFixed(2)}',
                            isBold: true,
                            valueColor: _getGradeColor(data['grade']),
                          ),
                          _buildDetailRowMobile(
                            'Grade',
                            data['grade'],
                            isBold: true,
                            valueColor: _getGradeColor(data['grade']),
                          ),
                        ],
                      ),

                      const SizedBox(height: 15),

                      if (data['komentar'] != null &&
                          data['komentar'].toString().isNotEmpty)
                        _buildDetailSectionMobile('Komentar', Icons.comment, [
                          Padding(
                            padding: const EdgeInsets.only(top: 4),
                            child: Text(
                              data['komentar'].toString(),
                              style: TextStyle(
                                color: Colors.grey.shade700,
                                fontSize: 14,
                              ),
                            ),
                          ),
                        ]),

                      const SizedBox(height: 10),

                      Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: Colors.grey.shade100,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Row(
                          children: [
                            Icon(
                              Icons.calendar_today,
                              size: 14,
                              color: Colors.grey.shade600,
                            ),
                            const SizedBox(width: 8),
                            Text(
                              'Dicatat: ${_formatTanggal(data['tanggal'])}',
                              style: TextStyle(
                                fontSize: 12,
                                color: Colors.grey.shade600,
                                fontStyle: FontStyle.italic,
                              ),
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 20),
                    ],
                  ),
                ),
              ),

              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  border: Border(top: BorderSide(color: Colors.grey.shade300)),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    ElevatedButton(
                      onPressed: () => Navigator.of(context).pop(),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.grey.shade800,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 30,
                          vertical: 10,
                        ),
                      ),
                      child: const Text('Tutup'),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _lihatDetail(int index) {
    Map<String, dynamic> data = _dataPenilaian[index];

    final isMobile = MediaQuery.of(context).size.width < 600;

    if (isMobile) {
      _lihatDetailMobile(index);
    } else {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => PenilaianPage(
            nama: data['nama'],
            email: data['email'],
            mataKuliah: data['mataKuliah'],
            nilaiTugas: data['nilaiTugas'],
            nilaiUts: data['nilaiUts'],
            nilaiUas: data['nilaiUas'],
            nilaiAkhir: data['nilaiAkhir'],
            grade: data['grade'],
            komentar: data['komentar'],
          ),
        ),
      );
    }
  }

  void _editData(int index) {
    Map<String, dynamic> data = _dataPenilaian[index];

    setState(() {
      _selectedIndex = index;
      _nama = data['nama'];
      _email = data['email'];
      _mataKuliah = data['mataKuliah'];
      _nilaiTugas = data['nilaiTugas'];
      _nilaiUts = data['nilaiUts'];
      _nilaiUas = data['nilaiUas'];
      _komentar = data['komentar'] ?? '';
    });

    // Scroll ke atas form
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final context = _formKey.currentContext;
      if (context != null) {
        Scrollable.ensureVisible(
          context,
          duration: const Duration(milliseconds: 300),
        );
      }
    });

    _showSnackbar('Mode edit aktif. Silakan edit data di atas.');
  }

  void _updateData() {
    if (_selectedIndex != null && _formKey.currentState!.validate()) {
      _formKey.currentState!.save();

      double nilaiAkhir = _hitungNilaiAkhir();
      String grade = _getGrade(nilaiAkhir);

      Map<String, dynamic> dataUpdate = {
        'nama': _nama,
        'email': _email,
        'mataKuliah': _mataKuliah,
        'nilaiTugas': _nilaiTugas,
        'nilaiUts': _nilaiUts,
        'nilaiUas': _nilaiUas,
        'nilaiAkhir': nilaiAkhir,
        'grade': grade,
        'komentar': _komentar,
        'tanggal': DateTime.now(),
      };

      setState(() {
        _dataPenilaian[_selectedIndex!] = dataUpdate;
        _selectedIndex = null;
      });

      _resetForm();
      _showSnackbar('Data berhasil diupdate!');
    }
  }

  void _hapusData(int index) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Konfirmasi Hapus'),
        content: const Text('Apakah Anda yakin ingin menghapus data ini?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Batal'),
          ),
          TextButton(
            onPressed: () {
              setState(() {
                _dataPenilaian.removeAt(index);
                if (_selectedIndex == index) {
                  _selectedIndex = null;
                  _resetForm();
                }
              });
              Navigator.pop(context);
              _showSnackbar('Data berhasil dihapus!');
            },
            child: const Text('Hapus', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  void _resetForm() {
    _formKey.currentState?.reset();
    setState(() {
      _nama = '';
      _email = '';
      _mataKuliah = '';
      _nilaiTugas = 0;
      _nilaiUts = 0;
      _nilaiUas = 0;
      _komentar = '';
      _selectedIndex = null;
    });
  }

  void _showSnackbar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.grey.shade800,
        duration: const Duration(seconds: 2),
      ),
    );
  }

  String _formatTanggal(DateTime tanggal) {
    return '${tanggal.day}/${tanggal.month}/${tanggal.year} ${tanggal.hour.toString().padLeft(2, '0')}:${tanggal.minute.toString().padLeft(2, '0')}';
  }

  Widget _buildDetailRowMobile(
    String label,
    String value, {
    bool isBold = false,
    Color? valueColor,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            flex: 2,
            child: Text(
              label,
              style: TextStyle(color: Colors.grey.shade600, fontSize: 13),
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            flex: 3,
            child: Text(
              value,
              style: TextStyle(
                fontSize: 13,
                fontWeight: isBold ? FontWeight.bold : FontWeight.normal,
                color: valueColor ?? Colors.grey.shade800,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDetailSectionMobile(
    String title,
    IconData icon,
    List<Widget> children,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(icon, size: 16, color: Colors.grey.shade700),
            const SizedBox(width: 8),
            Text(
              title,
              style: TextStyle(
                fontWeight: FontWeight.w600,
                color: Colors.grey.shade800,
                fontSize: 14,
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: Colors.grey.shade50,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: Colors.grey.shade300),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: children,
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final isMobile = MediaQuery.of(context).size.width < 600;

    return Scaffold(
      backgroundColor: Colors.grey.shade50,
      appBar: AppBar(
        title: Text(
          _selectedIndex != null ? 'Edit Data Penilaian' : 'Form Penilaian',
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w600,
          ),
        ),
        centerTitle: true,
        backgroundColor: Colors.grey.shade800,
        elevation: 4,
        iconTheme: const IconThemeData(color: Colors.white),
        actions: _selectedIndex != null
            ? [
                IconButton(
                  icon: const Icon(Icons.cancel),
                  onPressed: _resetForm,
                  tooltip: 'Batal Edit',
                ),
              ]
            : null,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(
          horizontal: isMobile ? 12.0 : 20.0,
          vertical: isMobile ? 12.0 : 20.0,
        ),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header dengan ikon
              Container(
                width: double.infinity,
                padding: EdgeInsets.all(isMobile ? 16.0 : 20.0),
                decoration: BoxDecoration(
                  color: Colors.grey.shade800,
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.3),
                      blurRadius: 8,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    Icon(
                      Icons.assignment,
                      size: isMobile ? 40.0 : 50.0,
                      color: Colors.grey.shade300,
                    ),
                    SizedBox(height: isMobile ? 8.0 : 10.0),
                    Text(
                      _selectedIndex != null
                          ? 'Edit Data Penilaian'
                          : 'Form Input Penilaian',
                      style: TextStyle(
                        fontSize: isMobile ? 16.0 : 18.0,
                        fontWeight: FontWeight.w600,
                        color: Colors.grey.shade100,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(height: isMobile ? 4.0 : 5.0),
                    Text(
                      _selectedIndex != null
                          ? 'Edit data penilaian yang dipilih'
                          : 'Lengkapi data di bawah ini',
                      style: TextStyle(
                        fontSize: isMobile ? 12.0 : 14.0,
                        color: Colors.grey.shade300,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),

              SizedBox(height: isMobile ? 20.0 : 25.0),

              _buildLabelMobile('Nama Lengkap', isMobile),
              Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.1),
                      blurRadius: 5,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: TextFormField(
                  decoration: InputDecoration(
                    hintText: 'Masukkan nama lengkap',
                    prefixIcon: Icon(Icons.person, color: Colors.grey.shade700),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide.none,
                    ),
                    filled: true,
                    fillColor: Colors.grey.shade50,
                    contentPadding: EdgeInsets.all(isMobile ? 14.0 : 16.0),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Nama harus diisi';
                    }
                    return null;
                  },
                  onSaved: (value) {
                    _nama = value!;
                  },
                  initialValue: _nama,
                ),
              ),

              SizedBox(height: isMobile ? 16.0 : 20.0),

              _buildLabelMobile('Email', isMobile),
              Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.1),
                      blurRadius: 5,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: TextFormField(
                  decoration: InputDecoration(
                    hintText: 'contoh@email.com',
                    prefixIcon: Icon(Icons.email, color: Colors.grey.shade700),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide.none,
                    ),
                    filled: true,
                    fillColor: Colors.grey.shade50,
                    contentPadding: EdgeInsets.all(isMobile ? 14.0 : 16.0),
                  ),
                  keyboardType: TextInputType.emailAddress,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Email harus diisi';
                    }
                    if (!value.contains('@')) {
                      return 'Email tidak valid';
                    }
                    return null;
                  },
                  onSaved: (value) {
                    _email = value!;
                  },
                  initialValue: _email,
                ),
              ),

              SizedBox(height: isMobile ? 16.0 : 20.0),

              _buildLabelMobile('Mata Kuliah', isMobile),
              Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.1),
                      blurRadius: 5,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: DropdownButtonFormField<String>(
                  decoration: InputDecoration(
                    prefixIcon: Icon(
                      Icons.menu_book,
                      color: Colors.grey.shade700,
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide.none,
                    ),
                    filled: true,
                    fillColor: Colors.grey.shade50,
                    contentPadding: EdgeInsets.symmetric(
                      horizontal: isMobile ? 12.0 : 16.0,
                      vertical: isMobile ? 6.0 : 8.0,
                    ),
                  ),
                  value: _mataKuliah.isEmpty ? null : _mataKuliah,
                  items: _daftarMataKuliah.map((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(
                        value,
                        style: TextStyle(fontSize: isMobile ? 14.0 : 16.0),
                      ),
                    );
                  }).toList(),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Pilih mata kuliah';
                    }
                    return null;
                  },
                  onChanged: (value) {
                    setState(() {
                      _mataKuliah = value!;
                    });
                  },
                  onSaved: (value) {
                    _mataKuliah = value!;
                  },
                ),
              ),

              SizedBox(height: isMobile ? 20.0 : 25.0),

              Container(
                padding: EdgeInsets.all(isMobile ? 10.0 : 12.0),
                decoration: BoxDecoration(
                  color: Colors.grey.shade100,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.grey.shade300),
                ),
                child: Row(
                  children: [
                    Icon(
                      Icons.assessment,
                      color: Colors.grey.shade700,
                      size: isMobile ? 18.0 : 24.0,
                    ),
                    SizedBox(width: isMobile ? 8.0 : 10.0),
                    Text(
                      'Input Nilai',
                      style: TextStyle(
                        fontSize: isMobile ? 14.0 : 16.0,
                        fontWeight: FontWeight.w600,
                        color: Colors.grey.shade800,
                      ),
                    ),
                  ],
                ),
              ),

              SizedBox(height: isMobile ? 16.0 : 20.0),

              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildLabelMobile('Nilai Tugas', isMobile),
                  Row(
                    children: [
                      Expanded(
                        child: Container(
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(10),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.grey.withOpacity(0.1),
                                blurRadius: 5,
                                offset: const Offset(0, 2),
                              ),
                            ],
                          ),
                          child: TextFormField(
                            decoration: InputDecoration(
                              hintText: '0 - 100',
                              prefixIcon: Icon(
                                Icons.assignment_turned_in,
                                color: Colors.grey.shade700,
                              ),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                                borderSide: BorderSide.none,
                              ),
                              filled: true,
                              fillColor: Colors.grey.shade50,
                              contentPadding: EdgeInsets.all(
                                isMobile ? 14.0 : 16.0,
                              ),
                            ),
                            keyboardType: TextInputType.number,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Harus diisi';
                              }
                              double? nilai = double.tryParse(value);
                              if (nilai == null || nilai < 0 || nilai > 100) {
                                return 'Nilai 0-100';
                              }
                              return null;
                            },
                            onSaved: (value) {
                              _nilaiTugas = double.parse(value!);
                            },
                            initialValue: _nilaiTugas > 0
                                ? _nilaiTugas.toString()
                                : null,
                          ),
                        ),
                      ),
                      SizedBox(width: 10),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 8,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.grey.shade800,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          '30%',
                          style: TextStyle(
                            fontSize: isMobile ? 12.0 : 14.0,
                            fontWeight: FontWeight.w600,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),

              SizedBox(height: isMobile ? 16.0 : 20.0),

              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildLabelMobile('Nilai UTS', isMobile),
                  Row(
                    children: [
                      Expanded(
                        child: Container(
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(10),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.grey.withOpacity(0.1),
                                blurRadius: 5,
                                offset: const Offset(0, 2),
                              ),
                            ],
                          ),
                          child: TextFormField(
                            decoration: InputDecoration(
                              hintText: '0 - 100',
                              prefixIcon: Icon(
                                Icons.quiz,
                                color: Colors.grey.shade700,
                              ),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                                borderSide: BorderSide.none,
                              ),
                              filled: true,
                              fillColor: Colors.grey.shade50,
                              contentPadding: EdgeInsets.all(
                                isMobile ? 14.0 : 16.0,
                              ),
                            ),
                            keyboardType: TextInputType.number,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Harus diisi';
                              }
                              double? nilai = double.tryParse(value);
                              if (nilai == null || nilai < 0 || nilai > 100) {
                                return 'Nilai 0-100';
                              }
                              return null;
                            },
                            onSaved: (value) {
                              _nilaiUts = double.parse(value!);
                            },
                            initialValue: _nilaiUts > 0
                                ? _nilaiUts.toString()
                                : null,
                          ),
                        ),
                      ),
                      SizedBox(width: 10),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 8,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.grey.shade800,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          '30%',
                          style: TextStyle(
                            fontSize: isMobile ? 12.0 : 14.0,
                            fontWeight: FontWeight.w600,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),

              SizedBox(height: isMobile ? 16.0 : 20.0),

              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildLabelMobile('Nilai UAS', isMobile),
                  Row(
                    children: [
                      Expanded(
                        child: Container(
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(10),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.grey.withOpacity(0.1),
                                blurRadius: 5,
                                offset: const Offset(0, 2),
                              ),
                            ],
                          ),
                          child: TextFormField(
                            decoration: InputDecoration(
                              hintText: '0 - 100',
                              prefixIcon: Icon(
                                Icons.book,
                                color: Colors.grey.shade700,
                              ),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                                borderSide: BorderSide.none,
                              ),
                              filled: true,
                              fillColor: Colors.grey.shade50,
                              contentPadding: EdgeInsets.all(
                                isMobile ? 14.0 : 16.0,
                              ),
                            ),
                            keyboardType: TextInputType.number,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Harus diisi';
                              }
                              double? nilai = double.tryParse(value);
                              if (nilai == null || nilai < 0 || nilai > 100) {
                                return 'Nilai 0-100';
                              }
                              return null;
                            },
                            onSaved: (value) {
                              _nilaiUas = double.parse(value!);
                            },
                            initialValue: _nilaiUas > 0
                                ? _nilaiUas.toString()
                                : null,
                          ),
                        ),
                      ),
                      SizedBox(width: 10),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 8,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.grey.shade800,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          '40%',
                          style: TextStyle(
                            fontSize: isMobile ? 12.0 : 14.0,
                            fontWeight: FontWeight.w600,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),

              SizedBox(height: isMobile ? 20.0 : 25.0),

              _buildLabelMobile('Komentar / Catatan', isMobile),
              Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.1),
                      blurRadius: 5,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: TextFormField(
                  decoration: InputDecoration(
                    hintText: 'Masukkan komentar atau catatan tambahan...',
                    prefixIcon: Icon(
                      Icons.comment,
                      color: Colors.grey.shade700,
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide.none,
                    ),
                    filled: true,
                    fillColor: Colors.grey.shade50,
                    contentPadding: EdgeInsets.all(isMobile ? 14.0 : 16.0),
                  ),
                  maxLines: isMobile ? 3 : 4,
                  onSaved: (value) {
                    _komentar = value ?? '';
                  },
                  initialValue: _komentar,
                ),
              ),

              SizedBox(height: isMobile ? 25.0 : 30.0),

              if (isMobile)
                // Layout vertikal untuk mobile
                Column(
                  children: [
                    if (_selectedIndex != null)
                      // BUTTON UPDATE (ORANGE) - MUNCUL SAAT EDIT MODE
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: _updateData,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.orange.shade600,
                            foregroundColor: Colors.white,
                            padding: EdgeInsets.all(isMobile ? 14.0 : 16.0),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.update, size: isMobile ? 18.0 : 24.0),
                              SizedBox(width: isMobile ? 8.0 : 10.0),
                              Text(
                                'UPDATE DATA',
                                style: TextStyle(
                                  fontSize: isMobile ? 14.0 : 16.0,
                                ),
                              ),
                            ],
                          ),
                        ),
                      )
                    else
                     
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: _tambahData,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.green.shade600,
                            foregroundColor: Colors.white,
                            padding: EdgeInsets.all(isMobile ? 14.0 : 16.0),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.add, size: isMobile ? 18.0 : 24.0),
                              SizedBox(width: isMobile ? 8.0 : 10.0),
                              Text(
                                'TAMBAH DATA',
                                style: TextStyle(
                                  fontSize: isMobile ? 14.0 : 16.0,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),

                    SizedBox(height: 12),

                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: _resetForm,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.grey.shade600,
                          foregroundColor: Colors.white,
                          padding: EdgeInsets.all(isMobile ? 14.0 : 16.0),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.refresh, size: isMobile ? 18.0 : 24.0),
                            SizedBox(width: isMobile ? 8.0 : 10.0),
                            Text(
                              'RESET FORM',
                              style: TextStyle(
                                fontSize: isMobile ? 14.0 : 16.0,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                )
              else
              
                Row(
                  children: [
                    if (_selectedIndex != null)
 
                      Expanded(
                        child: ElevatedButton(
                          onPressed: _updateData,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.orange.shade600,
                            foregroundColor: Colors.white,
                            padding: EdgeInsets.all(isMobile ? 14.0 : 16.0),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.update, size: isMobile ? 18.0 : 24.0),
                              SizedBox(width: isMobile ? 8.0 : 10.0),
                              Text(
                                'UPDATE DATA',
                                style: TextStyle(
                                  fontSize: isMobile ? 14.0 : 16.0,
                                ),
                              ),
                            ],
                          ),
                        ),
                      )
                    else

                      Expanded(
                        child: ElevatedButton(
                          onPressed: _tambahData,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.green.shade600,
                            foregroundColor: Colors.white,
                            padding: EdgeInsets.all(isMobile ? 14.0 : 16.0),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.add, size: isMobile ? 18.0 : 24.0),
                              SizedBox(width: isMobile ? 8.0 : 10.0),
                              Text(
                                'TAMBAH DATA',
                                style: TextStyle(
                                  fontSize: isMobile ? 14.0 : 16.0,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),

                    SizedBox(width: 15),

                    Expanded(
                      child: ElevatedButton(
                        onPressed: _resetForm,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.grey.shade600,
                          foregroundColor: Colors.white,
                          padding: EdgeInsets.all(isMobile ? 14.0 : 16.0),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.refresh, size: isMobile ? 18.0 : 24.0),
                            SizedBox(width: isMobile ? 8.0 : 10.0),
                            Text(
                              'RESET FORM',
                              style: TextStyle(
                                fontSize: isMobile ? 14.0 : 16.0,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),

              SizedBox(height: isMobile ? 25.0 : 30.0),

              if (_dataPenilaian.isNotEmpty)
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      padding: EdgeInsets.all(isMobile ? 10.0 : 12.0),
                      decoration: BoxDecoration(
                        color: Colors.grey.shade100,
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: Colors.grey.shade300),
                      ),
                      child: Row(
                        children: [
                          Icon(
                            Icons.list,
                            color: Colors.grey.shade700,
                            size: isMobile ? 18.0 : 24.0,
                          ),
                          SizedBox(width: isMobile ? 8.0 : 10.0),
                          Text(
                            'Data Penilaian (${_dataPenilaian.length})',
                            style: TextStyle(
                              fontSize: isMobile ? 14.0 : 16.0,
                              fontWeight: FontWeight.w600,
                              color: Colors.grey.shade800,
                            ),
                          ),
                          const Spacer(),
                          if (_dataPenilaian.isNotEmpty)
                            TextButton(
                              onPressed: () {
                                showDialog(
                                  context: context,
                                  builder: (context) => AlertDialog(
                                    title: Text(
                                      'Hapus Semua Data',
                                      style: TextStyle(
                                        fontSize: isMobile ? 16.0 : 18.0,
                                      ),
                                    ),
                                    content: Text(
                                      'Apakah Anda yakin ingin menghapus semua data?',
                                      style: TextStyle(
                                        fontSize: isMobile ? 14.0 : 16.0,
                                      ),
                                    ),
                                    actions: [
                                      TextButton(
                                        onPressed: () => Navigator.pop(context),
                                        child: Text(
                                          'Batal',
                                          style: TextStyle(
                                            fontSize: isMobile ? 14.0 : 16.0,
                                          ),
                                        ),
                                      ),
                                      TextButton(
                                        onPressed: () {
                                          setState(() {
                                            _dataPenilaian.clear();
                                            _resetForm();
                                          });
                                          Navigator.pop(context);
                                          _showSnackbar(
                                            'Semua data berhasil dihapus!',
                                          );
                                        },
                                        child: Text(
                                          'Hapus',
                                          style: TextStyle(
                                            fontSize: isMobile ? 14.0 : 16.0,
                                            color: Colors.red,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                );
                              },
                              child: Row(
                                children: [
                                  Icon(
                                    Icons.delete_sweep,
                                    size: isMobile ? 16.0 : 18.0,
                                  ),
                                  SizedBox(width: isMobile ? 4.0 : 5.0),
                                  Text(
                                    'Hapus',
                                    style: TextStyle(
                                      fontSize: isMobile ? 12.0 : 14.0,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                        ],
                      ),
                    ),

                    SizedBox(height: isMobile ? 12.0 : 15.0),

                    ListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: _dataPenilaian.length,
                      itemBuilder: (context, index) {
                        Map<String, dynamic> data = _dataPenilaian[index];
                        return Container(
                          margin: EdgeInsets.only(
                            bottom: isMobile ? 8.0 : 12.0,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(
                              isMobile ? 8.0 : 10.0,
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.grey.withOpacity(0.1),
                                blurRadius: 3,
                                offset: const Offset(0, 2),
                              ),
                            ],
                          ),
                          child: ListTile(
                            contentPadding: EdgeInsets.symmetric(
                              horizontal: isMobile ? 12.0 : 16.0,
                              vertical: isMobile ? 8.0 : 12.0,
                            ),
                            leading: CircleAvatar(
                              radius: isMobile ? 18.0 : 22.0,
                              backgroundColor: _getGradeColor(data['grade']),
                              child: Text(
                                data['grade'],
                                style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: isMobile ? 12.0 : 14.0,
                                ),
                              ),
                            ),
                            title: Text(
                              data['nama'],
                              style: TextStyle(
                                fontWeight: FontWeight.w600,
                                fontSize: isMobile ? 14.0 : 16.0,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                            subtitle: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  data['mataKuliah'],
                                  style: TextStyle(
                                    fontSize: isMobile ? 12.0 : 14.0,
                                  ),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                                SizedBox(height: isMobile ? 2.0 : 4.0),
                                Row(
                                  children: [
                                    Icon(
                                      Icons.score,
                                      size: isMobile ? 10.0 : 12.0,
                                      color: Colors.grey.shade600,
                                    ),
                                    SizedBox(width: isMobile ? 2.0 : 4.0),
                                    Text(
                                      'Nilai: ${data['nilaiAkhir'].toStringAsFixed(2)}',
                                      style: TextStyle(
                                        color: Colors.grey.shade700,
                                        fontSize: isMobile ? 10.0 : 12.0,
                                      ),
                                    ),
                                    SizedBox(width: isMobile ? 6.0 : 10.0),
                                    Icon(
                                      Icons.calendar_today,
                                      size: isMobile ? 10.0 : 12.0,
                                      color: Colors.grey.shade600,
                                    ),
                                    SizedBox(width: isMobile ? 2.0 : 4.0),
                                    Text(
                                      '${DateTime.parse(data['tanggal'].toString()).day}/${DateTime.parse(data['tanggal'].toString()).month}/${DateTime.parse(data['tanggal'].toString()).year}',
                                      style: TextStyle(
                                        color: Colors.grey.shade700,
                                        fontSize: isMobile ? 10.0 : 12.0,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                            onTap: () => _lihatDetail(index),
                            // FIXED: Trailing untuk mobile dan desktop
                            trailing: isMobile
                                ? PopupMenuButton<String>(
                                    icon: Icon(
                                      Icons.more_vert,
                                      color: Colors.grey.shade700,
                                      size: isMobile ? 20.0 : 24.0,
                                    ),
                                    onSelected: (value) {
                                      if (value == 'edit') {
                                        _editData(index);
                                      } else if (value == 'delete') {
                                        _hapusData(index);
                                      }
                                    },
                                    itemBuilder: (context) => [
                                      PopupMenuItem<String>(
                                        value: 'edit',
                                        child: Row(
                                          children: [
                                            Icon(
                                              Icons.edit,
                                              color: Colors.orange.shade600,
                                              size: 16,
                                            ),
                                            SizedBox(width: 8),
                                            Text(
                                              'Edit',
                                              style: TextStyle(fontSize: 12),
                                            ),
                                          ],
                                        ),
                                      ),
                                      PopupMenuItem<String>(
                                        value: 'delete',
                                        child: Row(
                                          children: [
                                            Icon(
                                              Icons.delete,
                                              color: Colors.red.shade600,
                                              size: 16,
                                            ),
                                            SizedBox(width: 8),
                                            Text(
                                              'Hapus',
                                              style: TextStyle(fontSize: 12),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  )
                                : Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      IconButton(
                                        icon: Icon(
                                          Icons.edit,
                                          color: Colors.orange.shade600,
                                          size: 18.0,
                                        ),
                                        onPressed: () => _editData(index),
                                        padding: EdgeInsets.zero,
                                        constraints: const BoxConstraints(),
                                        tooltip: 'Edit Data',
                                      ),
                                      SizedBox(width: 8),
                                      IconButton(
                                        icon: Icon(
                                          Icons.delete,
                                          color: Colors.red.shade600,
                                          size: 18.0,
                                        ),
                                        onPressed: () => _hapusData(index),
                                        padding: EdgeInsets.zero,
                                        constraints: const BoxConstraints(),
                                        tooltip: 'Hapus Data',
                                      ),
                                    ],
                                  ),
                          ),
                        );
                      },
                    ),

                    SizedBox(height: isMobile ? 16.0 : 20.0),

                    Container(
                      padding: EdgeInsets.all(isMobile ? 12.0 : 16.0),
                      decoration: BoxDecoration(
                        color: Colors.grey.shade50,
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(color: Colors.grey.shade300),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Statistik Data',
                            style: TextStyle(
                              fontSize: isMobile ? 13.0 : 14.0,
                              fontWeight: FontWeight.w600,
                              color: Colors.grey.shade800,
                            ),
                          ),
                          SizedBox(height: isMobile ? 8.0 : 10.0),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              _buildStatItemMobile(
                                'Total Data',
                                _dataPenilaian.length.toString(),
                                Icons.numbers,
                                isMobile,
                              ),
                              _buildStatItemMobile(
                                'Rata-rata',
                                (_dataPenilaian.fold(
                                          0.0,
                                          (sum, item) =>
                                              sum + item['nilaiAkhir'],
                                        ) /
                                        _dataPenilaian.length)
                                    .toStringAsFixed(2),
                                Icons.bar_chart,
                                isMobile,
                              ),
                              _buildStatItemMobile(
                                'Tertinggi',
                                _dataPenilaian
                                    .fold(
                                      0.0,
                                      (max, item) => item['nilaiAkhir'] > max
                                          ? item['nilaiAkhir']
                                          : max,
                                    )
                                    .toStringAsFixed(2),
                                Icons.trending_up,
                                isMobile,
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),

              SizedBox(height: isMobile ? 25.0 : 30.0),

              Container(
                padding: EdgeInsets.all(isMobile ? 12.0 : 15.0),
                decoration: BoxDecoration(
                  color: Colors.grey.shade100,
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: Colors.grey.shade300),
                ),
                child: Row(
                  children: [
                    Icon(
                      Icons.info,
                      color: Colors.grey.shade700,
                      size: isMobile ? 16.0 : 20.0,
                    ),
                    SizedBox(width: isMobile ? 8.0 : 10.0),
                    Expanded(
                      child: Text(
                        _selectedIndex != null
                            ? 'Anda sedang dalam mode edit. Update data atau batalkan edit.'
                            : 'Gunakan tombol "Tambah Data" untuk menyimpan data ke dalam daftar.',
                        style: TextStyle(
                          fontSize: isMobile ? 11.0 : 13.0,
                          color: Colors.grey.shade700,
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              SizedBox(height: isMobile ? 16.0 : 20.0),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildLabelMobile(String text, bool isMobile) {
    return Padding(
      padding: EdgeInsets.only(bottom: isMobile ? 6.0 : 8.0, left: 4.0),
      child: Text(
        text,
        style: TextStyle(
          fontSize: isMobile ? 13.0 : 14.0,
          fontWeight: FontWeight.w600,
          color: Colors.grey.shade700,
        ),
      ),
    );
  }

  Widget _buildStatItemMobile(
    String label,
    String value,
    IconData icon,
    bool isMobile,
  ) {
    return Column(
      children: [
        Container(
          padding: EdgeInsets.all(isMobile ? 6.0 : 8.0),
          decoration: BoxDecoration(
            color: Colors.white,
            shape: BoxShape.circle,
            border: Border.all(color: Colors.grey.shade300),
          ),
          child: Icon(
            icon,
            size: isMobile ? 14.0 : 16.0,
            color: Colors.grey.shade700,
          ),
        ),
        SizedBox(height: isMobile ? 3.0 : 5.0),
        Text(
          value,
          style: TextStyle(
            fontSize: isMobile ? 12.0 : 14.0,
            fontWeight: FontWeight.w700,
            color: Colors.grey.shade800,
          ),
        ),
        Text(
          label,
          style: TextStyle(
            fontSize: isMobile ? 9.0 : 10.0,
            color: Colors.grey.shade600,
          ),
        ),
      ],
    );
  }
}

class PenilaianPage extends StatelessWidget {
  final String nama;
  final String email;
  final String mataKuliah;
  final double nilaiTugas;
  final double nilaiUts;
  final double nilaiUas;
  final double nilaiAkhir;
  final String grade;
  final String komentar;

  const PenilaianPage({
    super.key,
    required this.nama,
    required this.email,
    required this.mataKuliah,
    required this.nilaiTugas,
    required this.nilaiUts,
    required this.nilaiUas,
    required this.nilaiAkhir,
    required this.grade,
    required this.komentar,
  });

  Color _getGradeColor(String grade) {
    switch (grade) {
      case 'A':
        return const Color(0xFF4CAF50);
      case 'B':
        return const Color(0xFF8BC34A);
      case 'C':
        return const Color(0xFFFFC107);
      case 'D':
        return const Color(0xFFFF9800);
      case 'E':
        return const Color(0xFFF44336);
      default:
        return Colors.grey;
    }
  }

  Widget _buildDetailSection(
    String title,
    IconData icon,
    List<Widget> children,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(icon, size: 18, color: Colors.grey.shade700),
            const SizedBox(width: 8),
            Text(
              title,
              style: TextStyle(
                fontWeight: FontWeight.w600,
                color: Colors.grey.shade800,
                fontSize: 15,
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: Colors.grey.shade50,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: Colors.grey.shade300),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: children,
          ),
        ),
      ],
    );
  }

  Widget _buildDetailRow(
    String label,
    String value, {
    bool isBold = false,
    Color? valueColor,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            flex: 2,
            child: Text(
              label,
              style: TextStyle(color: Colors.grey.shade600, fontSize: 14),
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            flex: 3,
            child: Text(
              value,
              style: TextStyle(
                fontSize: 14,
                fontWeight: isBold ? FontWeight.bold : FontWeight.normal,
                color: valueColor ?? Colors.grey.shade800,
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Detail Penilaian'),
        backgroundColor: Colors.grey.shade800,
        elevation: 4,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.grey.shade800,
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.3),
                    blurRadius: 8,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Row(
                children: [
                  CircleAvatar(
                    radius: 30,
                    backgroundColor: _getGradeColor(grade),
                    child: Text(
                      grade,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  const SizedBox(width: 15),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          nama,
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w600,
                            color: Colors.white,
                          ),
                        ),
                        const SizedBox(height: 5),
                        Text(
                          mataKuliah,
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.grey.shade300,
                          ),
                        ),
                        const SizedBox(height: 5),
                        Text(
                          'Nilai Akhir: ${nilaiAkhir.toStringAsFixed(2)}',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: _getGradeColor(grade),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 25),

            _buildDetailSection('Informasi Mahasiswa', Icons.person, [
              _buildDetailRow('Nama', nama),
              _buildDetailRow('Email', email),
            ]),

            const SizedBox(height: 20),

            _buildDetailSection('Mata Kuliah', Icons.menu_book, [
              _buildDetailRow('Mata Kuliah', mataKuliah),
            ]),

            const SizedBox(height: 20),

            _buildDetailSection('Detail Nilai', Icons.assessment, [
              Row(
                children: [
                  Expanded(
                    child: _buildDetailRow('Nilai Tugas', '$nilaiTugas'),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.grey.shade200,
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Text(
                      '30%',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: Colors.grey.shade800,
                      ),
                    ),
                  ),
                ],
              ),
              Row(
                children: [
                  Expanded(child: _buildDetailRow('Nilai UTS', '$nilaiUts')),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.grey.shade200,
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Text(
                      '30%',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: Colors.grey.shade800,
                      ),
                    ),
                  ),
                ],
              ),
              Row(
                children: [
                  Expanded(child: _buildDetailRow('Nilai UAS', '$nilaiUas')),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.grey.shade200,
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Text(
                      '40%',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: Colors.grey.shade800,
                      ),
                    ),
                  ),
                ],
              ),
              const Divider(height: 20),
              _buildDetailRow(
                'Nilai Akhir',
                nilaiAkhir.toStringAsFixed(2),
                isBold: true,
                valueColor: _getGradeColor(grade),
              ),
              _buildDetailRow(
                'Grade',
                grade,
                isBold: true,
                valueColor: _getGradeColor(grade),
              ),
            ]),

            const SizedBox(height: 20),

            if (komentar.isNotEmpty)
              _buildDetailSection('Komentar', Icons.comment, [
                Text(
                  komentar,
                  style: TextStyle(color: Colors.grey.shade700, fontSize: 14),
                ),
              ]),

            const SizedBox(height: 30),

            Center(
              child: ElevatedButton.icon(
                onPressed: () {
                  Navigator.pop(context);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.grey.shade800,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 30,
                    vertical: 12,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                icon: const Icon(Icons.arrow_back),
                label: const Text('KEMBALI'),
              ),
            ),

            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}
