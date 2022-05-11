extends Node2D

onready var musicPlayer = get_node("MusicPlayer")
onready var SFXPlayer = get_node("SFXPlayer")
onready var ambiencePlayer = get_node("AmbiencePlayer")

var levelMusic = preload("res://Audio/Trick or Treater Pro Music.ogg")
var levelAmbience = preload("res://Audio/SFX/Children Ambience.ogg")
var evilLaugh = preload("res://Audio/SFX/Evil Laugh SFX.ogg")
var candyPickUpSFX = preload("res://Audio/SFX/Pick Up Candy SFX.ogg")
var winSFX = preload("res://Audio/SFX/Win SFX.ogg")
var happyKidSFX = preload("res://Audio/SFX/Kid is Happy SFX.ogg")
var madKidSFX = preload("res://Audio/SFX/Kid is Mad SFX.ogg")
var rightCandySFX = preload("res://Audio/SFX/Right Candy SFX.ogg")
var wrongCandySFX = preload("res://Audio/SFX/Wrong Candy SFX.ogg")

func playMusic(stream):
	musicPlayer.set_stream(stream)
	musicPlayer.play()

func playSFX(stream):
	SFXPlayer.set_stream(stream)
	SFXPlayer.play()

func playAmbience(stream):
	ambiencePlayer.set_stream(stream)
	ambiencePlayer.play()
