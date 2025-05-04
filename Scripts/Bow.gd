extends Sprite2D

var bIsDrawing = false

var ArrowRef = null

func SpawnArrow():
	var instance = load("res://Prefabs/Arrow.tscn").instantiate()
	add_child(instance)
	instance.global_position = $SpawnPosition.global_position
	ArrowRef = instance
	instance.OnArrowPlaced.connect(OnArrowPlaced)
	
func OnArrowPlaced():
	$Camera2D.make_current()
	$Camera2D.enabled = true
	SpawnArrow()
	
func _ready() -> void:
	SpawnArrow()
	
	
func _process(delta: float) -> void:
	var mousePos = get_global_mouse_position()
	look_at(mousePos)
	UpdateLine()
	
func UpdateLine():
	var progress = 0
	if bIsDrawing:
		progress = lerp(-20, 0, $DrawTimer.time_left / $DrawTimer.wait_time)
	
	if ArrowRef:
		$Arrow.position.x = progress
	$Line2D.points[1].x = progress

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("click") and bIsDrawing == false:
		bIsDrawing = true
		$DrawTimer.start()
		
	if event.is_action_pressed("right_click"):
		bIsDrawing = false
		$DrawTimer.stop()
		
	if event.is_action_released("click"):
		var power = lerp(100, 1, $DrawTimer.time_left / $DrawTimer.wait_time)
		if is_instance_valid(ArrowRef) and bIsDrawing:
			$Arrow.Release(power)
			ArrowRef = null
			$Camera2D.enabled = false
		bIsDrawing = false
		$DrawTimer.stop()
