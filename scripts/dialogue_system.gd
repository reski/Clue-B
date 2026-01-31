extends Node

@export var dialogue_ui_path: NodePath

var _active: bool = false
var _lines: Array[String] = []
var _index: int = 0
var _speaker: String = ""

@onready var dialogue_ui: Control = get_node(dialogue_ui_path)

func _ready() -> void:
	add_to_group("dialogue_system")
	if dialogue_ui:
		dialogue_ui.hide()

func is_active() -> bool:
	return _active

func start_dialogue(npc: Node) -> void:
	if _active:
		return
	if npc == null or not npc.has_method("get_dialogue_lines"):
		return

	_speaker = npc.get_npc_name() if npc.has_method("get_npc_name") else "NPC"
	_lines = npc.get_dialogue_lines()
	_index = 0

	if _lines.is_empty():
		_lines = ["..."]

	_active = true
	dialogue_ui.open(_speaker, _lines[_index])

func _unhandled_input(event: InputEvent) -> void:
	if not _active:
		return

	var pressed := event.is_action_pressed("ui_accept")
	if event is InputEventKey and event.pressed and not event.echo and event.keycode == KEY_E:
		pressed = true

	if pressed:
		_advance()

func _advance() -> void:
	_index += 1
	if _index >= _lines.size():
		end_dialogue()
		return
	dialogue_ui.set_line(_lines[_index])

func end_dialogue() -> void:
	_active = false
	dialogue_ui.close()
