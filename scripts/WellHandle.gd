extends Control

var spinning := false
@onready var centerMark = $Marker2D
var direction : bool = false
var progress : float = 0

func _ready():
	$Icon/Button.connect("button_up",endSpin)
	$Icon/Button.connect("button_down",startSpin)

func startSpin():
	spinning = true

func endSpin():
	spinning = false

func _input(event):
	if event is InputEventScreenDrag and spinning:
		centerMark.look_at(event.position)
		var degrees : float = centerMark.rotation_degrees
		if !direction:
			if $Icon.rotation_degrees < degrees:
				progress += degrees - $Icon.rotation_degrees
				$Icon.rotation_degrees = degrees
				updateProgress()
		else:
			if $Icon.rotation_degrees > degrees:
				progress += $Icon.rotation_degrees - degrees
				$Icon.rotation_degrees = degrees
				updateProgress()
		print("progress ", progress)

func updateProgress():
	get_parent().updateProgress(progress)
