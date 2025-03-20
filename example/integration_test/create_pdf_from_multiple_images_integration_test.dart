import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:pdf_combiner/pdf_combiner.dart';
import 'package:pdf_combiner/pdf_combiner_delegate.dart';

import 'test_file_helper.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  setUpAll(() async {
    await TestFileHelper.init();
  });

  group('createPDFFromMultipleImages Integration Tests', () {
    final pdfCombiner = PdfCombiner();
    testWidgets('Test creating pdf from two images', (tester) async {
      final helper =
          TestFileHelper(['assets/image_1.jpeg', 'assets/image_2.png']);
      final inputPaths = await helper.prepareInputFiles();
      final outputPath = await helper.getOutputFilePath('merged_output.pdf');

      await pdfCombiner.createPDFFromMultipleImages(
        inputPaths: inputPaths,
        outputPath: outputPath,
        delegate: PdfCombinerDelegate(onSuccess: (paths) {
          expect(paths, ['${TestFileHelper.basePath}/merged_output.pdf']);
        }, onError: (error) {
          fail("Test failed due to error: ${error.toString()}");
        }),
      );
    }, timeout: Timeout.none);

    testWidgets('Test creating pdf with empty list', (tester) async {
      await pdfCombiner.createPDFFromMultipleImages(
        inputPaths: [],
        outputPath: '${TestFileHelper.basePath}/assets/merged_output.pdf',
        delegate: PdfCombinerDelegate(onSuccess: (paths) {
          fail("Test failed due to success: $paths");
        }, onError: (error) {
          expect(error.toString(),
              'Exception: The parameter (inputPaths) cannot be empty');
        }),
      );
    }, timeout: Timeout.none);

    testWidgets('Test creating pdf with non-existing file', (tester) async {
      final helper = TestFileHelper([]);
      final inputPaths = await helper.prepareInputFiles();

      // Add a non-existing file path manually
      inputPaths.add('${TestFileHelper.basePath}/assets/non_existing.jpg');
      final outputPath = await helper.getOutputFilePath('merged_output.pdf');

      await pdfCombiner.createPDFFromMultipleImages(
        inputPaths: inputPaths,
        outputPath: outputPath,
        delegate: PdfCombinerDelegate(onSuccess: (paths) {
          fail("Test failed due to success: $paths");
        }, onError: (error) {
          expect(error.toString(),
              startsWith('Exception: File is not an image or does not exist:'));
        }),
      );
    }, timeout: Timeout.none);

    testWidgets('Test creating pdf with non-supported file', (tester) async {
      final helper =
          TestFileHelper(['assets/document_1.pdf', 'assets/image_1.jpeg']);
      final inputPaths = await helper.prepareInputFiles();
      final outputPath = await helper.getOutputFilePath('merged_output.pdf');

      await pdfCombiner.createPDFFromMultipleImages(
        inputPaths: inputPaths,
        outputPath: outputPath,
        delegate: PdfCombinerDelegate(onSuccess: (paths) {
          fail("Test failed due to success: $paths");
        }, onError: (error) {
          expect(error.toString(),
              'Exception: File is not an image or does not exist: ${TestFileHelper.basePath}/document_1.pdf');
        }),
      );
    }, timeout: Timeout.none);
  });
}
