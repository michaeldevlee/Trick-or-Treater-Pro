extends Node2D

var animPlayer : AnimationPlayer
var scoreText : Label

func _ready():
	animPlayer = get_node("ResponseAnimPlayer")
	scoreText = get_node("ScorePopUp")

func playCandyAnimation(candyName : String, isCandyCorrect : bool):
	if(animPlayer && scoreText):
		if isCandyCorrect:
			scoreText.set_text("+ %d" % [Global.candyPointList[candyName]])
			animPlayer.play("Right Candy")
		else:
			scoreText.set_text("x")
			animPlayer.play("Wrong Candy")

func playKidAnimation(kidMood : String):
	if(animPlayer && scoreText):
		if kidMood == "HAPPY":
			scoreText.set_text("+ %d" % [10000])
			animPlayer.play("Right Candy")
		else:
			scoreText.set_text("COMPLAINT")
			animPlayer.play("Wrong Candy")
func removeScorePopUp():
	queue_free()

