class_name InteractableComponent
extends Interactable

func _ready():
	var parent = get_parent()
	setup_outline_node(parent)
	set_interaction_area(parent)
