extends Line2D
var fromNode : Node2D = null
var fromStateId : String = ""
var toNode : Node2D = null 
var toStateId : String = ""
var symbol : String = "" setget __setSymbol, __getSymbol
export(float, 0, 10) var heightRatio 


func init(_fromStateId:String, _symbol:String, _toStateId:String)->void:
	fromStateId = _fromStateId
	toStateId = _toStateId
	__setSymbol(_symbol)
	fromNode = StateMetadata.getStateById(fromStateId)
	toNode = StateMetadata.getStateById(toStateId)
	assert(fromNode != null)
	assert(toNode != null)
	assert(__getSymbol() != "")
	autoAttach()

func autoAttach()->void:
	assert(fromNode != null)
	assert(toNode != null)
	assert(__getSymbol() != "")
	position = fromNode.position
	points[2] = toNode.position - position
	points[1] = points[2] / 2 + (points[2] / 2).rotated(PI / 2) * heightRatio
	$Label.set_position(points[1])

func __setSymbol(value:String)->void:
	symbol = value
	$Label.text = value

func __getSymbol()->String:
	symbol = $Label.text
	return $Label.text
