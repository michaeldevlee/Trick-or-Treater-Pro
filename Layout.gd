extends VBoxContainer

var rows : Array

func _ready():
	rows = get_children()

func updateInitialValues(desiredCandiesList : Dictionary):
	for x in rows:
		var row : HBoxContainer = x
		row.visible = true
		row.updateIntialValues(desiredCandiesList)

func updateValues(givenCandy : String, desiredCandiesList : Dictionary):
	for x in rows:
		var row : HBoxContainer = x
		row.visible = true
		row.updateStats(givenCandy, desiredCandiesList)

