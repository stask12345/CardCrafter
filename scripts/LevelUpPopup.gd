extends Control

var enabledExit = false

func _ready():
	$ExitButton.connect("pressed",exitRankUpAnimation)

func enableExit():
	enabledExit = true

func exitRankUpAnimation():
	if enabledExit:
		$AnimationPlayer.play("close")
