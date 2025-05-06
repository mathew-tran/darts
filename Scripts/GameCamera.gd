extends Camera2D

class_name GameCamera

var ObjectToFocus = null
var FollowSpeed = 8000

enum MODE {
	AUTO,
	MANUAL
}

var CurrentMode = MODE.AUTO

signal HasFocusedOnScreen

var bForced = false
func Focus(obj, bHasBeenForced = false):
	ObjectToFocus = obj
	bForced = bHasBeenForced
	SetToAuto()
	
func ZoomIn():
	$AnimationPlayer.play("FocusIn")
	
func _process(delta: float) -> void:
	ProcessManual(delta)
	
	match CurrentMode:
		MODE.AUTO:
			ProcessAuto(delta)

func SetToAuto():
	CurrentMode = MODE.AUTO
	
func ProcessManual(delta):
	if bForced:
		CurrentMode = MODE.AUTO
		return
	var moveVector = Vector2.ZERO
	if Input.is_action_pressed("Left"):
		CurrentMode = MODE.MANUAL
		moveVector.x -= 1
	if Input.is_action_pressed("Right"):
		CurrentMode = MODE.MANUAL
		moveVector.x += 1
	if Input.is_action_pressed("Up"):
		CurrentMode = MODE.MANUAL
		moveVector.y -= 1
	if Input.is_action_pressed("Down"):
		CurrentMode = MODE.MANUAL
		moveVector.y += 1
		
	if Input.is_action_pressed("Space"):
		CurrentMode = MODE.AUTO
		
	if CurrentMode == MODE.MANUAL:
		global_position += moveVector * 500 * delta

func ProcessAuto(delta):
	if is_instance_valid(ObjectToFocus):
		var distance = ObjectToFocus.global_position.distance_to(global_position)
		var cameraSpeed = 0
		if distance > 0:
			cameraSpeed = lerp(10, FollowSpeed, distance / 1000)
		if distance > cameraSpeed * delta:
			var dir = (ObjectToFocus.global_position - global_position).normalized()
			global_position += dir * cameraSpeed * delta
		else:
			global_position = ObjectToFocus.global_position
			HasFocusedOnScreen.emit()
			ObjectToFocus = null
	
