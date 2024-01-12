extends Resource
class_name card
@export var cardName : String
@export var value : int
@export var image : Texture2D
enum orginType {forest, mine, exploration}
@export var origin : orginType
@export var handOrder : int

@export_group("Special")
@export var fuelPower : int
@export var fuelNeededInProduction : int
@export var meltingOutputCard : card
