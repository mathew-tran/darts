extends Area2D

var bIsHit = false
var Progress = 0.0001

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
