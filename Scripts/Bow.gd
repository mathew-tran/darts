extends Sprite2D

var bIsDrawing = false
func _process(delta: float) -> void:
	var mousePos = get_global_mouse_position()
	look_at(mousePos)
	UpdateLine()
	
func UpdateLine():
	var progress = 0
	if bIsDrawing:
		progress = lerp(-20, 0, $DrawTimer.time_left / $DrawTimer.wait_time)
	$Arrow.position.x = progress
	$Line2D.points[1].x = progress

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("click") and bIsDrawing == false:
		bIsDrawing = true
		$DrawTimer.start()
		
	if event.is_action_released("click"):
		bIsDrawing = false
		$DrawTimer.stop()
