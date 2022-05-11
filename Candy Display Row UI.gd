extends HBoxContainer

onready var displayQuantityText = get_node("Desired Quantity/Label")
onready var displayCandyPicture = get_node("Candy Picture")
onready var rowIndex = self.get_index()

func updateIntialValues(desiredCandiesList : Dictionary):
	var candyNamesList : Array = desiredCandiesList.keys()
	if(candyNamesList.size() > rowIndex):
		var thisRowsCandy : String = candyNamesList[rowIndex]
		displayQuantityText.set_text(str(desiredCandiesList[thisRowsCandy]))
		displayCandyPicture.set_texture(Global.candyPictureList[thisRowsCandy])
	else:
		self.visible = false

func updateStats(givenCandy : String, desiredCandiesList : Dictionary):
	var candyNamesList : Array = desiredCandiesList.keys()
	if(candyNamesList.size() > rowIndex):
		var thisRowsCandy : String = candyNamesList[rowIndex]
		
		if (thisRowsCandy == givenCandy):	
			print("updating ", thisRowsCandy)
			displayQuantityText.set_text(str(desiredCandiesList[thisRowsCandy]))
	else:
		self.visible = false

		
		

