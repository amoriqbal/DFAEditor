extends Node
onready var dfa : DFA = DFA.new([],[],{},"",[])
export var nodeById : Dictionary = {}

func registerState(stateId:String,stateNode:Node)->void:
	nodeById[stateId] = stateNode

func deleteState(stateId:String)->void:
	nodeById[stateId].queue_free()
# warning-ignore:return_value_discarded
	nodeById.erase(stateId)

func getStateById(stateId:String)->Node:
	if stateId in nodeById:
		return nodeById[stateId]
	return null
