extends Sprite
export var outport : Dictionary
export var id:String = "q0" setget set_id, get_id
export var current:bool = false setget _setCurrent, _getCurrent
const TransLine:PackedScene = preload("res://ExecutionStage/TransLine.tscn")
	
func _ready()->void:
	pass

func _setCurrent(value:bool) -> void:
	$Sprite.visible = value

func _getCurrent() -> bool:
	return $Sprite.visible

func set_id(value:String)->void:
	id = value
	$Label.text = value

func get_id()->String:
	id = $Label.text
	return id

func add_outport(symbol:String, nextState:String) -> Node:
	if symbol in outport:
		remove_child(outport[symbol])
		outport[symbol].queue_free()
		outport.erase(symbol)
	outport[symbol] = TransLine.instance()
	outport[symbol].init(get_id(), symbol, nextState)
	get_parent().add_child(outport[symbol])
	return outport[symbol]
