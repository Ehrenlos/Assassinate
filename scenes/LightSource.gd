extends Node2D
var pos = Vector2()
export (int) var small_radius = 0
export (int) var big_radius = 0
export (Color) var small_color
export (Color) var big_color
const Player = preload("res://scripts/Player.gd")

func _ready():
	$Twilight/CollisionShape2D.shape.set_radius(big_radius)
	$BrightLight/CollisionShape2D.shape.set_radius(small_radius)
	pass

func _physics_process(delta):
	update()
	pass

func _draw():
	draw_circle(pos, big_radius, big_color)
	draw_circle(pos, small_radius, small_color)
	pass


func _on_BrightLight_body_entered(body):
	if (body is Player):
		body.light_level = 2


func _on_BrightLight_body_exited(body):
	if (body is Player):
		body.light_level = 1


func _on_Twilight_body_entered(body):
	if (body is Player):
		body.light_level = 1


func _on_Twilight_body_exited(body):
	if (body is Player):
		body.light_level = 0
