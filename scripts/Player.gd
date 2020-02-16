extends KinematicBody2D
const UP = Vector2(0, -1) 
export (int) var GRAVITY = 20
export (int) var ACCELERATION = 50
export (int) var MAX_SPEED = 200
export (int) var JUMP_HEIGHT = 500
var motion = Vector2()
var canJump = true
var canHold = true
var onWall = false
var light_level = 0


func _physics_process(delta):
	update()
	motion.y += GRAVITY
	var friction = false
	if Input.is_action_pressed('move_right'):
		motion.x += ACCELERATION
		motion.x = min(motion.x + ACCELERATION, MAX_SPEED)
		$Sprite.flip_h = false
		$Sprite.play('Run')
	elif Input.is_action_pressed('move_left'):
		motion.x -= ACCELERATION
		motion.x = max(motion.x - ACCELERATION, -MAX_SPEED)
		$Sprite.flip_h = true
		$Sprite.play('Run')
	else:
		$Sprite.play('Idle')
		friction = true
		motion.x = lerp(motion.x, 0, 0.2)
	
	if is_on_floor():
		if Input.is_action_just_pressed('jump'):
			motion.y = -JUMP_HEIGHT
		if friction == true:
			motion.x = lerp(motion.x, 0, 0.2)
	else:
		if is_on_wall():
			if onWall == false:
				$FallTimer.start()
			onWall = true
			if motion.y > 0:
				if canHold:
					motion.y *= 0.6
			else:
				motion.y *= 0.9
			if Input.is_action_just_pressed('jump') && canJump == true:
				canJump = false
				motion.y = -JUMP_HEIGHT
		else:
			onWall = false
			canHold = true
			canJump = true
		if motion.y < 0:
			$Sprite.play('Jump')
		elif is_on_wall():
			$Sprite.play('Slide Down')
		else:
			$Sprite.play('Fall')
		if friction == true:
			motion.x = lerp(motion.x, 0, 0.05)
	
	motion = move_and_slide(motion, UP)
	pass

func _on_FallTimer_timeout():
	canJump = false
	canHold = false
