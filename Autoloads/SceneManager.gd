extends Node

const ExecutionStage : PackedScene = preload("res://ExecutionStage/ExecutionStage.tscn")
const EditScene : PackedScene = preload("res://DFAEditorResources/Editor.tscn")
var payload : Dictionary


func stageDFA(_dfa:DFA):
	StateMetadata.dfa = _dfa
	get_tree().change_scene_to(ExecutionStage)


func editDFA(_dfa:DFA):
	payload["Editor"] = _dfa
	get_tree().change_scene_to(EditScene)
