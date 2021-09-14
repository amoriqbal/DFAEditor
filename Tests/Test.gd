extends Node
const ExecutionStage : PackedScene = preload("res://ExecutionStage/ExecutionStage.tscn")

onready var dummydfa : DFA = DFA.new(
	["p1", "p2"],
	["a"],
	{
		"p1":{"a" : "p1"},
		"p2":{"a" : "p1"}
	},
	"p1",
	["p2"]
)

func _ready():
	StateMetadata.dfa = dummydfa
	get_tree().change_scene_to(ExecutionStage)
