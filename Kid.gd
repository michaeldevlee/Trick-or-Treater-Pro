extends Node2D

onready var candyListLayout : VBoxContainer = get_node("KinematicBody2D/Candy Wanted List/Layout") as VBoxContainer
onready var kidInteractArea : CollisionShape2D = get_node("KinematicBody2D/Area2D/CollisionShape2D") as CollisionShape2D
onready var patienceTimer : Timer = get_node("PatienceTimer") as Timer
onready var selectedColor : TextureRect = get_node("SelectedColor") as TextureRect
onready var kidSprite : Node2D = get_node("KinematicBody2D/KidSprite") as Node2D
onready var patienceBar : ProgressBar = get_node("ProgressBar") as ProgressBar
onready var patienceBarTween : Tween = get_node("ProgressBarAnim") as Tween

var desiredCandiesAndQuantities : Dictionary
var maxAmountOfCandies = 3
var maxAmountOfEachCandy = 5
var rng = RandomNumberGenerator.new()
var masterCandyList : Array = Global.candyList.duplicate()
var scorePopUpScene = preload("res://ScorePopUp.tscn")

func _input(event):
	if Input.is_action_just_pressed("ui_down"):
		print(desiredCandiesAndQuantities)

func _ready():
	randomizeDesiredCandyList()	
	randomizeKidSelection()
	initailizeUI(desiredCandiesAndQuantities)
	initializeProgressBar()
		
func processCandy(givenCandy : String):
	if(desiredCandiesAndQuantities.has(givenCandy)):
		var candiesLeft = desiredCandiesAndQuantities[givenCandy]
		if(candiesLeft >= 1):
			playResponseAnimation(givenCandy, true, "CANDY")
			Global.score += Global.candyPointList[givenCandy]
			desiredCandiesAndQuantities[givenCandy] -= 1
			checkIfKidGotAllCandies()
			AudioPlayer.playSFX(AudioPlayer.rightCandySFX)
	else:
		Global.complaints += 1
		playResponseAnimation(givenCandy, false, "CANDY")
		AudioPlayer.playSFX(AudioPlayer.wrongCandySFX)
	
	Global.emit_signal("updateLivesandScore")
	updateTheUI(givenCandy, desiredCandiesAndQuantities)

func checkIfKidGotAllCandies():
	var candyList = desiredCandiesAndQuantities.keys()
	for x in desiredCandiesAndQuantities.size():
		var quantity = desiredCandiesAndQuantities[candyList[x]]
		if quantity == 0:
			continue
		else:
			return
	patienceTimer.stop()
	Global.emit_signal("kidReadyToMoveOut", self, "Happy")
	playResponseAnimation("HAPPY", true, "KID")
	AudioPlayer.playSFX(AudioPlayer.happyKidSFX)
	

func startPatienceTimer(seconds):
	patienceBar.visible = true
	patienceTimer.start(seconds)
	patienceBarTween.interpolate_property(patienceBar, "value", patienceBar.value, 0, seconds *2 ,Tween.TRANS_LINEAR,Tween.EASE_IN_OUT)
	patienceBarTween.start()


func _on_PatienceTimer_timeout():
	Global.emit_signal("kidReadyToMoveOut", self, "Mad")
	playResponseAnimation("MAD", true, "KID")

func updateCollisionState(true_or_false : bool):
	kidInteractArea.disabled = true_or_false

func initializeProgressBar():
	patienceBar.visible = false
	patienceBar.percent_visible = false

func initailizeUI(desiredCandyList : Dictionary):
	candyListLayout.updateInitialValues(desiredCandyList)

func updateTheUI(candyName : String, desiredCandyList : Dictionary):
	candyListLayout.updateValues(candyName, desiredCandyList)

func toggleHoverAnimation(boolean):
	selectedColor.visible = boolean

func removeKid():
	self.queue_free()

func randomizeDesiredCandyList():
	randomize()
	rng.randomize()
	for x in maxAmountOfCandies:
		var randomIndex = rand_range(0, masterCandyList.size())
		var randomQty = rng.randi_range(1, maxAmountOfEachCandy)
		desiredCandiesAndQuantities[masterCandyList[randomIndex]] = randomQty
		masterCandyList.remove(randomIndex)

func randomizeKidSelection():
	var kid : PackedScene = Global.listOfKids[randi() % Global.listOfKids.size()]
	var kidInstance = kid.instance()
	kidSprite.add_child(kidInstance)

func updateAnimationOnKidSprite(animationName : String, direction : int):
	var instancedKidSprite : Node2D = kidSprite.get_child(0) as Node2D
	if(instancedKidSprite):
		instancedKidSprite.updateAnimation(animationName, direction)

func _on_Area2D_area_entered(area):
	if(area.is_in_group("Spot")):
		Global.kidMoveToLocations[area.global_position] = Global.kidMoveToLocationStatus.OCCUPIED
		updateAnimationOnKidSprite("IDLE", 1)
	if(area.is_in_group("Remove")):
		removeKid()
		print("remove kid")
		
func _on_Area2D_area_exited(area):
	if(area.is_in_group("Spot")):
		Global.kidMoveToLocations[area.global_position] = Global.kidMoveToLocationStatus.OPEN
		updateAnimationOnKidSprite("WALKING", -1)
func _on_Area2D_mouse_entered():
	Global.isCandyNearKid = true
	Global.selectedKid = self
	toggleHoverAnimation(true)

func _on_Area2D_mouse_exited():
	Global.isCandyNearKid = false
	Global.selectedKid = null
	toggleHoverAnimation(false)

func playResponseAnimation(candyName : String, isCandyCorrect : bool, type : String):
	var scorePopUpInstance : Node2D = scorePopUpScene.instance()
	var scorePopUp = add_child(scorePopUpInstance)
	var getMousePos = get_global_mouse_position()

	if(scorePopUpInstance && type == "CANDY"):
		scorePopUpInstance.global_position = getMousePos
		scorePopUpInstance.playCandyAnimation(candyName, isCandyCorrect)
	elif(scorePopUpInstance && type == "KID"):
		var kidMood = candyName
		scorePopUpInstance.global_position = candyListLayout.rect_global_position
		scorePopUpInstance.playKidAnimation(kidMood)
		
		
