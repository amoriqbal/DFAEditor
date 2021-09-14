extends HBoxContainer
signal transition_changed(id, symbol, target)
signal final_toggled(id, final)

const TransitionUI : PackedScene = preload("res://DFAEditorResources/TransitionUI.tscn")
func setId(value:String):
	$StateName.text = value

func getId()->String:
	return $StateName.text

func addTransition(symbol : String, targetId: String, final:bool = false) -> void:
	var transition = TransitionUI.instance()
	transition.connect("target_changed",self,"onTargetChanged")
	transition.init(symbol, targetId)
	$Transitions.add_child(transition)

func onTargetChanged(symbol:String, target:String):
	emit_signal("transition_changed", getId(), symbol, target)

func _on_IsFinal_toggled(button_pressed):
	emit_signal("final_toggled", getId(), button_pressed)
