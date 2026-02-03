extends EnemyBase

@onready var animatableSprite: AnimatedSprite2D = $AnimatedSprite

enum State {DEFAULT, ATTACK}

var stateToString: Dictionary = {
	State.DEFAULT: "default", 
	State.ATTACK: "attack"
}

var state: State = State.DEFAULT

func _ready() -> void:
	snap_to_current()
	animatableSprite.animation_finished.connect(_on_animation_finished)
	animatableSprite.play(stateToString[state])

func attackAnimation() -> void:
	if state == State.ATTACK:
		return
	state = State.ATTACK
	_set_animation(state)
	
func _on_animation_finished() -> void:
	state = State.DEFAULT
	_set_animation(state)

func _set_animation(new_state: State) -> void:
	animatableSprite.play(stateToString[new_state])

func _process(delta: float) -> void:
	move_next()
