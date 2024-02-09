extends AreaLocation

var vessel : card = null
var progressNeeded : float = 1000

func cardArrived(c):
	vessel = c.cardData
	$WellHandle.visible = true
	$requestingSlot.available = false


@onready var wellHandle = get_node("WellHandle")
func updateProgress(progress):
	$Label.text = str(progress / progressNeeded)
	if progress >= progressNeeded:
		if !wellHandle.direction:
			wellHandle.progress = 0
			wellHandle.direction = true
		else:
			var cardData = vessel.outputCard
			var ic = system.createInteractiveCard(self,cardData)
			ic.global_position = $LocationIndicator.global_position
			ic.flyToHand()
			
			wellHandle.direction = false
			wellHandle.progress = 0
			$WellHandle.visible = false
			$requestingSlot.available = true
