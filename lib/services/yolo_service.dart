import 'dart:math' as math;
import 'package:flutter/foundation.dart';
import 'package:image/image.dart' as img;
import 'package:tflite_flutter/tflite_flutter.dart';

class BuildInputResult {
  final dynamic inputBuffer; 
  final double scale;
  final double padX;
  final double padY;
  final int resizedW;
  final int resizedH;
  BuildInputResult(this.inputBuffer, this.scale, this.padX, this.padY, this.resizedW, this.resizedH);
}

class YoloService {

  YoloService._internal();
  static final YoloService _instance = YoloService._internal();
  factory YoloService() => _instance;

  Interpreter? _interpreter;
  bool _isRunning = false;
  // ignore: unused_field
  bool _interpreterAllocated = false;

  static const int inputSize = 640;

  // Configurable thresholds
  double confThreshold = 0.45;
  double nmsIouThreshold = 0.55;

  Future<void> loadModel() async {
    if (_interpreter != null) {
      debugPrint('✅ YOLO model already loaded');
      return;
    }

    try {
      const String modelAssetPath = 'assets/models/yolo.tflite';

      final options = InterpreterOptions()..threads = 4;
      try {
        options.addDelegate(XNNPackDelegate());
        debugPrint('🚀 Using XNNPack Delegate (optimized CPU inference)');
      } catch (e) {
        debugPrint('⚠️ XNNPack not supported, using CPU fallback: $e');
      }

      _interpreter = await Interpreter.fromAsset(modelAssetPath, options: options);
      _interpreterAllocated = true;

      final inputTensor = _interpreter!.getInputTensor(0);
      final outputTensor = _interpreter!.getOutputTensor(0);

      debugPrint('✅ YOLO model loaded successfully (singleton)');
      debugPrint('  Input: ${inputTensor.shape}, type: ${inputTensor.type}');
      debugPrint('  Output: ${outputTensor.shape}, type: ${outputTensor.type}');
    } catch (e) {
      debugPrint('❌ Failed to load YOLO model: $e');
    }
  }

  bool get isLoaded => _interpreter != null;
  bool get isRunning => _isRunning;

  /// Run inference on an image
  Future<List<Map<String, dynamic>>> runOnImage(img.Image image) async {
    if (_interpreter == null) throw Exception('Model not loaded');
    if (_isRunning) {
      debugPrint("⚠️ YOLO inference already running — skipping new request");
      return [];
    }

    _isRunning = true;
    try {
      final inputTensor = _interpreter!.getInputTensor(0);
      final TensorType inputType = inputTensor.type;
      final BuildInputResult buildRes = _buildInput(image, inputType, letterbox: true);

      final outputTensor = _interpreter!.getOutputTensor(0);
      final TensorType outputType = outputTensor.type;
      final outShape = outputTensor.shape; // e.g. [1, 25200, 17]
      final int numBoxes = outShape[1];
      final int numAttrs = outShape[2];

      dynamic outputWrapper;
      if (outputType == TensorType.uint8) {
        outputWrapper = [
          List.generate(numBoxes, (_) => List<int>.filled(numAttrs, 0))
        ];
      } else if (outputType == TensorType.float32) {
        outputWrapper = [
          List.generate(numBoxes, (_) => List<double>.filled(numAttrs, 0.0))
        ];
      } else {
        throw Exception('Unsupported output tensor type: $outputType');
      }

      debugPrint('🧠 --- MODEL INFO ---');
      debugPrint('input shape: ${inputTensor.shape}, type: ${inputTensor.type}');
      debugPrint('output shape: ${outputTensor.shape}, type: ${outputTensor.type}');
      debugPrint('numBoxes=$numBoxes, numAttrs=$numAttrs');
      debugPrint(
        'build input: scale=${buildRes.scale.toStringAsFixed(4)}, '
        'padX=${buildRes.padX}, padY=${buildRes.padY}, '
        'resizedW=${buildRes.resizedW}, resizedH=${buildRes.resizedH}, '
        'buffer length=${buildRes.inputBuffer.length}'
      );

      if (buildRes.inputBuffer.isNotEmpty) {
        final sampleVals = buildRes.inputBuffer.take(6).toList();
        debugPrint('first input vals: $sampleVals');
      }

      final inferStart = DateTime.now();
      _interpreter!.allocateTensors();
      _interpreter!.run(buildRes.inputBuffer, outputWrapper);

      // 🧩 Dequantize output if needed
      List<List<double>> preds;
      if (outputType == TensorType.uint8) {
        final params = outputTensor.params;
        final double scale = params.scale;
        final int zeroPoint = params.zeroPoint;
        final raw = outputWrapper[0] as List<List<int>>;

        preds = raw
            .map((row) =>
                row.map((v) => ((v - zeroPoint) * scale).clamp(-10.0, 10.0)).toList())
            .toList();

        debugPrint('🧮 Dequantized uint8 -> float using scale=$scale, zeroPoint=$zeroPoint');
      } else {
        preds = (outputWrapper[0] as List<List<double>>)
            .map((r) => r.toList())
            .toList();
        debugPrint('🧮 Float32 output, no dequantization needed');
      }

      if (preds.isEmpty) {
        debugPrint('⚠️ Empty predictions — check model output tensor shape.');
        return [];
      }

      debugPrint('🔍 Example pred[0]: ${preds.first.take(10).toList()}');
      debugPrint('🔬 mean(obj)=${preds.take(50).map((r)=>r[4]).reduce((a,b)=>a+b)/50}');

      final inferTime = DateTime.now().difference(inferStart);
      debugPrint('⏱ Inference time: ${inferTime.inMilliseconds} ms');

      final outTensors = _interpreter!.getOutputTensors();
      debugPrint('🧠 Output tensors count: ${outTensors.length}');
      for (var i = 0; i < outTensors.length; i++) {
        final t = outTensors[i];
        debugPrint('  Tensor $i shape: ${t.shape}, type: ${t.type}');
        if (t.type == TensorType.uint8) {
          final params = t.params;
          debugPrint('    quant params: scale=${params.scale}, zeroPoint=${params.zeroPoint}');
        }
      }

      debugPrint('🔍 Example pred[0]: ${preds.isNotEmpty ? preds[0].take(10).toList() : "empty"}');

      if (preds.isNotEmpty) {
        debugPrint('🔬 first pred row: ${preds[0].map((v) => v.toStringAsFixed(6)).toList()}');
        debugPrint('🔬 sample meanAt4=${preds.take(50).map((r) => r[4]).fold(0.0, (a,b)=>a+b)/50}');
        debugPrint('🔬 sample meanAtLast=${preds.take(50).map((r) => r.last).fold(0.0, (a,b)=>a+b)/50}');
      }

      // Debug: compute mean of each column
      if (preds.isNotEmpty) {
        final nCols = preds[0].length;
        final means = List.filled(nCols, 0.0);
        for (var row in preds.take(1000)) {
          for (int j = 0; j < nCols; j++) {
            means[j] += row[j];
          }
        }
        for (int j = 0; j < nCols; j++) {
          means[j] /= math.min(preds.length, 1000);
        }
        debugPrint('📊 Column means: $means');
      }

      // === ASSUME YOLOv5 layout ===
      // YOLOv5 TFLite export: [cx, cy, w, h, obj, cls0..clsN]
      int objIndex = 4;
      int classStart = 5;
      int numClasses = numAttrs - classStart;
      debugPrint('🔧 Assuming YOLOv5 layout: objIndex=$objIndex, classStart=$classStart, numClasses=$numClasses (numAttrs=$numAttrs)');

      if (numAttrs == 17) {
        objIndex = 4;
        classStart = 5;
        numClasses = 12;
      } else if (numAttrs > 5) {
        objIndex = 4;
        classStart = 5;
        numClasses = numAttrs - classStart;
      } else {
        objIndex = 4;
        classStart = 5;
        numClasses = math.max(0, numAttrs - classStart);
      }

      if (numClasses <= 0 || numClasses > 1000) {
        if (preds.isNotEmpty) {
          final sample = preds.take(math.min(500, preds.length)).toList();
          final cols = preds[0].length;
          final means = List<double>.filled(cols, 0.0);
          for (final row in sample) {
            for (int c = 0; c < cols; c++) means[c] += row[c];
          }
          for (int c = 0; c < cols; c++) means[c] /= sample.length;

          int found = -1;
          for (int c = objIndex + 1; c < cols; c++) {
            if (means[c] > 0.05) {
              found = c;
              break;
            }
          }
          if (found != -1) {
            classStart = found;
            numClasses = cols - classStart;
          } else {
            classStart = 5;
            numClasses = cols - classStart;
          }
        } else {
          classStart = 5;
          numClasses = numAttrs - classStart;
        }
      }

      if (numClasses < 1) numClasses = math.max(1, numAttrs - classStart);

      debugPrint('🔧 Using layout: objIndex=$objIndex, classStart=$classStart, numClasses=$numClasses (numAttrs=$numAttrs)');

      for (int i = 0; i < math.min(5, preds.length); i++) {
        debugPrint('RAW pred[$i]: ${preds[i].take(8).map((v) => v.toStringAsFixed(4)).toList()}');
      }

      final detections = _postprocess(
          preds,
          image.width.toDouble(),
          image.height.toDouble(),
          objIndex: objIndex,
          classStart: classStart,
          numClasses: numClasses,
          padX: buildRes.padX,
          padY: buildRes.padY,
          scale: buildRes.scale);

      debugPrint('✅ Detections after NMS: ${detections.length}');
      return detections;
    } catch (e, st) {
      debugPrint('❌ Inference error: $e');
      debugPrint(st.toString());
      rethrow;
    } finally {
      _isRunning = false;
    }
  }

  /// Build input buffer with letterboxing
  BuildInputResult _buildInput(img.Image image, TensorType inputType, {bool letterbox = true}) {
    final int origW = image.width;
    final int origH = image.height;

    if (!letterbox) {
      final img.Image resized = img.copyResize(image, width: inputSize, height: inputSize);
      final dynamic buf = _pixelsToBuffer(resized, inputType);
      return BuildInputResult(buf, inputSize / origW, 0.0, 0.0, inputSize, inputSize);
    }

    final double scale = math.min(inputSize / origW, inputSize / origH);
    final int resizedW = (origW * scale).round();
    final int resizedH = (origH * scale).round();
    final img.Image resized = img.copyResize(image, width: resizedW, height: resizedH);

    final int fullPx = inputSize * inputSize;
    final Uint8List rgb = Uint8List(fullPx * 3);

    const int padVal = 114;
    for (int i = 0; i < rgb.length; i++) {
      rgb[i] = padVal;
    }

    final int padX = ((inputSize - resizedW) / 2).round();
    final int padY = ((inputSize - resizedH) / 2).round();

    for (int y = 0; y < resizedH; y++) {
      for (int x = 0; x < resizedW; x++) {
        // ✅ FIX 2: image pkg v4+ returns Pixel (num r/g/b), not int.
        // Using _extractRgb() handles both old (int) and new (Pixel) APIs safely.
        final (int r, int g, int b) = _extractRgb(resized.getPixel(x, y));
        final int dstX = x + padX;
        final int dstY = y + padY;
        final int idx = (dstY * inputSize + dstX) * 3;
        rgb[idx]     = r;
        rgb[idx + 1] = g;
        rgb[idx + 2] = b;
      }
    }

    if (inputType == TensorType.uint8) {
      return BuildInputResult(rgb, scale, padX.toDouble(), padY.toDouble(), resizedW, resizedH);
    } else {
      final Float32List floats = Float32List(rgb.length);
      for (int i = 0; i < rgb.length; i++) {
        floats[i] = rgb[i] / 255.0;
      }
      return BuildInputResult(floats, scale, padX.toDouble(), padY.toDouble(), resizedW, resizedH);
    }
  }

  /// ✅ FIX 2 (helper): Safely extracts R,G,B from either an int pixel (image pkg v3)
  /// or a Pixel object (image pkg v4+).  The v4 Pixel exposes .r/.g/.b as num,
  /// so we call .toInt() rather than casting with 'as int'.
  (int, int, int) _extractRgb(dynamic px) {
    if (px is int) {
      // Legacy image pkg v3 packed-int format: ARGB
      return (
        (px >> 16) & 0xFF,
        (px >> 8)  & 0xFF,
        px         & 0xFF,
      );
    }
    // image pkg v4 Pixel object
    return (
      (px.r as num).toInt(),
      (px.g as num).toInt(),
      (px.b as num).toInt(),
    );
  }

  /// Convert image pixels to flat RGB buffer (no letterbox, resized image expected)
  dynamic _pixelsToBuffer(img.Image image, TensorType inputType) {
    final int w = image.width;
    final int h = image.height;
    final int pxCount = w * h;
    final Uint8List rgb = Uint8List(pxCount * 3);
    int k = 0;
    for (int y = 0; y < h; y++) {
      for (int x = 0; x < w; x++) {
        // ✅ FIX 2: same safe extraction
        final (int r, int g, int b) = _extractRgb(image.getPixel(x, y));
        rgb[k++] = r;
        rgb[k++] = g;
        rgb[k++] = b;
      }
    }

    if (inputType == TensorType.uint8) return rgb;
    final Float32List floats = Float32List(rgb.length);
    for (int i = 0; i < rgb.length; i++) floats[i] = rgb[i] / 255.0;
    return floats;
  }

  List<Map<String, dynamic>> _postprocess(
    List<List<double>> preds,
    double origW,
    double origH, {
    required int objIndex,
    required int classStart,
    required int numClasses,
    required double padX,
    required double padY,
    required double scale,
  }) {
    final List<Map<String, dynamic>> rawBoxes = [];
    if (preds.isEmpty) {
      debugPrint('🔍 No predictions to postprocess');
      return rawBoxes;
    }

    final allVals = preds.expand((r) => r).toList();
    final double minVal = allVals.reduce(math.min);
    final double maxVal = allVals.reduce(math.max);
    debugPrint('🧠 Postprocess value range: min=$minVal, max=$maxVal');

    for (final row in preds) {
      if (row.length < classStart + numClasses) continue;

      final double cxNorm = row[0];
      final double cyNorm = row[1];
      final double wNorm  = row[2];
      final double hNorm  = row[3];

      double obj = row[objIndex].clamp(0.0, 1.0);
      if (obj < 0.05) continue;

      final List<double> classScores =
          row.sublist(classStart, classStart + numClasses)
              .map((v) => v.clamp(0.0, 1.0))
              .toList();

      double bestClsScore = 0.0;
      int bestIdx = -1;
      for (int c = 0; c < classScores.length; c++) {
        if (classScores[c] > bestClsScore) {
          bestClsScore = classScores[c];
          bestIdx = c;
        }
      }
      if (bestIdx < 0) continue;

      final double conf = obj * bestClsScore;
      if (conf < confThreshold) continue;

      final double cxInput = cxNorm * inputSize;
      final double cyInput = cyNorm * inputSize;
      final double wInput  = wNorm  * inputSize;
      final double hInput  = hNorm  * inputSize;

      final double cx = (cxInput - padX) / scale;
      final double cy = (cyInput - padY) / scale;
      final double bw = wInput / scale;
      final double bh = hInput / scale;

      final double left   = (cx - bw / 2).clamp(0.0, origW);
      final double top    = (cy - bh / 2).clamp(0.0, origH);
      final double right  = (cx + bw / 2).clamp(0.0, origW);
      final double bottom = (cy + bh / 2).clamp(0.0, origH);
      final double width  = right - left;
      final double height = bottom - top;
      if (width < 2.0 || height < 2.0) continue;

      rawBoxes.add({
        'x':          left,
        'y':          top,
        'w':          width,
        'h':          height,
        'confidence': conf,
        // ✅ FIX 3: always emit classIndex so callers can resolve labels from labels.txt.
        // 'label' is kept as a human-readable fallback but callers should prefer classIndex.
        'classIndex': bestIdx,
        'label':      'class_$bestIdx',
      });
    }

    // NMS per class
    final Map<String, List<Map<String, dynamic>>> grouped = {};
    for (final b in rawBoxes) {
      grouped.putIfAbsent(b['label'] as String, () => []).add(b);
    }

    final List<Map<String, dynamic>> finalBoxes = [];
    for (final entry in grouped.entries) {
      finalBoxes.addAll(_nmsList(entry.value, nmsIouThreshold));
    }

    debugPrint('🔎 rawBoxes=${rawBoxes.length}, finalBoxes(after NMS)=${finalBoxes.length}');
    return finalBoxes;
  }

  List<Map<String, dynamic>> _nmsList(List<Map<String, dynamic>> boxes, double iouThresh) {
    if (boxes.isEmpty) return [];

    boxes.sort((a, b) => (b['confidence'] as double).compareTo(a['confidence'] as double));
    final List<Map<String, dynamic>> keep = [];
    final List<bool> removed = List.filled(boxes.length, false);

    for (int i = 0; i < boxes.length; i++) {
      if (removed[i]) continue;
      final a = boxes[i];
      keep.add(a);
      for (int j = i + 1; j < boxes.length; j++) {
        if (removed[j]) continue;
        final b = boxes[j];
        final double iou = _iouRect(a, b);
        if (iou > iouThresh) {
          removed[j] = true;
          debugPrint('🧮 NMS suppressed (iou=${iou.toStringAsFixed(3)})');
        }
      }
    }
    return keep;
  }

  double _iouRect(Map<String, dynamic> A, Map<String, dynamic> B) {
    final double x1 = math.max(A['x'] as double, B['x'] as double);
    final double y1 = math.max(A['y'] as double, B['y'] as double);
    final double x2 = math.min((A['x'] as double) + (A['w'] as double), (B['x'] as double) + (B['w'] as double));
    final double y2 = math.min((A['y'] as double) + (A['h'] as double), (B['y'] as double) + (B['h'] as double));

    final double iw = math.max(0.0, x2 - x1);
    final double ih = math.max(0.0, y2 - y1);
    final double inter = iw * ih;
    final double union = (A['w'] as double) * (A['h'] as double) + (B['w'] as double) * (B['h'] as double) - inter;
    if (union <= 0) return 0.0;
    return inter / union;
  }

  void dispose() {
    _interpreter?.close();
    _interpreter = null;
    debugPrint("🧹 YOLO disposed");
  }
}
