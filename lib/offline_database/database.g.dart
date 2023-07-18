// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'database.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class TaskAdapter extends TypeAdapter<Task> {
  @override
  final int typeId = 0;

  @override
  Task read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Task(
      todos: fields[0] as String,
      isDone: fields[1] as bool,
      hour: fields[2] as String,
      minute: fields[4] as String,
      isAM: fields[3] as bool,
      day: fields[5] as String,
      month: fields[6] as String,
      year: fields[7] as String,
      todoID: fields[8] as int,
    );
  }

  @override
  void write(BinaryWriter writer, Task obj) {
    writer
      ..writeByte(9)
      ..writeByte(0)
      ..write(obj.todos)
      ..writeByte(1)
      ..write(obj.isDone)
      ..writeByte(2)
      ..write(obj.hour)
      ..writeByte(3)
      ..write(obj.isAM)
      ..writeByte(4)
      ..write(obj.minute)
      ..writeByte(5)
      ..write(obj.day)
      ..writeByte(6)
      ..write(obj.month)
      ..writeByte(7)
      ..write(obj.year)
      ..writeByte(8)
      ..write(obj.todoID);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is TaskAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class TodoCategoryAdapter extends TypeAdapter<TodoCategory> {
  @override
  final int typeId = 1;

  @override
  TodoCategory read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return TodoCategory(
      name: fields[0] as String,
      tasks: (fields[1] as List).cast<Task>(),
    );
  }

  @override
  void write(BinaryWriter writer, TodoCategory obj) {
    writer
      ..writeByte(2)
      ..writeByte(0)
      ..write(obj.name)
      ..writeByte(1)
      ..write(obj.tasks);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is TodoCategoryAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class TodoGoAdapter extends TypeAdapter<TodoGo> {
  @override
  final int typeId = 2;

  @override
  TodoGo read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return TodoGo(
      username: fields[0] as String,
      categories: (fields[1] as List).cast<TodoCategory>(),
    );
  }

  @override
  void write(BinaryWriter writer, TodoGo obj) {
    writer
      ..writeByte(2)
      ..writeByte(0)
      ..write(obj.username)
      ..writeByte(1)
      ..write(obj.categories);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is TodoGoAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
