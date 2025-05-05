extends Node2D

class_name Game

var Par = 5
var Strokes = 0

signal SwingUpdate

var AirDirection = Vector2.ZERO
var AirSpeed = 10

signal AirUpdate

func _ready() -> void:
	DetermineAirSpeed()
	
func DetermineAirSpeed():
	
	var result = randi() % 100
	if result <= 70:		
		AirSpeed = randf_range(1, 50)
	elif result <= 98:
		AirSpeed = randf_range(100, 200)
	else:
		AirSpeed = randf_range(500, 600)
		
	AirDirection = Vector2(randf_range(-1,1), randf_range(-1,1))
	AirUpdate.emit()
	
func GetAirForce():
	return AirDirection * AirSpeed
	
func Swing():
	Strokes += 1
	SwingUpdate.emit(Strokes)
	
func LevelComplete():
	Engine.time_scale = .05
	var timer = get_tree().create_timer(.04)
	Finder.GetCamera().ZoomIn()
	await timer.timeout
	Engine.time_scale = .01
	timer = get_tree().create_timer(.02)
	await timer.timeout
	timer = get_tree().create_timer(.05)
	Engine.time_scale = .2
	await timer.timeout
	Engine.time_scale = 1
