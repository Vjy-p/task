// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'order_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class OrderModelAdapter extends TypeAdapter<OrderModel> {
  @override
  final int typeId = 1;

  @override
  OrderModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return OrderModel(
      id: fields[0] as String,
      products: (fields[1] as List).cast<ProductModel>(),
      status: fields[2] as OrderStatus,
      createdAt: fields[3] as DateTime,
      total: fields[8] as double,
      confirmedAt: fields[4] as DateTime?,
      dispatchedAt: fields[5] as DateTime?,
      outForDeliveredAt: fields[6] as DateTime?,
      deliveredAt: fields[7] as DateTime?,
    );
  }

  @override
  void write(BinaryWriter writer, OrderModel obj) {
    writer
      ..writeByte(9)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.products)
      ..writeByte(2)
      ..write(obj.status)
      ..writeByte(3)
      ..write(obj.createdAt)
      ..writeByte(4)
      ..write(obj.confirmedAt)
      ..writeByte(5)
      ..write(obj.dispatchedAt)
      ..writeByte(6)
      ..write(obj.outForDeliveredAt)
      ..writeByte(7)
      ..write(obj.deliveredAt)
      ..writeByte(8)
      ..write(obj.total);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is OrderModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
