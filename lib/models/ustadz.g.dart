// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'ustadz.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class UstadzAdapter extends TypeAdapter<Ustadz> {
  @override
  final int typeId = 3;

  @override
  Ustadz read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Ustadz(
      id: fields[0] as String,
      fullName: fields[1] as String,
    );
  }

  @override
  void write(BinaryWriter writer, Ustadz obj) {
    writer
      ..writeByte(2)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.fullName);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is UstadzAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
