// GENERATED MANUALLY — run build_runner to regenerate if entity changes.

import 'package:hive/hive.dart';
import 'package:wallie_4k_wallpapers/domain/entities/wallpaper_entity.dart';

class WallpaperEntityAdapter extends TypeAdapter<WallpaperEntity> {
  @override
  final int typeId = 0;

  @override
  WallpaperEntity read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return WallpaperEntity(
      id: fields[0] as String,
      source: fields[1] as String,
      thumbnailUrl: fields[2] as String,
      fullUrl: fields[3] as String,
      title: fields[4] as String?,
      photographerName: fields[5] as String?,
      photographerUsername: fields[6] as String?,
      photographerProfileUrl: fields[7] as String?,
      width: fields[8] as int?,
      height: fields[9] as int?,
      dominantColorHex: fields[10] as String?,
      tags: (fields[11] as List?)?.cast<String>() ?? const [],
      views: fields[12] as int?,
      downloads: fields[13] as int?,
      createdAt: fields[14] as DateTime?,
      downloadLocationUrl: fields[15] as String?,
    );
  }

  @override
  void write(BinaryWriter writer, WallpaperEntity obj) {
    writer
      ..writeByte(16)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.source)
      ..writeByte(2)
      ..write(obj.thumbnailUrl)
      ..writeByte(3)
      ..write(obj.fullUrl)
      ..writeByte(4)
      ..write(obj.title)
      ..writeByte(5)
      ..write(obj.photographerName)
      ..writeByte(6)
      ..write(obj.photographerUsername)
      ..writeByte(7)
      ..write(obj.photographerProfileUrl)
      ..writeByte(8)
      ..write(obj.width)
      ..writeByte(9)
      ..write(obj.height)
      ..writeByte(10)
      ..write(obj.dominantColorHex)
      ..writeByte(11)
      ..write(obj.tags)
      ..writeByte(12)
      ..write(obj.views)
      ..writeByte(13)
      ..write(obj.downloads)
      ..writeByte(14)
      ..write(obj.createdAt)
      ..writeByte(15)
      ..write(obj.downloadLocationUrl);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is WallpaperEntityAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
