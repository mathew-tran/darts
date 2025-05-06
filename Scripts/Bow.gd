extends Sprite2D

class_name Bow

var bIsDrawing = false

var ArrowRef = null

var bIsActive = false

func SpawnArrow():
	var instance = load("res://Prefabs/Arrow.tscn").instantiate()
	add_child(instance)
	instance.global_position = $SpawnPosition.global_position
	ArrowRef = instance
	instance.OnArrowPlaced.connect(OnArrowPlaced)
	
func OnArrowPlaced(newPosition):
	global_position = newPosition
	Finder.GetCamera().Focus(self)
	SpawnArrow()
	Finder.GetGame().DetermineAirSpeed()
	
func _ready() -> void:
	OnArrowPlaced(global_position)
	
	
	
func _process(delta: float) -> void:
	if Finder.GetGame().bLevelComplete:
		return
	var mousePos = get_global_mouse_position()
	look_at(mousePos)
	UpdateLine()
	
	if Input.is_action_pressed("click") and bIsActive:
		$DrawLine.points[1] = to_local(get_global_mouse_position())
		var width = lerp(4, 1, $DrawTimer.time_left / $DrawTimer.wait_time)
		$DrawLine.default_color = lerp(Color.RED, Color.WHITE, $DrawTimer.time_left / $DrawTimer.wait_time)
		$DrawLine.width = width
	else:
		$DrawLine.points[1] = Vector2.ZERO
	
func UpdateLine():
	var progress = 0
	if bIsDrawing:
		progress = lerp(-20, 0, $DrawTimer.time_left / $DrawTimer.wait_time)
	
	if ArrowRef:
		$Arrow.position.x = progress
	$Line2D.points[1].x = progress

func _input(event: InputEvent) -> void:
	if Finder.GetGame().bLevelComplete:
		return
		
	if event.is_action_pressed("click") and bIsDrawing == false:
		bIsDrawing = true
		$DrawTimer.start()
		bIsActive = true
	

			
	if event.is_action_pressed("right_click"):
		bIsDrawing = false
		$DrawTimer.stop()
		bIsActive = false
		
	if event.is_action_released("click"):
		var power = lerp(100, 1, $DrawTimer.time_left / $DrawTimer.wait_time)
		if is_instance_valid(ArrowRef) and bIsDrawing:
			$Arrow.Release(power)
			ArrowRef = null
			Finder.GetGame().Swing()
		bIsDrawing = false
		bIsActive = false
		$DrawTimer.stop()
		
