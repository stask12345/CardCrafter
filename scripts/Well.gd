extends AreaLocation

var vessel : card = null
var progressNeeded : float = 1000

func cardArrived(c):
	vessel = c.cardData
	$requestingSlot.available = false
	$Graphics/AnimationPlayer.play("plumb_down")
	c.queue_free()


@onready var wellHandle = get_node("WellHandle")
func updateProgress(progress):
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
			$Graphics/AnimationPlayer.play("plumb_up")
