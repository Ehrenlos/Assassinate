extends Node2D

export (Vector2) var center = Vector2(0, 0)
export (int) var radius = 80
export (int) var angle_from = 30
export (int) var angle_to = 150
export (Color) var color = Color(0.0, 0.0, 0.0, 0.0)
var is_player_in_view = false
var contact_to_player = false
var player
var viewer_position


func _physics_process(delta):
	var space_state = get_world_2d().direct_space_state
	create_collision_circle_arc_poly(center, radius, angle_from, angle_to)
	update()
	contact_to_player = false
	if is_player_in_view == true:
		var result = space_state.intersect_ray(position, player.position - viewer_position, [self, player])
		if result:
			if result.collider.is_in_group('Transparent'):
				contact_to_player = true
			else:
				contact_to_player = false
		else:
			contact_to_player = true

func _draw():
	#draw_circle_arc_poly(center, radius, angle_from, angle_to, color)
	if is_player_in_view:
		draw_line(Vector2(), player.position - viewer_position, Color(0.0, 1.0, 0.0, 1.0), 1)

func draw_circle_arc(center, radius, angle_from, angle_to, color):
	var nb_points = 32
	var points_arc = PoolVector2Array()
	for i in range(nb_points+1):
		var angle_point = deg2rad(angle_from + i * (angle_to-angle_from) / nb_points - 90)
		points_arc.push_back(center + Vector2(cos(angle_point), sin(angle_point)) * radius)
	for index_point in range(nb_points):
		draw_line(points_arc[index_point], points_arc[index_point + 1], color)

func draw_circle_arc_poly(center, radius, angle_from, angle_to, color):
	var nb_points = 32
	var points_arc = PoolVector2Array()
	points_arc.push_back(center)
	var colors = PoolColorArray([color])
	for i in range(nb_points+1):
		var angle_point = deg2rad(angle_from + i * (angle_to - angle_from) / nb_points - 90)
		points_arc.push_back(center + Vector2(cos(angle_point), sin(angle_point)) * radius)
	draw_polygon(points_arc, colors)
	$CollisionPolygon2D.polygon = points_arc

func create_collision_circle_arc_poly(center, radius, angle_from, angle_to):
	var nb_points = 32
	var points_arc = PoolVector2Array()
	points_arc.push_back(center)
	for i in range(nb_points+1):
		var angle_point = deg2rad(angle_from + i * (angle_to - angle_from) / nb_points - 90)
		points_arc.push_back(center + Vector2(cos(angle_point), sin(angle_point)) * radius)
	$CollisionPolygon2D.polygon = points_arc

func _on_View_body_entered(body):
	if body.is_in_group('Player'):
		is_player_in_view = true
		player = body


func _on_View_body_exited(body):
	if body.is_in_group('Player'):
		is_player_in_view = false
