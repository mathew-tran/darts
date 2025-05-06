extends Area2D

var bIsHit = false
var Progress = 0.0001

func _ready() -> void:
	
	await Finder.GetGame().Wait(.4)
	Finder.GetCamera().Focus(self, true)
	Finder.GetCamera().HasFocusedOnScreen.connect(OnHasFocusedOnScreen)
	
	
func OnHasFocusedOnScreen():
	await Finder.GetGame().Wait(.4)
	Finder.GetCamera().Focus(Finder.GetBow(), false)
	Finder.GetCamera().HasFocusedOnScreen.disconnect(OnHasFocusedOnScreen)
	
func _on_body_entered(body: Node2D) -> void:
	var contactPoint = ( global_position - body.global_position).normalized()
	$Sprite2D.material.set_shader_parameter("impact_uv", contactPoint)
	Finder.GetGame().LevelComplete()
	bIsHit = true
	$Sprite2D.material.set_shader_parameter("time", Progress)

func _process(delta: float) -> void:
	if bIsHit:
		Progress += delta * 3
		$Sprite2D.material.set_shader_parameter("time", Progress)
		if Progress >= 4:
			queue_free()
