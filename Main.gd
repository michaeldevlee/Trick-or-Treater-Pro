extends Node2D

onready var lifeAndScoreUI : Node2D = get_node("UI") as Node2D
onready var spawnTimer : Timer = get_node("Timers/KidSpawnerTimer") as Timer
onready var mainTimer : Timer = get_node("Timers/Main Timer") as Timer
onready var kidMover : Tween = get_node("KidMover") as Tween
onready var kidSpawnArea : Area2D = get_node("Kid Spawn Area") as Area2D
onready var removeArea : Area2D = get_node("Game Area/RemoveArea") as Area2D
onready var gameOverScreen : Node2D = get_node("Game Over Screen/Game Over Screen") as Node2D
onready var titleScreen : Node2D = get_node("Title Screen") as Node2D
onready var winScreen : Node2D = get_node("Win Screen/Win Screen") as Node2D
onready var awesomeWinScreen : Node2D= get_node("Win Screen2/Win Screen") as Node2D
onready var tutorialScreen : Node2D= get_node("Tutorial Screen") as Node2D
onready var mainTimerText : Label = get_node("UI/Time/Time Left") as Label
onready var screenTransitionPlayer : AnimationPlayer = get_node("ScreenTransition/TransitionPlayer") as AnimationPlayer

enum candyHoldingStatus {HOLDING, NOT_HOLDING}
enum kidMoveToLocationStatus {OCCUPIED , OPEN}
enum gameState {GAME_IN_PROGRESS, GAME_OVER}

var candy = preload("res://Candy.tscn")
var kid = preload("res://Kid.tscn")
var currentHoldingStatus = candyHoldingStatus.NOT_HOLDING
var currentGameState = gameState.GAME_IN_PROGRESS
var candyInHandName : String
var candyInHandObject : Node2D
var selectedKid : Node2D
var kidMoveToLocations : Dictionary = {}
var openLocations : Array = []
var currentKidStatus
var numberOfKidsOnField : int = 0
var kidPatienceTime : int = 26


export var pointsToWin : int
export var pointsToWinAwesomely : int


func _ready():
	gameInitialization()


func _input(event):
	if event is InputEventMouseButton and currentHoldingStatus == candyHoldingStatus.HOLDING:
		if event.pressed and event.button_index == 1 and Global.isCandyNearKid:
			giveTheCandy(candyInHandName)
			candyInHandObject.queue_free()
			currentHoldingStatus = candyHoldingStatus.NOT_HOLDING
		elif event.pressed and event.button_index == 1 and !Global.isCandyNearKid:
			candyInHandObject.queue_free()
			currentHoldingStatus = candyHoldingStatus.NOT_HOLDING
	
	if Input.is_action_just_pressed("ui_down"):
		print(numberOfKidsOnField)
		
func takeOutCandy(candyName):
	if(currentHoldingStatus == candyHoldingStatus.NOT_HOLDING):
		playSFX(AudioPlayer.candyPickUpSFX)
		currentHoldingStatus = candyHoldingStatus.HOLDING
		Global.pickedCandy = candyName
		var candyInstance = candy.instance()
		candyInHandObject = candyInstance
		candyInHandName = candyName	
		add_child(candyInstance)
		
func giveTheCandy(candyThatYoureHolding):
	candyThatYoureHolding = candyInHandName
	selectedKid = Global.selectedKid
	if selectedKid && selectedKid.is_in_group("Kid"):
		selectedKid.processCandy(candyThatYoureHolding)
		
func updateLifeandScoreUI():
	lifeAndScoreUI.updateUI()
	checkComplaints()

func startSpawnTimer(seconds_interval):
	spawnTimer.start(seconds_interval)

func _on_KidSpawnerTimer_timeout():
	if(currentGameState == gameState.GAME_IN_PROGRESS and numberOfKidsOnField < 5):
		print("adding kid")
		var newKid = kid.instance()
		add_child(newKid)
		newKid.global_position = kidSpawnArea.global_position
		moveKidToLocation(newKid)
		updateKidCount()
	else:
		updateKidCount()

func updateKidCount():
	var kidCount = get_tree().get_nodes_in_group("Kid")
	numberOfKidsOnField = kidCount.size()

func setKidMoveToLocations():
	var moveToLocations = get_node("Kid Stop Areas")
	for x in moveToLocations.get_children():
		Global.kidMoveToLocations[x.position] = Global.kidMoveToLocationStatus.OPEN

func scanForOpenMoveToLocations():
	if(openLocations.size() < 6):
		var moveLocations = Global.kidMoveToLocations.keys()
		var moveLocationsStatus = Global.kidMoveToLocations.values()
		for x in moveLocationsStatus.size():
			if moveLocationsStatus[x] == Global.kidMoveToLocationStatus.OPEN:
				Global.openLocations.append(moveLocations[x])

func randomizeMoveToLocations():
	scanForOpenMoveToLocations()
	var randomNumberGen = RandomNumberGenerator.new()
	randomNumberGen.randomize()	
	if(Global.openLocations.size() != 0):
		var randomIndex = randomNumberGen.randi_range(0, Global.openLocations.size()-1)
		return Global.openLocations[randomIndex]

func moveKidToLocation(newKid : Node2D):
	updateKidCount()
	if(newKid):
		kidMover.interpolate_property(newKid, "position", newKid.position, randomizeMoveToLocations(),4,Tween.TRANS_LINEAR,Tween.EASE_IN)
		kidMover.start()
		Global.openLocations.clear()
		newKid.updateCollisionState(true)
		yield(get_tree().create_timer(4),"timeout")
		if(newKid):
			newKid.updateCollisionState(false)
			newKid.startPatienceTimer(kidPatienceTime)
		

func moveKidOutOfScreen(newKid : Node2D, mood : String):
	if(newKid):
		kidMover.interpolate_property(newKid, "position", newKid.position, removeArea.global_position ,4,Tween.TRANS_LINEAR,Tween.EASE_IN)
		kidMover.start()
		Global.openLocations.clear()
		newKid.updateCollisionState(true)
		if(mood == "Mad"):
			Global.complaints += 1
			playSFX(AudioPlayer.madKidSFX)
			updateLifeandScoreUI()
		else:
			Global.score += 10000
			playSFX(AudioPlayer.happyKidSFX)
		yield(get_tree().create_timer(4),"timeout")
		if(newKid):
			newKid.updateCollisionState(false)

func _on_Candy_Corn_Bag_button_up():
	takeOutCandy("Candy Corn")

func _on_Skull_Candy_Bag_button_up():
	takeOutCandy("Skull Candy")

func _on_Heart_Pop_Bag_button_up():
	takeOutCandy("Heart Pop")

func _on_ChocoBar_Bag_button_up():
	takeOutCandy("ChocoBar")

func _on_Bone_Pixie_Dust_Bag_button_up():
	takeOutCandy("Bone Pixie Dust")

func _on_Web_Pie_Bag_button_up():
	takeOutCandy("Web Pie")

func gameInitialization():
	Global.connect("updateLivesandScore", self, "updateLifeandScoreUI")
	Global.connect("kidReadyToMoveOut", self, "moveKidOutOfScreen")
	lifeAndScoreUI.visible = true
	screenTransitionPlayer.play("Start Game Ease In")
	updateLifeandScoreUI()
	setKidMoveToLocations()

func startTutorial():
	pass

func startGame():
	mainTimer.start(100)
	spawnTimer.start(6)

func resetGame():
	resetStats()
	removeAllKidsOnScreen()
	updateKidCount()
	updateLifeandScoreUI()
	resetGlobalVariables()

func _on_Main_Timer_timeout():
	mainTimer.stop()
	spawnTimer.stop()
	checkIfYouGotEnoughPointsToWin()

func checkIfYouGotEnoughPointsToWin():
	if(Global.score >= pointsToWin && Global.score < pointsToWinAwesomely):
		togglePause(true)
		toggleWinScreenVisibility(true)
		playSFX(AudioPlayer.winSFX)
	elif(Global.score >= pointsToWinAwesomely):
		toggleAwesomeWinScreenVisibility(true)
	else:
		togglePause(true)
		toggleGameOverScreenVisibility(true)
		playSFX(AudioPlayer.evilLaugh)

func checkComplaints():
	if(Global.complaints > 4):
		togglePause(true)
		toggleGameOverScreenVisibility(true)
		playSFX(AudioPlayer.evilLaugh)

func removeAllKidsOnScreen():
	var allKidsInScene = get_tree().get_nodes_in_group("Kid")
	for x in allKidsInScene:
		x.queue_free()

func resetGlobalVariables():
	Global.selectedKid = null

func resetStats():
	Global.complaints = 0
	Global.score = 0

func toggleGameOverScreenVisibility(boolean : bool):
	gameOverScreen.visible = boolean
	
func toggleWinScreenVisibility(boolean : bool):
	winScreen.visible = boolean

func toggleAwesomeWinScreenVisibility(boolean : bool):
	awesomeWinScreen.visible = boolean

func togglePause(boolean : bool):
	get_tree().paused = boolean

func toggleTitleScreen(boolean : bool):
	titleScreen.visible = boolean
	
func toggleTutorialScreen(boolean : bool):
	tutorialScreen.visible = boolean

func _on_Play_Button_button_up():
	toggleTitleScreen(false)
	toggleTutorialScreen(true)

func _on_Tutorial_OK_Button_button_up():
	toggleTutorialScreen(false)
	startGame()

func _on_Exit_Button_button_up():
	get_tree().quit()

func _on_Restart_Button_button_up():
	togglePause(false)
	toggleGameOverScreenVisibility(false)
	resetGame()
	startGame()

func _on_Game_Over_Exit_Button_button_up():
	get_tree().quit()

func _on_Win_Restart_Button_button_up():
	togglePause(false)
	toggleWinScreenVisibility(false)
	resetGame()
	startGame()

func _on_Win_Exit_Button_button_up():
	get_tree().quit()

func _process(delta):
	mainTimerText.set_text("%d" % [mainTimer.time_left])

func _on_Awesome_Win_Restart_Button_button_up():
	toggleAwesomeWinScreenVisibility(false)
	togglePause(true)
	resetGame()
	startGame()

func _on_Awesome_Win_Exit_Button_button_up():
	get_tree().quit()

func initiateMusic():
	AudioPlayer.playMusic(AudioPlayer.levelMusic)

func initiateAmbienceSFX():
	AudioPlayer.playAmbience(AudioPlayer.levelAmbience)

func playSFX(stream):
	AudioPlayer.playSFX(stream)
