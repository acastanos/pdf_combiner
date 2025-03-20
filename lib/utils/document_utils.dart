import 'package:file_magic_number/file_magic_number.dart';
import 'package:file_magic_number/file_magic_number_type.dart';
import 'package:path/path.dart' as p;

/// Utility class for handling document-related checks in a file system environment.
///
/// This implementation is designed for platforms with direct file system access,
/// such as Windows, macOS, and Linux. The `filePath` parameter should be a valid
/// local file path.
class DocumentUtils {
  /// Determines whether the given file path corresponds to a PDF file.
  ///
  /// This method checks if the file path ends with the `.pdf` extension
  /// (case insensitive).
  static Future<bool> isPDF(String filePath) async {
    try {
      return await FileMagicNumber.detectFileTypeFromPathOrBlob(filePath) ==
          FileMagicNumberType.pdf;
    } catch (e) {
      return false;
    }
  }

  /// Checks if all provided file paths correspond to PDF files.
  ///
  /// Iterates through the list of file paths and verifies whether each file
  /// is a PDF using the [isPDF] function. If any file is not a PDF,
  /// the function returns `false`. If an error occurs, it also returns `false`.
  ///
  /// - [filePaths]: A list of file paths to check.
  /// - Returns: `true` if all files are PDFs, otherwise `false`.
  static Future<bool> areAllPdfs(List<String> filePaths) async {
    try {
      bool areImages = true;
      int index = 0;
      while (index < filePaths.length && areImages) {
        final filePath = filePaths[index];
        areImages = await isPDF(filePath);
        index ++;
      }
      return areImages;
    } catch (e) {
      return false;
    }
  }

  /// Checks if the given file path has a PDF extension.
  /// Returns `true` if the file has a `.pdf` extension, otherwise `false`.
  static bool hasPDFExtension(String filePath) =>
      p.extension(filePath) == ".pdf";

  /// Determines whether the given file path corresponds to an image file.
  ///
  /// The method checks for common image file extensions (`.jpg`, `.jpeg`, `.png`,
  /// `.gif`, `.bmp`). If the file has no extension, it is assumed to be an image.
  static Future<bool> isImage(String filePath) async {
    try {
      final fileType =
          await FileMagicNumber.detectFileTypeFromPathOrBlob(filePath);
      return fileType == FileMagicNumberType.png ||
          fileType == FileMagicNumberType.jpg;
    } catch (e) {
      return false;
    }
  }
}
