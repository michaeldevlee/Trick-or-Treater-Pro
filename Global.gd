extends Node2D

var isCandyNearKid = false
var selectedKid : Node2D
var score : int = 0
var complaints : int = 0

var pickedCandy : String
var pickedCandyBagLocation : Vector2
var isHoldingCandy : bool
var currentCandyObject

signal updateLivesandScore
signal kidReadyToMoveOut (kid, mood)
signal updateAnimation (kidStatus)

var candyCornPicture = preload("res://UI/Candy Bags/Candies/Candy Corn Single.png")
var skullCandyPicture = preload("res://UI/Candy Bags/Candies/Skull Candy Single.png")
var heartPopPicture = preload("res://UI/Candy Bags/Candies/Heart Pop Single.png")
var chocoBarPicture = preload("res://UI/Candy Bags/Candies/ChocoBar.png")
var bonePixieDustPicture = preload("res://UI/Candy Bags/Candies/Bone Pixie Dust SIngle.png")
var webPiePicture = preload("res://UI/Candy Bags/Candies/Web Cookie Single.png")

enum kidMoveToLocationStatus {OCCUPIED , OPEN}
var kidMoveToLocations = {}
var openLocations : Array = []

var pumpkinKid = preload("res://Kids/PumpkinKid.tscn")
var witchKid = preload("res://Kids/WitchKid.tscn")
var skullKid = preload("res://Kids/SkullKid.tscn")
var ghostKid = preload("res://Kids/Ghost Kid.tscn")
var frankenKid = preload("res://Kids/Franken Kid.tscn")


var listOfKids =[pumpkinKid, witchKid, skullKid, ghostKid, frankenKid]

var candyList = [
	"Candy Corn",
	"Skull Candy",
	"Heart Pop",
	"ChocoBar",
	"Bone Pixie Dust",
	"Web Pie"]
	
var candyPictureList = {
	"Candy Corn" : candyCornPicture,
	"Skull Candy" : skullCandyPicture,
	"Heart Pop" : heartPopPicture,
	"ChocoBar" : chocoBarPicture,
	"Bone Pixie Dust" : bonePixieDustPicture,
	"Web Pie" : webPiePicture 
	}
	
var candyPointList = {
	"Candy Corn" : 50,
	"Skull Candy" : 200,
	"Heart Pop" : 150,
	"ChocoBar" : 250,
	"Bone Pixie Dust" : 200,
	"Web Pie" : 300}

