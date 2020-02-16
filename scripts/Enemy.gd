extends RigidBody2D
export (int) var GRAVITY = 20
var motion = Vector2()
export (int) var DETECT_RADIUS = 256
var player
signal change_state(current, former)
enum State {UNPREPARED, CONFUSED, READY}
var currentState = State.UNPREPARED
var formerState = State.UNPREPARED

func _ready():
	$View.radius = DETECT_RADIUS

func _physics_process(delta):
	$View.viewer_position = position
	motion.y += GRAVITY
	if $View.contact_to_player == true:
		player = $View.player
		if player.light_level == 2:
			print(player.light_level)
		elif player.light_level == 1:
			print(player.light_level)
	if formerState != currentState:
		emit_signal("change_state", currentState, formerState)
	formerState = currentState

func _on_Enemy_change_state(current, former):
	print(current, " - ", former)
