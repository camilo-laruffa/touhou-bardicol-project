extends Control

func _process(delta):
	var VALID_INSTANCE = is_instance_valid(get_parent().get_node("Boss"))
	if VALID_INSTANCE:
		$HBoxContainer/HP.text = str(get_parent().get_node("Boss").hp)
		$HBoxContainer3/SPELLCARD.text = str(get_parent().get_node("Boss").lives - 1)
	else : get_parent().queue_free()
