extends Control

func setUpList(rec):
	var container = $CenterContainer/HBoxContainer
	for i in 4:
		if i < rec.resources.size():
			container.get_child(i).text = str(rec.quantity[i])
			container.get_child(i).get_child(0).texture = rec.resources[i].image
			container.get_child(i).visible = true
