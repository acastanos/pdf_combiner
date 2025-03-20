import 'package:flutter_test/flutter_test.dart';
import 'package:pdf_combiner/communication/pdf_combiner_platform_interface.dart';
import 'package:pdf_combiner/models/image_from_pdf_config.dart';
import 'package:pdf_combiner/models/image_scale.dart';
import 'package:pdf_combiner/pdf_combiner.dart';
import 'package:pdf_combiner/pdf_combiner_delegate.dart';

import 'mocks/mock_pdf_combiner_platform.dart';
import 'mocks/mock_pdf_combiner_platform_with_error.dart';
import 'mocks/mock_pdf_combiner_platform_with_exception.dart';

void main() {
  final pdfCombiner = PdfCombiner();
  group('PdfCombiner Create Images From PDF Unit Tests', () {
    PdfCombiner.isMock = true;
    // Test for error handling when you try to send a file that its not a pdf in createImageFromPDF
    test('createImageFromPDF - Error handling (File is not a pdf)', () async {
      MockPdfCombinerPlatform fakePlatform = MockPdfCombinerPlatform();

      // Replace the platform instance with the mock implementation.
      PdfCombinerPlatform.instance = fakePlatform;

      // Call the method and check the response.
      await pdfCombiner.createImageFromPDF(
        inputPath: 'assets/test_image1.png',
        outputDirPath: 'output/path',
        delegate: PdfCombinerDelegate(onSuccess: (paths) {
          fail("Test failed due to success: $paths");
        }, onError: (error) {
          expect(error.toString(),
              'Exception: File is not of PDF type or does not exist: assets/test_image1.png');
        }),
      );
    });

    // Test for error handling when you try to send a file that file not exist in createImageFromPDF
    test('createImageFromPDF - Error handling (File not exist)', () async {
      MockPdfCombinerPlatform fakePlatform = MockPdfCombinerPlatform();

      // Replace the platform instance with the mock implementation.
      PdfCombinerPlatform.instance = fakePlatform;

      // Call the method and check the response.
      await pdfCombiner.createImageFromPDF(
        inputPath: 'assets/test_image_not_exist.pdf',
        outputDirPath: 'output/path',
        delegate: PdfCombinerDelegate(onSuccess: (paths) {
          fail("Test failed due to success: $paths");
        }, onError: (error) {
          expect(error.toString(),
              'Exception: File is not of PDF type or does not exist: assets/test_image_not_exist.pdf');
        }),
      );
    });

    // Test for error handling when you try to send a file that its not a pdf in createImageFromPDF
    test('createImageFromPDF - Error handling (empty inputPath)', () async {
      MockPdfCombinerPlatform fakePlatform = MockPdfCombinerPlatform();

      // Replace the platform instance with the mock implementation.
      PdfCombinerPlatform.instance = fakePlatform;

      // Call the method and check the response.
      await pdfCombiner.createImageFromPDF(
        inputPath: '',
        outputDirPath: 'output/path',
        delegate: PdfCombinerDelegate(onSuccess: (paths) {
          fail("Test failed due to success: $paths");
        }, onError: (error) {
          expect(error.toString(),
              'Exception: The parameter (inputPath) cannot be empty');
        }),
      );
    });

    // Test for error processing when combining multiple PDFs using PdfCombiner.
    test('createImageFromPDF - Error in processing', () async {
      MockPdfCombinerPlatformWithError fakePlatform =
          MockPdfCombinerPlatformWithError();

      // Replace the platform instance with the mock implementation.
      PdfCombinerPlatform.instance = fakePlatform;

      // Call the method and check the response.
      await pdfCombiner.createImageFromPDF(
        inputPath: 'example/assets/document_1.pdf',
        outputDirPath: 'output/path',
        delegate: PdfCombinerDelegate(onSuccess: (paths) {
          fail("Test failed due to success: $paths");
        }, onError: (error) {
          expect(error.toString(), 'Exception: error');
        }),
      );
    });

    // Test for error processing when combining multiple PDFs using PdfCombiner.
    test('createImageFromPDF - Error inside of array', () async {
      MockPdfCombinerPlatformWithError fakePlatform =
          MockPdfCombinerPlatformWithError();

      // Replace the platform instance with the mock implementation.
      PdfCombinerPlatform.instance = fakePlatform;

      // Call the method and check the response.
      await pdfCombiner.createImageFromPDF(
        inputPath: 'example/assets/document_1.pdf',
        outputDirPath: 'output/path',
        delegate: PdfCombinerDelegate(onSuccess: (paths) {
          fail("Test failed due to success: $paths");
        }, onError: (error) {
          expect(error.toString(), 'Exception: error');
        }),
      );
    });

    // Test for error processing when combining multiple PDFs using PdfCombiner.
    test('createImageFromPDF - Error with empty response', () async {
      MockPdfCombinerPlatformWithError fakePlatform =
          MockPdfCombinerPlatformWithError();

      // Replace the platform instance with the mock implementation.
      PdfCombinerPlatform.instance = fakePlatform;

      // Call the method and check the response.
      await pdfCombiner.createImageFromPDF(
        inputPath: 'example/assets/document_1.pdf',
        outputDirPath: 'output/path',
        config: ImageFromPdfConfig(
          rescale: ImageScale(width: 500, height: 200),
        ),
        delegate: PdfCombinerDelegate(onSuccess: (paths) {
          fail("Test failed due to success: $paths");
        }, onError: (error) {
          expect(error.toString(), 'Exception: Error in processing');
        }),
      );
    });

    // Test for Mocked Exception creating image form PDF using PdfCombiner.
    test('createImageFromPDF - Mocked Exception', () async {
      MockPdfCombinerPlatformWithException fakePlatform =
          MockPdfCombinerPlatformWithException();

      // Replace the platform instance with the mock implementation.
      PdfCombinerPlatform.instance = fakePlatform;

      // Call the method and check the response.
      await pdfCombiner.createImageFromPDF(
        inputPath: 'example/assets/document_1.pdf',
        outputDirPath: 'output/path',
        delegate: PdfCombinerDelegate(onSuccess: (paths) {
          fail("Test failed due to success: $paths");
        }, onError: (error) {
          expect(error.toString(), 'Exception: Mocked Exception');
        }),
      );
    });

    // Test successfully for createImageFromPDF
    test('createImageFromPDF - success generate a single image', () async {
      MockPdfCombinerPlatform fakePlatform = MockPdfCombinerPlatform();

      // Replace the platform instance with the mock implementation.
      PdfCombinerPlatform.instance = fakePlatform;

      final outputDirPath = 'output/path';

      // Call the method and check the response.
      await pdfCombiner.createImageFromPDF(
        inputPath: 'example/assets/document_1.pdf',
        outputDirPath: outputDirPath,
        config: ImageFromPdfConfig(createOneImage: true),
        delegate: PdfCombinerDelegate(onSuccess: (paths) {
          expect(paths, ['$outputDirPath/image1.png']);
        }, onError: (error) {
          fail("Test failed due to error: ${error.toString()}");
        }),
      );
    });

    // Test successfully for createImageFromPDF
    test('createImageFromPDF - success generate multiple images', () async {
      MockPdfCombinerPlatform fakePlatform = MockPdfCombinerPlatform();

      // Replace the platform instance with the mock implementation.
      PdfCombinerPlatform.instance = fakePlatform;

      final outputDirPath = 'output/path';

      // Call the method and check the response.
      await pdfCombiner.createImageFromPDF(
        inputPath: 'example/assets/document_1.pdf',
        outputDirPath: outputDirPath,
        delegate: PdfCombinerDelegate(onSuccess: (paths) {
          expect(paths,
              ['$outputDirPath/image1.png', '$outputDirPath/image2.png']);
        }, onError: (error) {
          fail("Test failed due to error: ${error.toString()}");
        }),
      );
    });
  });
}
