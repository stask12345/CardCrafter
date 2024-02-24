extends Sprite2D

var value : int
@onready var system : controlSystem = get_node("/root/MainScene")
@export var bronze1 : Texture
@export var bronze5 : Texture
@export var bronze10 : Texture
@export var bronze50 : Texture

func _ready():
	if value == 1:
		texture = bronze1
		z_index += 1
	else:
		if value == 5:
			texture = bronze5
			z_index += 2
		else:
			if value == 10:
				texture = bronze10
				z_index += 3
			else:
				if value == 50:
					texture = bronze50
					z_index += 4

func addCoin():
	var t = get_tree().create_tween()
	t.set_trans(Tween.TRANS_CUBIC)
	t.set_ease(Tween.EASE_IN)
	
	t.tween_property(self,"global_position",Vector2(500,25),1)
	t.parallel().tween_property(self,"scale",Vector2(0.05,0.05),1)
	t.parallel().tween_property(self,"self_modulate",Color(1,1,1,0.2),1)
	t.tween_callback(monetize)

func flyToPoint(pos : Vector2, add = false):
	var t = get_tree().create_tween()
	t.set_trans(Tween.TRANS_CUBIC)
	t.set_ease(Tween.EASE_OUT)
	
	t.tween_property(self,"global_position",pos,1)
	if add:
		t.tween_callback(addCoin)

func monetize():
	system.moneySystemNode.addMoney(value)
	queue_free()
