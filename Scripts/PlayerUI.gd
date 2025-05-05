extends CanvasLayer

@onready var ParLabel = $VBoxContainer/ParLimit
@onready var StrokeLabel = $VBoxContainer2/Stroke
@onready var WindStrengthLabel = $VBoxContainer3/WindStrength
@onready var WindDirectionTexture = $VBoxContainer3/Control/WindDirection
func _ready() -> void:
	Finder.GetGame().SwingUpdate.connect(OnSwingUpdate)
	Finder.GetGame().AirUpdate.connect(OnAirUpdate)
	
func OnSwingUpdate(amount):
	$VBoxContainer2/Stroke.text = str(amount)

func OnAirUpdate():
	WindDirectionTexture.rotation = Finder.GetGame().AirDirection.angle()
	WindStrengthLabel.text = str(floor(Finder.GetGame().AirSpeed))
	var progress = Finder.GetGame().AirSpeed / 800.0
	WindDirectionTexture.modulate = lerp(Color.WHITE, Color.RED, progress)
