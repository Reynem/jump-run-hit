extends Node2D

@export var flower_scene: PackedScene

var grass: Array[Node2D]

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var grassObjects = $Grass.get_children()
	for k in grassObjects:
		grass.append(k as Node2D)
	grass.reverse()

	var enemy = flower_scene.instantiate()
	enemy.z_index = 10
	enemy.set_grass(grass)
	add_child(enemy)
	
