class_name DFA
var stateSet : Array
var symbolSet : Array
var transFunc : Dictionary
var startState : String
var endStates : Array

func _init(_stateSet : Array,_symbolSet : Array,_transFunc : Dictionary,_startState : String,_endStates : Array):
	stateSet = _stateSet
	symbolSet = _symbolSet
	transFunc = _transFunc
	startState = _startState
	endStates = _endStates

func _to_string():
	return "States = %s\nSymbols = %s\nTransition Function = %s\nStart State = %s\nFinal States = %s" % [str(stateSet), str(symbolSet), str(transFunc), str(startState), str(endStates)]
