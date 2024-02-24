extends Control

@export var barColor : Color
var totalTime : float
var oneShot = false

func _ready():
	$Progress/BarCircleFilling.self_modulate = barColor
	$Progress/BarCircleFilling2.self_modulate = barColor
	$Progress/BarCircleFilling.visible = true
	$Progress/BarCircleFilling2.visible = false
	$Progress/BarCircleFilling.rotation_degrees = 180
	$Progress/BarCircleFilling2.rotation_degrees = 180

func startBar(time, os = false): #os - oneShot
	totalTime = time
	if os:
		oneShot = true
	moveProgressBar()

var stopped : bool = false
func stopBar():
	t.kill()
	stopped = true

func resumeBar():
	stopped = false
	moveProgressBar(true)

var t : Tween
func moveProgressBar(resume = false):
	var firstBarTime : float
	var secondBarTime : float
	var skipFirstStep = false
	if !resume:
		firstBarTime = totalTime/2
		secondBarTime = firstBarTime
	else: #resuming
		if $Progress/BarCircleFilling.rotation_degrees != 0:
			firstBarTime = (($Progress/BarCircleFilling.rotation_degrees)/180) * (totalTime/2)
			secondBarTime = totalTime/2
		if $Progress/BarCircleFilling2.rotation_degrees != -180 and $Progress/BarCircleFilling2.rotation_degrees != 180:
			skipFirstStep = true
			secondBarTime = ((180+$Progress/BarCircleFilling2.rotation_degrees)/180) * (totalTime/2)
			firstBarTime = 0
	
	t = get_tree().create_tween()
	t.tween_property($Progress/BarCircleFilling,"rotation_degrees",0,firstBarTime)
	if !skipFirstStep:
		t.tween_callback(firstStep)
	t.tween_property($Progress/BarCircleFilling2,"rotation_degrees",-180,secondBarTime)
	t.tween_callback(secondStep)

func firstStep():
	$Progress/BarCircleFilling2.rotation_degrees = 0
	$Progress/BarCircleFilling2.visible = true
	$Progress.clip_contents = false

func secondStep():
	$Progress/BarCircleFilling.rotation_degrees = 180
	$Progress/BarCircleFilling2.rotation_degrees = 180
	$Progress/BarCircleFilling2.visible = false
	$Progress.clip_contents = true
	if !oneShot:
		moveProgressBar()
	else:
		oneShot = false


#var updating : bool = false
#var newTime : float
#func updateBarAnimation(time):
	#stop = false
	#updating = true
	#newTime = time
#
#var stop : bool = false
#var timeLeft : float = 0
#var timeFullOrginal : float = 0
#func stopBarAnimation():
	#updating = false
	#stop = true
	#if t:
		#t.kill()
#
#func animateBar(time : float):
	#if !updating:
		#$Progress/BarCircleFilling.visible = false
		#$Progress/BarCircleFilling2.visible = false
		#$Progress.clip_contents = true
		#$Progress/BarCircleFilling.rotation_degrees = 180
		#$Progress/BarCircleFilling.visible = true
		#moveBarProgress(time/2,$Progress/BarCircleFilling)
		#await get_tree().create_timer(time/2).timeout
		#if !stop:
			#$Progress/BarCircleFilling2.rotation_degrees = 0
			#$Progress/BarCircleFilling2.visible = true
			#$Progress.clip_contents = false
			#moveBarProgress(time/2,$Progress/BarCircleFilling2)
		#await get_tree().create_timer(time/2).timeout
		#if !stop:
			#animateBar(time)
	#else:
		#updating = false
		#animateBar(newTime)
#
#var t : Tween
#func moveBarProgress(time : float, pb : Node):
	#var obj = pb
	#t = get_tree().create_tween()
	#t.tween_property(pb,"rotation_degrees",pb.rotation_degrees - 180,time)
