extends Control

func setUpRecipy(rec : recipy, id : int, newRecipy : bool = false):
	$Name.text = rec.outputResource[0].cardName
	$Id.text = "#" + str(id + 1)
	if rec.outputResource[0].image != null:
		$Image.texture = rec.outputResource[0].image
	
	var container = $CenterContainer/HBoxContainer
	for i in rec.resources.size():
		for n in rec.quantity[i]:
			var ri = load("res://objects/Utility/ItemImage.tscn").instantiate()
			ri.get_node("Sprite2D").texture = rec.resources[i].image
			ri.get_node("Label").text = rec.resources[i].cardName
			if newRecipy:
				ri.get_node("Label").self_modulate = Color.WHITE
			container.add_child(ri)
			if n < rec.quantity[i] - 1 or i < rec.resources.size() - 1:
				var imagePlus = TextureRect.new()
				imagePlus.texture = preload("res://graphics/UI/plus.png")
				imagePlus.scale = Vector2(0.4,0.4)
				imagePlus.position = Vector2(15,12)
				var ctr = Control.new()
				ctr.add_child(imagePlus)
				container.add_child(ctr)
