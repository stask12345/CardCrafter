extends Control

@export var currentPackage : package
@export var packageSize = 4
var packageClickingProgress = 0

func _ready():
	$Button.connect("pressed",packageClicked)

func updatePackage(packageTexture, newPackage):
	$Image.texture = packageTexture
	currentPackage = newPackage
	packageClickingProgress = 0

@onready var particles = $"../CPUParticles2D"
var animationPlaying = false
func packageClicked():
	if !animationPlaying:
		animationPlaying = true
		
		var t = get_tree().create_tween()
		t.set_trans(Tween.TRANS_CUBIC)
		t.set_ease(Tween.EASE_OUT)
		
		if packageClickingProgress == 0:
			particles.amount = 12
			t.tween_property(self,"rotation_degrees",10,0.3)
			$"Image/000".visible = true
			$"Image/000".texture = load("res://graphics/animations/000.png")
		if packageClickingProgress == 1:
			t.tween_property(self,"rotation_degrees",-5,0.3)
			$"Image/000".texture = load("res://graphics/animations/001.png")
			$"Image/000".self_modulate = Color(1,1,1,0.5)
		if packageClickingProgress == 2:
			t.tween_property(self,"rotation_degrees",5,0.3)
			$"Image/000".texture = load("res://graphics/animations/002.png")
			$"Image/000".self_modulate = Color(1,1,1,0.6)
		if packageClickingProgress == 3:
			$"Image/000".texture = load("res://graphics/animations/003.png")
			$"Image/000".self_modulate = Color(1,1,1,0.7)
			t.tween_property(self,"rotation_degrees",0,0.2)
			t.parallel().tween_property(self,"scale",Vector2(0.7,0.7),0.2)
			t.tween_property(self,"scale",Vector2(1.2,1.2),0.5)
			t.parallel().tween_property($Image,"self_modulate",Color(2,2,2,2),0.5)
			t.tween_callback(openPackage)
			await get_tree().create_timer(0.7).timeout
			particles.amount = 20
			particles.emitting = true
		
		packageClickingProgress += 1
		animationPlaying = false

func openPackage():
	print("open")
	var cardInstance = preload("res://objects/Utility/InteractiveCard.tscn")
	for i in packageSize:
		var c : interactiveCard = cardInstance.instantiate()
		c.cardData = currentPackage.getRandomCard()
		
		get_node("/root/MainScene").add_child(c)
		var cardPosition = global_position
		if randi()%2 == 0:
			cardPosition.x += (30 + randi()%75)
		else:
			cardPosition.x -= (30 + randi()%75)
		if randi()%2 == 0:
			cardPosition.y += (30 + randi()%150)
		else:
			cardPosition.y -= (30 + randi()%150)
		c.global_position = cardPosition
		c.call_deferred("openPackageAnimation",global_position)
	set_deferred("visible",false)
	$"../AddButton".set_deferred("visible",true)
	
	$"Image/000".self_modulate = Color(1,1,1,0.4)
	$"Image/000".visible = false
	$Image.self_modulate = Color(1,1,1,1)
	scale = Vector2(1,1)

