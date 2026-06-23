import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '../services/car_api_service.dart';
import '../theme/app_theme.dart';
import '../widgets/custom_nav_bar.dart';

class AddCarScreen extends StatefulWidget {
  const AddCarScreen({super.key});

  @override
  State<AddCarScreen> createState() => _AddCarScreenState();
}

class _AddCarScreenState extends State<AddCarScreen> {
  final _formKey = GlobalKey<FormState>();
  final _apiService = CarApiService();

  final _makeController = TextEditingController();
  final _seatsController = TextEditingController();
  final _descriptionController = TextEditingController();

  int _selectedYear = DateTime.now().year;
  String? _selectedModel;
  String? _selectedCategory; 
  File? _selectedImage;
  
  bool _isLoading = false;
  bool _isFetchingModels = false;
  List<String> _availableModels = [];

  final List<Map<String, String>> _categories = [
    {'id': '3', 'name': 'רכבי יוקרה'},
    {'id': '2', 'name': 'רכבי אספנות'},
    {'id': '1', 'name': 'רכבי אטרקציות'},
  ];

  @override
  void dispose() {
    _makeController.dispose();
    _seatsController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  Future<void> _fetchModelsFromApi() async {
    if (_makeController.text.trim().isEmpty) return;
    
    setState(() {
      _isFetchingModels = true;
      _selectedModel = null;
    });

    try {
      final models = await _apiService.getModelsForMakeAndYear(
        _makeController.text.trim(),
        _selectedYear,
      );

      setState(() {
        _availableModels = models;
      });
    } catch (e) {
      print("Error fetching models: $e");
    } finally {
      setState(() {
        _isFetchingModels = false;
      });
    }
  }

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery, imageQuality: 70);
    
    if (pickedFile != null) {
      setState(() {
        _selectedImage = File(pickedFile.path);
      });
    }
  }

  Future<void> _submitData() async {
    if (!_formKey.currentState!.validate()) return;
    if (_selectedImage == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("חובה להעלות תמונה של הרכב"), backgroundColor: Colors.red),
      );
      return;
    }
    if (_selectedModel == null || _selectedCategory == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("אנא מלא את כל השדות הנפתחים"), backgroundColor: Colors.red),
      );
      return;
    }

    setState(() => _isLoading = true);

    try {
      final fullCarName = "${_makeController.text.trim()} $_selectedModel";
      
      if (!await _selectedImage!.exists()) {
        throw Exception("קובץ התמונה המקומי לא נמצא, אנא בחר תמונה שנית.");
      }
      
      final imageUrl = await _apiService.uploadCarImage(_selectedImage!, fullCarName);

      await _apiService.saveCarToFirestore(
        name: fullCarName,
        year: _selectedYear,
        seats: int.tryParse(_seatsController.text) ?? 4,
        imageUrl: imageUrl,
        companyId: _makeController.text.trim().toUpperCase(),
        categoryId: _selectedCategory!,
        description: _descriptionController.text.trim(),
      );

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("הרכב היוקרתי נוסף בהצלחה למערכת!"), backgroundColor: Colors.green),
        );
        Navigator.pop(context);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("שגיאה בהעלאה: $e"), backgroundColor: Colors.red),
        );
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.bgDark,
      appBar: const CustomNavBar(),
      body: Directionality(
        textDirection: TextDirection.rtl,
        child: _isLoading 
          ? const Center(child: CircularProgressIndicator(color: AppTheme.goldPrimary))
          : SingleChildScrollView(
              padding: const EdgeInsets.all(24.0),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "הוספת רכב חדש לצי",
                      style: TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 5),
                    const Text(
                      "הזן פרטים, המערכת תשלים את הדגמים ישירות מה-API העולמי",
                      style: TextStyle(color: Colors.white54, fontSize: 13),
                    ),
                    const SizedBox(height: 25),

                    GestureDetector(
                      onTap: _pickImage,
                      child: Container(
                        height: 180,
                        width: double.infinity,
                        decoration: BoxDecoration(
                          color: const Color(0xFF1A1A1E),
                          borderRadius: BorderRadius.circular(15),
                          border: Border.all(color: AppTheme.goldPrimary.withOpacity(0.3), width: 1),
                        ),
                        child: _selectedImage != null
                            ? ClipRRect(
                                borderRadius: BorderRadius.circular(15),
                                child: Image.file(_selectedImage!, fit: BoxFit.cover),
                              )
                            : const Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(Icons.add_a_photo, color: AppTheme.goldPrimary, size: 40),
                                  SizedBox(height: 10),
                                  Text("לחץ להעלאת תמונת רכב", style: TextStyle(color: Colors.white70)),
                                ],
                              ),
                      ),
                    ),
                    const SizedBox(height: 25),

                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          flex: 2,
                          child: TextFormField(
                            controller: _makeController,
                            style: const TextStyle(color: Colors.white),
                            decoration: _inputDecoration('שם היצרן (למשל: BMW)'),
                            onFieldSubmitted: (_) => _fetchModelsFromApi(),
                            validator: (val) => val == null || val.isEmpty ? 'שדה חובה' : null,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          flex: 1,
                          child: DropdownButtonFormField<int>(
                            value: _selectedYear,
                            dropdownColor: const Color(0xFF1A1A1E),
                            isExpanded: true,
                            style: const TextStyle(color: Colors.white, fontSize: 13),
                            decoration: _inputDecoration('שנה'),
                            items: List.generate(30, (index) => DateTime.now().year - index)
                                .map((year) => DropdownMenuItem(
                                      value: year, 
                                      child: Text(year.toString(), style: const TextStyle(overflow: TextOverflow.ellipsis)),
                                    ))
                                .toList(),
                            onChanged: (year) {
                              if (year != null) {
                                _selectedYear = year;
                                _fetchModelsFromApi();
                              }
                            },
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),

                    _isFetchingModels
                        ? const Padding(
                            padding: EdgeInsets.symmetric(vertical: 10),
                            child: LinearProgressIndicator(color: AppTheme.goldPrimary),
                          )
                        : DropdownButtonFormField<String>(
                            value: _selectedModel,
                            disabledHint: const Text("הזן יצרן תחילה ולחץ אישור לקבלת דגמים", style: TextStyle(color: Colors.white30, fontSize: 13)),
                            dropdownColor: const Color(0xFF1A1A1E),
                            isExpanded: true,
                            style: const TextStyle(color: Colors.white),
                            decoration: _inputDecoration('בחירת דגם מה-API'),
                            items: _availableModels
                                .toSet()
                                .map((model) => DropdownMenuItem(
                                      value: model, 
                                      child: Text(model, style: const TextStyle(overflow: TextOverflow.ellipsis)),
                                    ))
                                .toList(),
                            onChanged: _availableModels.isEmpty ? null : (model) {
                              setState(() => _selectedModel = model);
                            },
                          ),
                    const SizedBox(height: 20),

                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: DropdownButtonFormField<String>(
                            value: _selectedCategory,
                            dropdownColor: const Color(0xFF1A1A1E),
                            isExpanded: true,
                            style: const TextStyle(color: Colors.white, fontSize: 13),
                            decoration: _inputDecoration('קטגוריה'),
                            items: _categories.map((cat) {
                              return DropdownMenuItem(
                                value: cat['id'], 
                                child: Text(cat['name']!, style: const TextStyle(overflow: TextOverflow.ellipsis)),
                              );
                            }).toList(),
                            onChanged: (cat) => setState(() => _selectedCategory = cat),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: TextFormField(
                            controller: _seatsController,
                            keyboardType: TextInputType.number,
                            style: const TextStyle(color: Colors.white),
                            decoration: _inputDecoration('מספר מושבים'),
                            validator: (val) => val == null || val.isEmpty ? 'שדה חובה' : null,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),

                    TextFormField(
                      controller: _descriptionController,
                      maxLines: 4,
                      style: const TextStyle(color: Colors.white),
                      decoration: _inputDecoration('תיאור הרכב, אבזור ומפרט מיוחד...'),
                      validator: (val) => val == null || val.isEmpty ? 'שדה חובה' : null,
                    ),
                    const SizedBox(height: 35),

                    SizedBox(
                      width: double.infinity,
                      height: 55,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppTheme.goldPrimary,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                        ),
                        onPressed: _submitData,
                        child: const Text(
                          "אישור והעלאת רכב למערכת",
                          style: TextStyle(color: Colors.black, fontSize: 16, fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
      ),
    );
  }

  InputDecoration _inputDecoration(String label) {
    return InputDecoration(
      labelText: label,
      labelStyle: const TextStyle(color: Colors.white60, fontSize: 13),
      filled: true,
      fillColor: const Color(0xFF1A1A1E),
      contentPadding: const EdgeInsets.symmetric(vertical: 16, horizontal: 12),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: BorderSide(color: Colors.white.withOpacity(0.05)),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: const BorderSide(color: AppTheme.goldPrimary),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: const BorderSide(color: Colors.redAccent),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: const BorderSide(color: Colors.red, width: 2),
      ),
    );
  }
}