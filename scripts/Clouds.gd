extends Control

func animateClouds():
	for ch in $"Control1".get_children():
			var t = get_tree().create_tween()
			t.tween_property(ch,"rotation_degrees",30,4)
		
	for ch in $"Control2".get_children():
		var t = get_tree().create_tween()
		t.tween_property(ch,"rotation_degrees",-30,4)
	
	for ch in $"control3".get_children():
		var t = get_tree().create_tween()
		t.tween_property(ch,"rotation_degrees",-30,4)
