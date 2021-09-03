import 'dart:ffi' as ffi;
import 'dart:core';

typedef get_sort = ffi.Pointer Function(
    ffi.Int32, ffi.Int32, ffi.Int32, ffi.Float, ffi.Float, ffi.Int32);
typedef GetSort = ffi.Pointer Function(int, int, int, double, double, int);

typedef update_sort = ffi.Pointer<ffi.Float> Function(
    ffi.Pointer,
    ffi.Pointer<ffi.Float>,
    ffi.Pointer<ffi.Float>,
    ffi.Pointer<ffi.Float>,
    ffi.Int32,
    ffi.Int32);

typedef UpdateSort = ffi.Pointer<ffi.Float> Function(
    ffi.Pointer,
    ffi.Pointer<ffi.Float>,
    ffi.Pointer<ffi.Float>,
    ffi.Pointer<ffi.Float>,
    int,
    int);

typedef init_float_pointer = ffi.Pointer<ffi.Float> Function(ffi.Int32);
typedef InitFloatPointer = ffi.Pointer<ffi.Float> Function(int);

typedef init_int_pointer = ffi.Pointer<ffi.Int32> Function(ffi.Int32);
typedef InitIntPointer = ffi.Pointer<ffi.Int32> Function(int);

class SortFlutter {
  late int kMinHits;
  late int kMaxAge = 1;
  late int kMaxCoastCycles = 1;
  late double kIoUThreshold = 0.3;
  late double kMinConfidence = 0.6;
  late int frame_index = 0;
  late ffi.Pointer nativeSort;
  late var cppPathFile;
  late GetSort getSort;
  late UpdateSort updateSort;
  late InitFloatPointer initFloatPointer;
  late InitIntPointer initIntPointer;

  SortFlutter(this.kMinHits, this.kMaxAge, this.kMaxCoastCycles,
      this.kIoUThreshold, this.kMinConfidence, this.frame_index) {
    cppPathFile = 'libnative_with_opencv.so';
    final dylib = ffi.DynamicLibrary.open(cppPathFile);
    this.getSort = dylib
        .lookup<ffi.NativeFunction<get_sort>>('Navtive_GetSort')
        .asFunction();
    this.updateSort = dylib
        .lookup<ffi.NativeFunction<update_sort>>('Navtive_Update')
        .asFunction();
    this.initFloatPointer = dylib
        .lookup<ffi.NativeFunction<init_float_pointer>>('Navtive_InitFloatList')
        .asFunction();
    this.initIntPointer = dylib
        .lookup<ffi.NativeFunction<init_int_pointer>>('Navtive_InitIntList')
        .asFunction();

    this.nativeSort = getSort(this.kMinHits, this.kMaxAge, this.kMaxCoastCycles,
        this.kIoUThreshold, this.kMinConfidence, this.frame_index);
  }

  List<List<double>> update(
      new_pos, new_landmarks, new_scores, int landmarkLen) {
    ffi.Pointer<ffi.Float> bboxList = floatListToArray(new_pos);
    ffi.Pointer<ffi.Float> landmarksList = floatListToArray(new_landmarks);

    int scoreLen = new_scores.length;
    final scoresList = initFloatPointer(scoreLen);
    for (var i = 0; i < new_scores.length; i++) {
      scoresList.elementAt(i).value = new_scores[i];
    }

    ffi.Pointer<ffi.Float> navtiveResult = updateSort(nativeSort, bboxList,
        landmarksList, scoresList, new_pos.length, landmarkLen);

    double resultLen = navtiveResult.elementAt(0).value;
    int resultItemLen = 5 + landmarkLen;
    List<double> reList =
        navtiveResult.asTypedList(resultLen.round() * resultItemLen + 1);
    List<List<double>> re = [];
    for (int i = 0; i < resultLen.round(); i++) {
      List<double> tmpRe = [];
      for (int j = 0; j < resultItemLen; j++) {
        tmpRe.add(reList[i * resultItemLen + j + 1]);
      }
      re.add(tmpRe);
    }
    return re;
  }

  ffi.Pointer<ffi.Float> floatListToArray(new_pos) {
    int bbox_len = new_pos.length;
    if (bbox_len == 0) return initFloatPointer(0);
    int per_box_len = new_pos[0].length;
    final ptr =  initFloatPointer(bbox_len * per_box_len);
    for (var i = 0; i < bbox_len; i++) {
      for (var j = 0; j < per_box_len; j++) {
        ptr.elementAt(i * per_box_len + j).value = new_pos[i][j];
      }
    }
    return ptr;
  }

  ffi.Pointer<ffi.Int32> intListToArray(new_pos) {
    int bbox_len = new_pos.length;
    if (bbox_len == 0)
      return initIntPointer(0);
    int per_box_len = new_pos[0].length;
    final ptr = initIntPointer(bbox_len * per_box_len);
    for (var i = 0; i < bbox_len; i++) {
      for (var j = 0; j < per_box_len; j++) {
        ptr.elementAt(i * per_box_len + j).value = new_pos[i][j];
      }
    }
    return ptr;
  }
}
