import 'package:flutter/foundation.dart';
import 'package:hive/hive.dart';

part 'restor_model_g.dart';

@HiveType(typeId: 1)
class Restor extends HiveObject {
  @HiveField(1)
  final String type;

  @HiveField(2)
  final Uint8List thumbnailBytes;

  @HiveField(3)
  final Uint8List bytes;

  @HiveField(4)
  final DateTime dateTime;

  @HiveField(5)
  final String localPath;

  Restor( {
    required this.type,
    required this.bytes,
    required this.dateTime,
    required this.localPath,
    required this.thumbnailBytes,

  });
}