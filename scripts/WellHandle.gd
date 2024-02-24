extends Control

var spinning := false
@onready var centerMark = $Marker2D
var direction : bool = false
var progress : float = 0

func _ready():
	$WellWell/Button.connect("button_up",endSpin)
	$WellWell/Button.connect("button_down",startSpin)

func startSpin():
	spinning = true

func endSpin():
	spinning = false

func _input(event):
	if event is InputEventScreenDrag and spinning:
		centerMark.look_at(event.position)
		var degrees : float = centerMark.rotation_degrees
		if !direction:
			if $WellWell.rotation_degrees < degrees:
				progress += degrees - $WellWell.rotation_degrees
				$WellWell.rotation_degrees = degrees
				pullLine(0.7)
				updateProgress()
		else:
			if $WellWell.rotation_degrees > degrees:
				progress += $WellWell.rotation_degrees - degrees
				$WellWell.rotation_degrees = degrees
				pullLine(-1.4)
				updateProgress()
		print("progress ", progress)

func pullLine(direction):
	$"../Graphics/Bucket/BucketLine".global_position = Vector2($"../Graphics/Bucket/BucketLine".global_position.x,$"../Graphics/Bucket/BucketLine".global_position.y + direction)

func updateProgress():
	get_parent().updateProgress(progress)
