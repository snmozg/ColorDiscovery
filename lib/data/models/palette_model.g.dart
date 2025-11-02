// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'palette_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class PaletteModelAdapter extends TypeAdapter<PaletteModel> {
  @override
  final int typeId = 0;

  @override
  PaletteModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return PaletteModel(
      name: fields[0] as String,
      colors: (fields[1] as List).cast<int>(),
    );
  }

  @override
  void write(BinaryWriter writer, PaletteModel obj) {
    writer
      ..writeByte(2)
      ..writeByte(0)
      ..write(obj.name)
      ..writeByte(1)
      ..write(obj.colors);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is PaletteModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
