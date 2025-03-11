import 'package:flutter/material.dart';
import 'package:pdf_combiner/models/image_compression.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PdfConfigScreen extends StatefulWidget {
  const PdfConfigScreen({super.key});

  @override
  State<PdfConfigScreen> createState() => _PdfConfigScreenState();
}

class _PdfConfigScreenState extends State<PdfConfigScreen> {
  bool imageFromPdfConfigUseOriginalScale = true;
  int imageFromPdfConfigWidth = 0;
  int imageFromPdfConfigHeight = 0;
  ImageCompression imageFromPdfConfigCompression = ImageCompression.none;
  bool imageFromPdfConfigCreateOneImage = false;
  bool pdfFromMultipleImageKeepAspectRatio = true;
  bool pdfFromMultipleImageUseOriginalScale = true;
  int pdfFromMultipleImageWidth = 0;
  int pdfFromMultipleImageHeight = 0;

  @override
  void initState() {
    super.initState();
    _loadPreferences();
  }

  Future<void> _loadPreferences() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      imageFromPdfConfigCreateOneImage =
          prefs.getBool('imageFromPdfConfigCreateOneImage') ?? false;
      int compressionValue = prefs.getInt('compression') ?? 0;
      imageFromPdfConfigCompression = ImageCompression.custom(compressionValue);
      imageFromPdfConfigUseOriginalScale =
          prefs.getBool('imageFromPdfConfigUseOriginalScale') ?? true;
      imageFromPdfConfigWidth = prefs.getInt('imageFromPdfConfigWidth') ?? 0;
      imageFromPdfConfigHeight = prefs.getInt('imageFromPdfConfigHeight') ?? 0;
      pdfFromMultipleImageKeepAspectRatio =
          prefs.getBool('pdfFromMultipleImageKeepAspectRatio') ?? true;
      pdfFromMultipleImageUseOriginalScale =
          prefs.getBool('pdfFromMultipleImageUseOriginalScale') ?? true;
      pdfFromMultipleImageWidth =
          prefs.getInt('pdfFromMultipleImageWidth') ?? 0;
      pdfFromMultipleImageHeight =
          prefs.getInt('pdfFromMultipleImageHeight') ?? 0;
    });
  }

  Future<void> _savePreferences() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(
        'imageFromPdfConfigCreateOneImage', imageFromPdfConfigCreateOneImage);
    await prefs.setInt(
        'imageFromPdfConfigCompression', imageFromPdfConfigCompression.value);
    await prefs.setBool('imageFromPdfConfigUseOriginalScale',
        imageFromPdfConfigUseOriginalScale);
    await prefs.setInt('imageFromPdfConfigWidth', imageFromPdfConfigWidth);
    await prefs.setInt('imageFromPdfConfigHeight', imageFromPdfConfigHeight);
    await prefs.setBool('pdfFromMultipleImageKeepAspectRatio',
        pdfFromMultipleImageKeepAspectRatio);
    await prefs.setBool('pdfFromMultipleImageUseOriginalScale',
        pdfFromMultipleImageUseOriginalScale);
    await prefs.setInt('pdfFromMultipleImageWidth', pdfFromMultipleImageWidth);
    await prefs.setInt(
        'pdfFromMultipleImageHeight', pdfFromMultipleImageHeight);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('PDF Configuration')),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            spacing: 20,
            children: [
              Text('Image From PDF Config',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              SwitchListTile(
                title: Text('Use Original Scale'),
                value: imageFromPdfConfigUseOriginalScale,
                onChanged: (value) =>
                    setState(() => imageFromPdfConfigUseOriginalScale = value),
              ),
              if (!imageFromPdfConfigUseOriginalScale)
                Column(
                  children: [
                    TextField(
                      decoration: InputDecoration(labelText: 'Width'),
                      keyboardType: TextInputType.number,
                      onChanged: (value) => setState(() =>
                          imageFromPdfConfigWidth = int.tryParse(value) ?? 0),
                    ),
                    TextField(
                      decoration: InputDecoration(labelText: 'Height'),
                      keyboardType: TextInputType.number,
                      onChanged: (value) => setState(() =>
                          imageFromPdfConfigHeight = int.tryParse(value) ?? 0),
                    ),
                  ],
                ),
              TextField(
                decoration: InputDecoration(labelText: 'Image Compression'),
                keyboardType: TextInputType.number,
                onChanged: (value) => setState(() =>
                    imageFromPdfConfigCompression =
                        ImageCompression.custom(int.tryParse(value) ?? 0)),
              ),
              SwitchListTile(
                title: Text('Create One Image'),
                value: imageFromPdfConfigCreateOneImage,
                onChanged: (value) =>
                    setState(() => imageFromPdfConfigCreateOneImage = value),
              ),
              Text('PDF From Multiple Images Config',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              SwitchListTile(
                title: Text('Use Original Scale'),
                value: pdfFromMultipleImageUseOriginalScale,
                onChanged: (value) => setState(
                    () => pdfFromMultipleImageUseOriginalScale = value),
              ),
              if (!pdfFromMultipleImageUseOriginalScale)
                Column(
                  children: [
                    TextField(
                      decoration: InputDecoration(labelText: 'Width'),
                      keyboardType: TextInputType.number,
                      onChanged: (value) => setState(() =>
                          pdfFromMultipleImageWidth = int.tryParse(value) ?? 0),
                    ),
                    TextField(
                      decoration: InputDecoration(labelText: 'Height'),
                      keyboardType: TextInputType.number,
                      onChanged: (value) => setState(() =>
                          pdfFromMultipleImageHeight =
                              int.tryParse(value) ?? 0),
                    ),
                  ],
                ),
              SwitchListTile(
                title: Text('Keep Aspect Ratio'),
                value: pdfFromMultipleImageKeepAspectRatio,
                onChanged: (value) =>
                    setState(() => pdfFromMultipleImageKeepAspectRatio = value),
              ),
              Align(
                alignment: Alignment.center,
                child: ElevatedButton(
                  onPressed: () async {
                    await _savePreferences();
                    if (!context.mounted) return;
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Configurations saved!')),
                    );
                  },
                  child: Text('Save Configurations'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
