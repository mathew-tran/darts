extends RigidBody2D

var StuckRotation = Vector2.ZERO
var StuckPosition = Vector2.ZERO

signal OnArrowPlaced(hitPosition)

var bCanUse = true
var velocity = Vector2.ZERO

func _ready() -> void:
	# Initial setup
	freeze = true
	$CollisionShape2D.disabled = true

func Release(power):

	freeze = false
	$CollisionShape2D.disabled = false
	velocity = global_transform.x * power * 20
	print("release: " + str(power))
	reparent(Finder.GetItemGroup(), true)
	Finder.GetCamera().Focus(self)

func _process(delta: float) -> void:
	if not sleeping and velocity.length() > 0:
		rotation = velocity.angle()
		StuckRotation = rotation
		StuckPosition = global_position
		velocity.y += 1000 * delta 
		MoveAndCollide(delta)

func MoveAndCollide(delta: float) -> void:
	var motion = velocity * delta
	
	var collision = move_and_collide(motion)
	
	if collision:
		Stop()

func Stop():
	if bCanUse == false:
		return
		
	set_physics_process(false)
	set_process(false)
	bCanUse = false
	
	print("hit")
	
	global_position = StuckPosition
	global_rotation = StuckRotation
	
	$CollisionShape2D.disabled = true
	
	lock_rotation = true
	angular_velocity = 0
	velocity = Vector2.ZERO
	gravity_scale = 0
	
	sleeping = true
	
	set_freeze_mode(RigidBody2D.FREEZE_MODE_STATIC)
	print("sleep")
	
	OnArrowPlaced.emit($SpawnPosition.global_position)
