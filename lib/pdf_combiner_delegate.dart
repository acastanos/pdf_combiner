class PdfCombinerDelegate {
  Function(double)? onProgress;
  Function(String)? onSuccess;
  Function(Error)? onError;

  PdfCombinerDelegate({this.onProgress, this.onSuccess, this.onError});
}
