extends Node2D
class_name Kid

onready var animPlayer : AnimationPlayer = get_node("Character Anim") as AnimationPlayer
export var characterBodyPath : NodePath
export var characterHeadPath : NodePath
export var characterLeftFootPath : NodePath
export var characterRightFootPath : NodePath
export var characterLeftArmPath : NodePath
export var characterRightArmPath : NodePath

var characterBody : Sprite
var characterHead : Sprite
var characterLeftFoot : Sprite
var characterRightFoot : Sprite
var characterLeftArm : Sprite
var characterRightArm : Sprite

func _ready():
	setAllNodePaths()
	playWalkingAnimation()
	
func updateAnimation(animationName : String , direction : int):
	animPlayer.play(animationName)
	scale.x = direction
	print(animationName)

func playWalkingAnimation():
	animPlayer.play("WALKING")

func standingAnimation():
	animPlayer.play("IDLE")

func setAllNodePaths():
	characterBody = get_node(characterBodyPath)
	characterHead = get_node(characterHeadPath)
	characterLeftFoot = get_node(characterLeftFootPath)
	characterRightFoot = get_node(characterRightFootPath)
	characterLeftArm = get_node(characterLeftArmPath)
	characterRightArm = get_node(characterRightArmPath)

