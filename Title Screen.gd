extends Node2D

onready var playButtonText = get_node("Play Button/Play Button Text")
onready var exitButtonText = get_node("Exit Button/Play Button Text2")

func _on_Play_Button_mouse_entered():
	playButtonText.self_modulate = Color("ad41ff")

func _on_Play_Button_mouse_exited():
	playButtonText.self_modulate = Color("ffffff")

func _on_Exit_Button_mouse_entered():
	exitButtonText.self_modulate = Color("ad41ff")

func _on_Exit_Button_mouse_exited():
	exitButtonText.self_modulate = Color("ffffff")
