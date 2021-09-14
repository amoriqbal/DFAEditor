extends HBoxContainer
signal target_changed(symbol, target)

func init(symbol:String, targetId:String = $TargetState.text):
	$Symbol.text = symbol
	$TargetState.text = targetId
	_on_TargetState_text_changed()

func info() -> Array:
	return [$Symbol.text, $TargetState.text]

func _on_TargetState_text_changed():
	emit_signal("target_changed", $Symbol.text, $TargetState.text)
