import 'package:flutter_test/flutter_test.dart';
import 'package:pdf_combiner/communication/pdf_combiner_platform_interface.dart';
import 'package:pdf_combiner/pdf_combiner.dart';
import 'package:pdf_combiner/pdf_combiner_delegate.dart';

import 'mocks/mock_pdf_combiner_platform.dart';
import 'mocks/mock_pdf_combiner_platform_with_error.dart';
import 'mocks/mock_pdf_combiner_platform_with_exception.dart';

void main() {
  final pdfCombiner = PdfCombiner();
  group('PdfCombiner  Create PDF From Multiple Images Unit Tests', () {
    PdfCombiner.isMock = true;
    // Test for error handling when file not exist in the createPDFFromMultipleImages method.
    test('createPDFFromMultipleImages - Error handling (empty inputPaths)',
        () async {
      MockPdfCombinerPlatform fakePlatform = MockPdfCombinerPlatform();

      // Replace the platform instance with the mock implementation.
      PdfCombinerPlatform.instance = fakePlatform;

      // Call the method and check the response.
      await pdfCombiner.createPDFFromMultipleImages(
        inputPaths: [],
        outputPath: 'output/path.pdf',
        delegate: PdfCombinerDelegate(onSuccess: (paths) {
          fail("Test failed due to success: $paths");
        }, onError: (error) {
          expect(error.toString(),
              'Exception: The parameter (inputPaths) cannot be empty');
        }),
      );
    });

    // Test for error handling when file not exist in the createPDFFromMultipleImages method.
    test('createPDFFromMultipleImages - Error handling (File does not exist)',
        () async {
      MockPdfCombinerPlatform fakePlatform = MockPdfCombinerPlatform();

      // Replace the platform instance with the mock implementation.
      PdfCombinerPlatform.instance = fakePlatform;

      // Call the method and check the response.
      await pdfCombiner.createPDFFromMultipleImages(
        inputPaths: ['path1.jpg', 'path2.jpg'],
        outputPath: 'output/path.pdf',
        delegate: PdfCombinerDelegate(onSuccess: (paths) {
          fail("Test failed due to success: $paths");
        }, onError: (error) {
          expect(error.toString(),
              'Exception: File is not an image or does not exist: path1.jpg');
        }),
      );
    });

    // Test for error handling when you try to send a file that its not an image in createPDFFromMultipleImages
    test('createPDFFromMultipleImages - Error handling (File is not an image)',
        () async {
      MockPdfCombinerPlatform fakePlatform = MockPdfCombinerPlatform();

      // Replace the platform instance with the mock implementation.
      PdfCombinerPlatform.instance = fakePlatform;

      // Call the method and check the response.
      await pdfCombiner.createPDFFromMultipleImages(
        inputPaths: ['assets/document_1.pdf', 'path2.jpg'],
        outputPath: 'output/path.pdf',
        delegate: PdfCombinerDelegate(onSuccess: (paths) {
          fail("Test failed due to success: $paths");
        }, onError: (error) {
          expect(error.toString(),
              'Exception: File is not an image or does not exist: assets/document_1.pdf');
        }),
      );
    });

    // Test for error handling when you try to send a file that its not an image in createPDFFromMultipleImages
    test('createPDFFromMultipleImages - Error handling (File is not an image)',
        () async {
      MockPdfCombinerPlatformWithError fakePlatform =
          MockPdfCombinerPlatformWithError();

      // Replace the platform instance with the mock implementation.
      PdfCombinerPlatform.instance = fakePlatform;

      // Call the method and check the response.
      await pdfCombiner.createPDFFromMultipleImages(
        inputPaths: [
          'example/assets/image_1.jpeg',
          'example/assets/image_2.png'
        ],
        outputPath: 'output/path.pdf',
        delegate: PdfCombinerDelegate(onSuccess: (paths) {
          fail("Test failed due to success: $paths");
        }, onError: (error) {
          expect(error.toString(), 'Exception: error');
        }),
      );
    });

    // Test for success process in createPDFFromMultipleImages
    test('createPDFFromMultipleImages - success generate PDF', () async {
      MockPdfCombinerPlatform fakePlatform = MockPdfCombinerPlatform();

      // Replace the platform instance with the mock implementation.
      PdfCombinerPlatform.instance = fakePlatform;

      final outputPath = 'output/path/pdf_output.pdf';

      // Call the method and check the response.
      await pdfCombiner.createPDFFromMultipleImages(
        inputPaths: [
          'example/assets/image_1.jpeg',
          'example/assets/image_2.png'
        ],
        outputPath: outputPath,
        delegate: PdfCombinerDelegate(onSuccess: (paths) {
          expect(paths, [outputPath]);
        }, onError: (error) {
          fail("Test failed due to error: ${error.toString()}");
        }),
      );
    });
  });

  // Test for error handling when you try to send a file that its not a pdf in createPDFFromMultipleImages
  test('createPDFFromMultipleImages wrong outputPath', () async {
    MockPdfCombinerPlatform fakePlatform = MockPdfCombinerPlatform();

    // Replace the platform instance with the mock implementation.
    PdfCombinerPlatform.instance = fakePlatform;

    final outputPath = 'output/path/pdf_output.jpeg';

    // Call the method and check the response.
    await pdfCombiner.createPDFFromMultipleImages(
      inputPaths: ['example/assets/image_1.jpeg', 'example/assets/image_2.png'],
      outputPath: outputPath,
      delegate: PdfCombinerDelegate(onSuccess: (paths) {
        fail("Test failed due to success: $paths");
      }, onError: (error) {
        expect(error.toString(),
            'Exception: The outputPath must have a .pdf format: output/path/pdf_output.jpeg');
      }),
    );
  });

  // Test for error processing when creating pdf from multiple images using PdfCombiner.
  test('createPDFFromMultipleImages - Mocked Exception', () async {
    MockPdfCombinerPlatformWithException fakePlatform =
        MockPdfCombinerPlatformWithException();

    // Replace the platform instance with the mock implementation.
    PdfCombinerPlatform.instance = fakePlatform;

    // Call the method and check the response.
    await pdfCombiner.createPDFFromMultipleImages(
      inputPaths: ['example/assets/image_1.jpeg', 'example/assets/image_2.png'],
      outputPath: 'output/path.pdf',
      delegate: PdfCombinerDelegate(onSuccess: (paths) {
        fail("Test failed due to success: $paths");
      }, onError: (error) {
        expect(error.toString(), 'Exception: Mocked Exception');
      }),
    );
  });

  // Test for error Mocked Exception when creating pdf from multiple images using PdfCombiner.
  test('createPDFFromMultipleImages - Mocked Exception', () async {
    MockPdfCombinerPlatformWithException fakePlatform =
        MockPdfCombinerPlatformWithException();

    // Replace the platform instance with the mock implementation.
    PdfCombinerPlatform.instance = fakePlatform;

    // Call the method and check the response.
    await pdfCombiner.createPDFFromMultipleImages(
      inputPaths: ['example/assets/image_1.jpeg', 'example/assets/image_2.png'],
      outputPath: 'output/path.pdf',
      delegate: PdfCombinerDelegate(onSuccess: (paths) {
        fail("Test failed due to success: $paths");
      }, onError: (error) {
        expect(error.toString(), 'Exception: Mocked Exception');
      }),
    );
  });

  // Test for error processing when creating pdf from multiple images using PdfCombiner.
  test('createPDFFromMultipleImages - Error in processing', () async {
    MockPdfCombinerPlatformWithError fakePlatform =
        MockPdfCombinerPlatformWithError();

    // Replace the platform instance with the mock implementation.
    PdfCombinerPlatform.instance = fakePlatform;

    // Call the method and check the response.
    await pdfCombiner.createPDFFromMultipleImages(
      inputPaths: ['example/assets/image_1.jpeg', 'example/assets/image_2.png'],
      outputPath: 'output/path.pdf',
      delegate: PdfCombinerDelegate(onSuccess: (paths) {
        fail("Test failed due to success: $paths");
      }, onError: (error) {
        expect(error.toString(), 'Exception: error');
      }),
    );
  });
}
