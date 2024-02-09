extends Control

func setUpRecipy(rec : recipy, id : int):
	$Name.text = rec.outputResource[0].cardName
	$Id.text = str(id + 1)
	if rec.outputResource[0].image != null:
		$Image.texture = rec.outputResource[0].image
	
	var container = $CenterContainer/HBoxContainer
	for i in rec.resources.size():
		for n in rec.quantity[i]:
			var ctr = Control.new()
			var image = TextureRect.new()
			image.texture = rec.resources[i].image
			image.scale = Vector2(0.05,0.05)
			ctr.add_child(image)
			container.add_child(ctr)
			if n < rec.quantity[i] - 1 or i < rec.resources.size() - 1:
				var imagePlus = TextureRect.new()
				imagePlus.texture = preload("res://graphics/coin.png")
				imagePlus.scale = Vector2(0.05,0.05)
				ctr = Control.new()
				ctr.add_child(imagePlus)
				container.add_child(ctr)
