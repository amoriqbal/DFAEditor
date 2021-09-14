extends HBoxContainer
signal transition_changed(id, symbol, target)
signal final_toggled(id, final)
signal starting_selected(id)

const TransitionUI : PackedScene = preload("res://DFAEditorResources/TransitionUI.tscn")
func setId(value:String):
	$StateName.text = value

func getId()->String:
	return $StateName.text

func addTransition(symbol : String, targetId: String) -> void:
	var transition = TransitionUI.instance()
	transition.connect("target_changed",self,"onTargetChanged")
	transition.init(symbol, targetId)
	$Transitions.add_child(transition)

func onTargetChanged(symbol:String, target:String) -> void:
	emit_signal("transition_changed", getId(), symbol, target)

func _on_IsFinal_toggled(button_pressed:bool) -> void:
	emit_signal("final_toggled", getId(), button_pressed)

func toggleIsFinal(value:bool) -> void:
	$IsFinal.pressed = value
	_on_IsFinal_toggled(value)

func toggleIsStarting(value:bool) -> void:
	$IsStarting.pressed = value
	_on_IsStarting_toggled(value)

func _on_IsStarting_toggled(button_pressed):
	if button_pressed:
		emit_signal("starting_selected",getId())
