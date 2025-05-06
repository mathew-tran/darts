extends Node2D

class_name Game

var Par = 5
var Strokes = 0

signal SwingUpdate

var AirDirection = Vector2.ZERO
var AirSpeed = 10

signal AirUpdate

var LevelReference = null
var bLevelComplete = false
@export var CourseDataReference : CourseData

var Index = 0
func StartLevel(data : LevelData):
	if is_instance_valid(LevelReference):
		LevelReference.queue_free()
	$Bow.global_position = Vector2.ZERO
	Finder.GetItemGroup().Clear()
	Strokes = 0
	Par = data.Par
	var instance = data.Scene.instantiate()
	add_child(instance)
	LevelReference = instance
	
func GetNextLevel():
		var nextCourse = CourseDataReference.GetLevel(Index)
		if nextCourse:
			StartLevel(nextCourse)
			bLevelComplete = false
		else:
			print("end level")
func _ready() -> void:
	GetNextLevel()
	
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
	bLevelComplete = true
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
	Index += 1
	timer = get_tree().create_timer(3)
	await timer.timeout
	GetNextLevel()
	
func Wait(amount):
	var timer = get_tree().create_timer(amount)
	await timer.timeout
