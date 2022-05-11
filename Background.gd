extends Node2D

onready var cloudAnimPlayer = get_node("CloudSetAnim1")

func _ready():
	cloudAnimPlayer.play("Move Clouds")
