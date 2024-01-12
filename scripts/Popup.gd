extends Control

var scriptToReturn : Node

func _ready():
	$YesButton.connect("pressed",func(): sendAnswer(true))
	$NoButton.connect("pressed",func(): sendAnswer(false))

func checkPlayerDecision(script, text):
	scriptToReturn = script
	$RichTextLabel.text = text
	visible = true

func sendAnswer(answer):
	scriptToReturn.playerDecision(answer)
	visible = false

