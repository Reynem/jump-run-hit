extends EnemyBase

@onready var animatableSprite: AnimatedSprite2D = $AnimatedSprite
@onready var attackTimer: Timer = $AttackTimer

@export var attack_time_step := 1.5

var pending_state: State = State.DEFAULT
var is_waiting_for_transition: bool = false

enum State {DEFAULT, ATTACK}

var stateToString: Dictionary = {
	State.DEFAULT: "default", 
	State.ATTACK: "attack"
}

var state: State = State.DEFAULT

func _ready() -> void:
	snap_to_current()
	# Подключение сигналов
	animatableSprite.animation_finished.connect(_on_animation_finished)
	animatableSprite.animation_looped.connect(_on_animation_looped)
	
	attackTimer.timeout.connect(attackAnimation)
	animatableSprite.play(stateToString[state])

func move_next() -> void:
	super()
	# Проверка: не в режиме атаки и таймер еще не запущен
	if (current_index + 1 >= grass_nodes.size()
		and state == State.DEFAULT
		and not is_waiting_for_transition
		and attackTimer.is_stopped()
	):
		_start_attack_timer()

func _start_attack_timer() -> void:
	attackTimer.start(attack_time_step * randf_range(0.85, 1))

func attackAnimation() -> void:
	request_state_change(State.ATTACK)

func request_state_change(new_state: State) -> void:
	if state == new_state:
		return
	
	pending_state = new_state
	is_waiting_for_transition = true
	print("Запрос на смену состояния: ", stateToString[new_state])

func _on_animation_looped() -> void:
	if is_waiting_for_transition:
		_apply_transition()

func _on_animation_finished() -> void:
	if state != State.DEFAULT:
		state = State.DEFAULT
		_set_animation(state)

func _apply_transition() -> void:
	state = pending_state
	_set_animation(state)
	is_waiting_for_transition = false
	print("Состояние изменено на: ", stateToString[state])

func _set_animation(new_state: State) -> void:
	animatableSprite.play(stateToString[new_state])

func _process(_delta: float) -> void:
	move_next()
