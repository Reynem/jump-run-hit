extends Node2D

@export var flower_scene: PackedScene
@onready var background: AnimatedSprite2D = $Background

var grass: Array[Node2D]

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	background.play("default")
	var grassObjects = $Grass.get_children()
	for k in grassObjects:
		grass.append(k as Node2D)
	var enemy = flower_scene.instantiate()
	grass.reverse()
	enemy.set_grass(grass)
	add_child(enemy)
	
