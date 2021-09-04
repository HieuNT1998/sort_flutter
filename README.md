# sort_flutter

Day la Flutter plugin de theo vet doi tuong.
Plugin nay binding truc tiep thuat toan theo vet SORT tu c++ sang Dart de su dung tren Flutter.
A Flutter™ plug-in providing a binding to SORT.

## Usage

### Installation

In the `pubspec.yaml` of your flutter project, add the following dependency:

```yaml
dependencies:
  ...
  sort_flutter: 
    git: 
        url: "aaaaaaaaaaaaaaaaa"
```

In your library add the following import:

```dart
import 'package:sort_flutter/sort_flutter.dart';
```

### Init Sort 
Ban can phai khoi tao instance cua SortFlutter truoc khi theo vet doi tuong. 
Cac doi so can chuyen vao khi khoi tao Sort la:
    kMinHits, 
    kMaxAge, 
    kMaxCoastCycles, 
    kIoUThreshold, 
    kMinConfidence, 
    frame_index

```dart
    SortFlutter sortFlutter;
    sortFlutter = new SortFlutter(3, 1, 1, 0.3, 0.6, 1);
```
### Update Sort\
Doi voi moi frame, chung ta se theo vet tat cac cac doi tuong duoc phat hien. 
De theo vet ban se phai su dung ham update(). 
Cac doi so can truyen vao trong ham update():
newPos: Danh sach vi tri cac doi tuong.     
```dart
    List<List<Double>> newPos = [[x1,y1,x2,y2]];
```
newLandmarks: Landmarks neu doi tuong la khuon mat. Doi voi doi tuong khong phai khuon mat co the fake du lieu. 
```dart
    List<List<Double>> newLandmarks = [[landmark1x, landmark1y, landmark2x, landmark2y]];
```
newScores: Danh sach diem confidence cua cac doi tuong. 
```dart
    List<Double> newSocres = [score1, score2];
```
landmarkLen: So luong len mark cua moi doi tuong. 

Su dung ham update    
```dart
    sortFlutter.update(newPos, newLandmarks, newScores, landmarkLen);
```
dau ra cua ham update se theo format
```dart
    [[x1,y1,x2,y2,landmark1,...landmarkN,objectId],[],...]
```