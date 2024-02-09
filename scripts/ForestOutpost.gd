extends AreaLocation

@export var outpostCards : Array[card]
var lumberjackCard : card = null
var mineCard : card = null
@onready var outputReq1 = get_node("outpostOutput")
@onready var outputReq2 = get_node("Lumberjack/requestingSlot")
@onready var outputReq3 = get_node("Mine/requestingSlot")

func _ready():
	$Timer.connect("timeout",addOutpostCard)
	$ButtonBuildLumber.connect("pressed",tryToBuildOutpost)
	$ButtonBuildMine.connect("pressed",tryToBuildMine)

func addOutpostCard():
	if outputReq1.checkIfFull():
		var cardData = outpostCards.pick_random()
		var ic = system.createInteractiveCard(self,cardData)
		ic.global_position = outputReq1.global_position
		ic.toPick = true
		outputReq1.addCard(ic)

func addLumberjackCard():
	if outputReq2.checkIfFull():
		var ic = system.createInteractiveCard(self,lumberjackCard)
		ic.global_position = outputReq2.global_position
		ic.toPick = true
		outputReq2.addCard(ic)

func addMineCard():
	if outputReq3.checkIfFull():
		var ic = system.createInteractiveCard(self,mineCard)
		ic.global_position = outputReq3.global_position
		ic.toPick = true
		outputReq3.addCard(ic)

@export var lumberjackRecipy : recipy
func tryToBuildOutpost():
	system.popupUpgrade.showUpgradeMenu(lumberjackRecipy,self,0,false)

@export var mineRecipy : recipy
func tryToBuildMine():
	system.popupUpgrade.showUpgradeMenu(mineRecipy,self,1,false)

func upgradeBought(upgradeId = 0):
	if upgradeId == 0:
		buyLumberjack()
	if upgradeId == 1:
		buyMine()

func buyLumberjack():
	lumberjackCard = load("res://resources/cards/Forest/package/Wood.tres")
	outpostCards.erase(lumberjackCard)
	$ButtonBuildLumber.visible = false
	$Lumberjack/TimerLumberjack.connect("timeout",addLumberjackCard)
	$Lumberjack/TimerLumberjack.start()
	$Lumberjack.visible = true

func buyMine():
	mineCard = load("res://resources/cards/Forest/package/Rock.tres")
	outpostCards.erase(mineCard)
	$ButtonBuildMine.visible = false
	$Mine/TimerMine.connect("timeout",addMineCard)
	$Mine/TimerMine.start()
	$Mine.visible = true
