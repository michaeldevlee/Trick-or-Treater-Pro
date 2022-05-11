extends Node2D

export var complaintCountPath : NodePath
export var complaintTextPath : NodePath
export var scoreCountPath : NodePath
export var scoreTextPath : NodePath

var complaintCount : Label
var complaintText : Label
var scoreCount : Label
var scoreText : Label

func _ready():
	complaintCount = get_node(complaintCountPath)
	complaintText = get_node(complaintTextPath)
	scoreCount = get_node(scoreCountPath)
	scoreText = get_node(scoreTextPath)
	visible = false
	
func updateUI():
	complaintCount.set_text(str(Global.complaints))
	scoreCount.set_text(str(Global.score))
