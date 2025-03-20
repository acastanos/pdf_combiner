import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:pdf_combiner/models/image_from_pdf_config.dart';
import 'package:pdf_combiner/pdf_combiner.dart';
import 'package:pdf_combiner/pdf_combiner_delegate.dart';

import 'test_file_helper.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  setUpAll(() async {
    await TestFileHelper.init();
  });

  group('createImageFromPDF Integration Tests', () {
    final pdfCombiner = PdfCombiner();
    testWidgets('Test creating images from PDF file', (tester) async {
      final helper = TestFileHelper(['assets/document_1.pdf']);
      final inputPaths = await helper.prepareInputFiles();
      final outputPath = await helper.getOutputFilePath();

      await pdfCombiner.createImageFromPDF(
        inputPath: inputPaths[0],
        outputDirPath: outputPath,
        delegate: PdfCombinerDelegate(onSuccess: (paths) {
          expect(paths, ['${TestFileHelper.basePath}/image_1.png']);
        }, onError: (error) {
          fail("Test failed due to error: ${error.toString()}");
        }),
      );
    }, timeout: Timeout.none);

    testWidgets('Test creating with non-existing file', (tester) async {
      final helper = TestFileHelper([]);
      final inputPaths = await helper.prepareInputFiles();
      inputPaths.add('${TestFileHelper.basePath}/assets/non_existing.pdf');
      final outputPath = await helper.getOutputFilePath("");

      await pdfCombiner.createImageFromPDF(
        inputPath: inputPaths[0],
        outputDirPath: outputPath,
        delegate: PdfCombinerDelegate(onSuccess: (paths) {
          fail("Test failed due to success: $paths");
        }, onError: (error) {
          expect(error.toString(),
              'Exception: File is not of PDF type or does not exist: ${inputPaths[0]}');
        }),
      );
    }, timeout: Timeout.none);

    testWidgets('Test creating with non-supported file', (tester) async {
      final helper = TestFileHelper(['assets/image_1.jpeg']);
      final inputPaths = await helper.prepareInputFiles();
      final outputPath = await helper.getOutputFilePath('merged_output.pdf');

      await pdfCombiner.createImageFromPDF(
        inputPath: inputPaths[0],
        outputDirPath: outputPath,
        delegate: PdfCombinerDelegate(onSuccess: (paths) {
          fail("Test failed due to success: $paths");
        }, onError: (error) {
          expect(error.toString(),
              "Exception: File is not of PDF type or does not exist: ${inputPaths[0]}");
        }),
      );
    }, timeout: Timeout.none);

    testWidgets('Test creating only one image from a PDF', (tester) async {
      final helper = TestFileHelper(['assets/document_1.pdf']);
      final inputPaths = await helper.prepareInputFiles();
      final outputPath = await helper.getOutputFilePath();

      await pdfCombiner.createImageFromPDF(
          inputPath: inputPaths[0],
          outputDirPath: outputPath,
          delegate: PdfCombinerDelegate(onSuccess: (paths) {
            expect(paths.length, 1);
            expect(paths, ['${TestFileHelper.basePath}/image_1.png']);
          }, onError: (error) {
            fail("Test failed due to error: ${error.toString()}");
          }));
    }, timeout: Timeout.none);

    testWidgets('Test creating four images from a PDF', (tester) async {
      final helper = TestFileHelper(['assets/document_3.pdf']);
      final inputPaths = await helper.prepareInputFiles();
      final outputPath = await helper.getOutputFilePath();

      await pdfCombiner.createImageFromPDF(
        inputPath: inputPaths[0],
        outputDirPath: outputPath,
        config: ImageFromPdfConfig(createOneImage: false),
        delegate: PdfCombinerDelegate(onSuccess: (paths) {
          expect(paths.length, 4);
        }, onError: (error) {
          fail("Test failed due to error: ${error.toString()}");
        }),
      );
    }, timeout: Timeout.none);
  });
}
