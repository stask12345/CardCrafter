extends requestingSlot

func addCard(c):
	var pos = c.global_position
	if c.get_parent() != null:
		c.get_parent().remove_child(c)
	add_child(c)
	c.global_position = pos
	
	c.goingToFinishGoal = true
	c.flyToPoint(Vector2(global_position.x + 30 - randi()%50,global_position.y))
