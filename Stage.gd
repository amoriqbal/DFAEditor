extends Polygon2D

const StateCircleScene : PackedScene = preload("res://StateCircle.tscn")
const TransLineScene : PackedScene = preload("res://TransLine.tscn")
export(int,0,1000) var timePerStage = 0 setget _setTPS, _getTPS

var dfa : DFA = null
onready var dummydfa : DFA = DFA.new(
	["p1", "p2"],
	["a"],
	{
		"p1":{"a" : "p2"},
		"p2":{"a" : "p1"}
	},
	"p1",
	["p2"]
)

enum DFAResult{
	ACCEPTED,
	REJECTED,
	CONTINUE
}

var execState : Node = null
var strIndex : int = 0
var inputText : String = "" setget setIT, getIT

func setIT(value : String) -> void:
	$"../UI/VBox/HBox/TextEdit".text = value

func getIT()->String:
	return $"../UI/VBox/HBox/TextEdit".text

func _ready()->void:
	instanceDfa(StateMetadata.dfa)

func instanceDfa(_dfa:DFA) -> void:
	dfa = _dfa
	var diffPos : Vector2 = ($RgihtLimit.position - $LeftLimit.position) / len(dfa.stateSet)
	var currentPos : Vector2 = $LeftLimit.position + (diffPos / 2)
	for stateName in dfa.stateSet:
		var stateCircle:Node2D = StateCircleScene.instance()
		stateCircle.id = stateName
		add_child(stateCircle)
		stateCircle.position = currentPos
		currentPos += diffPos
		StateMetadata.registerState(stateName,stateCircle)
	for sta in dfa.transFunc:
		for sym in dfa.transFunc[sta]:
			var stb : String = dfa.transFunc[sta][sym]
			StateMetadata.getStateById(sta).add_outport(sym,stb)

func resetStage() -> void:
	execState = StateMetadata.getStateById(dfa.startState)
	strIndex = 0
	assert(execState != null)
	execState.current = true

func nextStage() -> int:
	if strIndex >= len(getIT()):
		if execState.id in dfa.endStates:
			return DFAResult.ACCEPTED
		else:
			return DFAResult.REJECTED
	
	if getIT()[strIndex] in dfa.transFunc[execState.id]:
		execState.current = false
		var nextStateName = dfa.transFunc[execState.id][getIT()[strIndex]]
		execState = StateMetadata.getStateById(nextStateName)
		execState.current = true
		strIndex += 1
		return DFAResult.CONTINUE
	else:
		return DFAResult.REJECTED

func _setTPS(value:int) -> void:
	$Timer.wait_time = value

func _getTPS() -> int:
	return $Timer.wait_time


func _on_Timer_timeout() -> void:
	var result : int = nextStage()
	if result == DFAResult.CONTINUE:
		$Timer.start()
		return
	if result == DFAResult.ACCEPTED:
		$ResultNotifDialogue.dialog_text = "ACCEPTED"
	else :
		$ResultNotifDialogue.dialog_text = "REJECTED"
	$ResultNotifDialogue.popup()

func _on_StartButton_pressed() -> void:
	resetStage()
	$"../UI/VBox/HBox/StartButton".visible = false
	$"../UI/VBox/HBox/NextButton".visible = true

func _on_NextButton_pressed() -> void:
	var result : int = nextStage()
	if result == DFAResult.CONTINUE:
		return
	if result == DFAResult.ACCEPTED:
		$ResultNotifDialogue.dialog_text = "ACCEPTED"
	else :
		$ResultNotifDialogue.dialog_text = "REJECTED"
	$ResultNotifDialogue.popup()


func _on_ResultNotifDialogue_confirmed():
	$"../UI/VBox/HBox/NextButton".visible = false
	$"../UI/VBox/HBox/StartButton".visible = true
