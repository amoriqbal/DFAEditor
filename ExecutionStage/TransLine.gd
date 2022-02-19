extends Line2D
var fromNode : Node2D = null
var fromStateId : String = ""
var toNode : Node2D = null 
var toStateId : String = ""
var symbol : String = "" setget __setSymbol, __getSymbol
var control_points = [0,0,0]
export(float, 0, 10) var heightRatio 
export(float) var minHeight

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
	control_points[0] = Vector2.ZERO
	control_points[2] = toNode.position - position
	control_points[1] = control_points[2] / 2 + (control_points[2] / 2).rotated(PI / 2) * heightRatio  
	control_points[1].y = max(control_points[1].y, minHeight) * sign(control_points[2].x - control_points[0].x)
	$Label.set_position(control_points[1])
	var curve = Curve2D.new()
	
	for pt in control_points:
		curve.add_point(pt)
	
	var smoothening_value = max(minHeight, abs(control_points[1].x - control_points[0].x)) * sign(control_points[2].x - control_points[0].x) * -1
	curve.set_point_out(1, Vector2(-smoothening_value / 2, 0))
	curve.set_point_in(1, Vector2(smoothening_value / 2, 0))
	points = curve.get_baked_points()

func __setSymbol(value:String)->void:
	symbol = value
	$Label.text = value

func __getSymbol()->String:
	symbol = $Label.text
	return $Label.text
