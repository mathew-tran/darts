extends Sprite2D

class_name Bow

var bIsDrawing = false

var ArrowRef = null

var bIsActive = false

var Bounces = 0
var MaxBounces = 3
var LastValidPosition = Vector2.ZERO
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
	LastValidPosition = global_position
	OnArrowPlaced(global_position)
	Redraw()
	
	
	
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
	$HBoxContainer.global_position = get_global_mouse_position()
	
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
		Redraw()
		
	if event.is_action_released("click"):
		var power = lerp(100, 1, $DrawTimer.time_left / $DrawTimer.wait_time)
		if is_instance_valid(ArrowRef) and bIsDrawing:
			
			var percent = GetBouncePercent()
			$Arrow.Bounces = Bounces
				
			print(str(percent) + ", bounces: " + str(Bounces))
			$Arrow.Release(power)
			ArrowRef = null
			Finder.GetGame().Swing()
		Redraw()
		
func GetBouncePercent():
	return $BounceTimer.time_left / $BounceTimer.wait_time

func Redraw():
	bIsDrawing = false
	bIsActive = false
	$DrawTimer.stop()
	$BounceTimer.stop()
	Bounces = 0
	UpdateUI()
	
func _on_draw_timer_timeout() -> void:
	$BounceTimer.start()
	Bounces = 0


func _on_bounce_timer_timeout() -> void:
	if Bounces < MaxBounces:
		Bounces += 1
	UpdateUI()

func UpdateUI():
	for x in range(0, len($HBoxContainer.get_children())):
		$HBoxContainer.get_child(x).visible = x < Bounces


func _on_overlap_check_body_entered(body: Node2D) -> void:
	var closestPosition = GetClosestOpenPosition()
	if closestPosition == global_position:
		closestPosition = LastValidPosition
	else:
		LastValidPosition = closestPosition
	global_position = closestPosition

func GetClosestOpenPosition():
	$RayCast2D.target_position = Vector2.RIGHT * 20
	var crossSections = 12
	for x in range(0, crossSections):
		
		$RayCast2D.force_raycast_update()
		if $RayCast2D.get_collider() == null:
			return $RayCast2D.global_position + $RayCast2D.target_position
		$RayCast2D.rotation_degrees += 360 / crossSections
	print("Could not find an open position")
	return global_position
