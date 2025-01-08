class_name Interactable
extends Node2D

enum InteractionType { INTERACTION, ACTION, INTERACTION_AND_ACTION }

signal interacted(character: Character)
signal entered_range(character: Character)
signal left_range(character: Character)

static var _interactables_on_range = []

var character_on_range: Character:
	set(value):
		character_on_range = value
		
		if character_on_range != null:
			_interactables_on_range.append(self)
		else:
			_interactables_on_range.erase(self)
		
		_interactables_on_range.sort_custom(func (a: Interactable, b: Interactable):
			if a.interaction_priority >= b.interaction_priority:
				return true
			return false
		)

var can_interact := true

var is_outlined := false:
	set(value):
		if is_outlined == value:
			return
		
		is_outlined = value
		set_outline(is_outlined)

@export var interaction_area: Area2D
@export var interaction_priority := 0
@export var interaction_type := InteractionType.INTERACTION
@export var interaction_action := "ui_accept"

@export_subgroup("On Range Outline")
@export var has_outline := true
@export var outline_node: Node2D
@export var outline_color := Color.WHITE
@export var outline_width := 1

const OUTLINE_SHADER = preload("res://shaders/outline.gdshader")

func set_outline(value):
	if not value:
		outline_node.material = null
		return
	
	var shader_material := ShaderMaterial.new()
	shader_material.shader = OUTLINE_SHADER
	shader_material.set_shader_parameter("outline_color", outline_color)
	shader_material.set_shader_parameter("outline_width", outline_width)
	outline_node.material = shader_material

func _ready():
	setup_outline_node(self)
	set_interaction_area(self)

func setup_outline_node(from_node):
	if outline_node != null:
		return
	
	outline_node = NodeExtension.find_first_child(from_node,
		func(child): return child is AnimatedSprite2D)
	
	if outline_node == null:
		outline_node = NodeExtension.find_first_child(from_node,
			func(child): return child is Sprite2D)
	
	if outline_node == null:
		push_error("no sprite found to outline")

func set_interaction_area(from_node):
	if interaction_area == null:
		interaction_area = NodeExtension.find_first_child(from_node, func(child): return child is Area2D)
	
	if interaction_area != null:
		interaction_area.body_entered.connect(_on_area_2d_body_entered)
		interaction_area.body_exited.connect(_on_area_2d_body_exited)

func _process(_delta):
	if character_on_range == null:
		return
	
	if can_interact and Input.is_action_just_pressed(interaction_action):
		if _interactables_on_range.size() > 1 and _interactables_on_range[0] != self:
			return
		
		interacted.emit(character_on_range)

func _on_area_2d_body_entered(body):
	if body is not Character:
		return
	
	character_on_range = body
	entered_range.emit(body)
	
	if not can_interact:
		return
	
	if has_outline:
		is_outlined = true

func _on_area_2d_body_exited(body):
	if body is not Character:
		return
	
	character_on_range = null
	left_range.emit(body)
	
	if not can_interact:
		return
	
	if has_outline:
		is_outlined = false
