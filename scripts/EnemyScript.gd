extends Node2D

class_name EnemyBase

@export var move_duration := 1.5
@export var offset := Vector2.ZERO
@export var movement_time_step := 0.1

var current_index := 0
var is_moving := false

var grass_nodes: Array[Node2D] = []

func set_grass(nodes: Array[Node2D]) -> void:
	grass_nodes = nodes.duplicate()
	
func snap_to_current() -> void:
	if grass_nodes.is_empty():
		return
	
	global_position = grass_nodes[current_index].global_position + offset

func move_next() -> void:
	if current_index + 1 >= grass_nodes.size():
		return
	
	if is_moving:
		return
		
	current_index += 1
	_start_move_with_delay()
	
func _start_move_with_delay() -> void:
	is_moving = true
	
	await get_tree().create_timer(movement_time_step).timeout
	
	_move_to_current()

func _move_to_current() -> void:
	is_moving = true
	
	var target := grass_nodes[current_index].global_position + offset
	
	var tween := create_tween()
	
	tween.tween_property(self, "global_position", target, move_duration)
	tween.finished.connect(func(): is_moving = false)
	
