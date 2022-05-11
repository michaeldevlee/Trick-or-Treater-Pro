extends Area2D

onready var candySprite = get_node("Sprite")

var candyBagPosition = Vector2()

enum states {LET_GO, PICKED_UP}
var currentState = states.PICKED_UP

var currentCandy = ""
var currentCandyPoints = 0

func _ready():
	Global.currentCandyObject = self
	currentCandy = Global.pickedCandy
	position = Global.pickedCandyBagLocation
	if(currentCandy):
		candySprite.texture = Global.candyPictureList[currentCandy]
		currentCandyPoints = Global.candyPointList[currentCandy]

func removeCandy():
	queue_free()

func _physics_process(delta):
	if(currentState == states.PICKED_UP):
		global_position = get_global_mouse_position()

	
	



