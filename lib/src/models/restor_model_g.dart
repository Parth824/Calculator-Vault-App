// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'restor_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************


class RestorAdapter extends TypeAdapter<Restor> {
  @override
  final int typeId = 0;

  @override
  Restor read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Restor(
      type: fields[1] as String,
      bytes: fields[3] as Uint8List,
      dateTime: fields[4] as DateTime,
      localPath: fields[5] as String,
      thumbnailBytes: fields[2] as Uint8List,
    );
  }

  @override
  void write(BinaryWriter writer, Restor obj) {
    writer
      ..writeByte(5)
      ..writeByte(1)
      ..write(obj.type)
      ..writeByte(2)
      ..write(obj.thumbnailBytes)
      ..writeByte(3)
      ..write(obj.bytes)
      ..writeByte(4)
      ..write(obj.dateTime)
      ..writeByte(5)
      ..write(obj.localPath);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
          other is RestorAdapter &&
              runtimeType == other.runtimeType &&
              typeId == other.typeId;
}