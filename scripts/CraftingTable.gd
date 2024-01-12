extends AreaLocation

@onready var rSlot = $requestingSlot
@export var availableRecipes : Array[recipy]
#TODO In future add highlighting of craft button, based on functions in AreaLocation class
func _ready():
	$CraftButton.connect("pressed",craft)

func craft():
	var currentResources = rSlot.returnResourceList()
	
	for r in availableRecipes:
		if r.checkValidity(currentResources):
			var intCard = r.returnOutputCard()
			intCard.global_position = Vector2(260,550)
			add_child(intCard)
			intCard.toPick = true
			rSlot.deleteAllCards()

