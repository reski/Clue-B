extends CharacterBody2D

@export var speed: float = 90.0
@export var dialogue_system_path: NodePath

var nearby_npcs: Array[Node2D] = []
@onready var interact_detector: Area2D = $InteractDetector
@onready var dialogue_system: Node = null

func _ready() -> void:
	# Referencia robusta al DialogueSystem (sin depender del grupo / orden de ready)
	if dialogue_system_path != NodePath():
		dialogue_system = get_node_or_null(dialogue_system_path)
	if dialogue_system == null:
		dialogue_system = get_tree().get_first_node_in_group("dialogue_system")

	interact_detector.area_entered.connect(_on_area_entered)
	interact_detector.area_exited.connect(_on_area_exited)

func _physics_process(_delta: float) -> void:
	if dialogue_system and dialogue_system.is_active():
		velocity = Vector2.ZERO
		move_and_slide()
		return

	var dir := Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")
	velocity = dir * speed
	move_and_slide()

func _unhandled_input(event: InputEvent) -> void:
	if dialogue_system and dialogue_system.is_active():
		return

	var pressed_interact := event.is_action_pressed("ui_accept")
	if event is InputEventKey and event.pressed and not event.echo and event.keycode == KEY_E:
		pressed_interact = true

	if pressed_interact:
		_try_interact()

func _try_interact() -> void:
	if dialogue_system == null:
		return

	var best_npc: Node2D = null
	var best_dist := INF

	for npc in nearby_npcs:
		if npc == null:
			continue
		var d := global_position.distance_squared_to(npc.global_position)
		if d < best_dist:
			best_dist = d
			best_npc = npc

	if best_npc != null:
		dialogue_system.start_dialogue(best_npc)

func _on_area_entered(area: Area2D) -> void:
	var npc := area.get_parent() as Node2D
	if npc and npc.has_method("get_dialogue_lines"):
		if not nearby_npcs.has(npc):
			nearby_npcs.append(npc)

func _on_area_exited(area: Area2D) -> void:
	var npc := area.get_parent() as Node2D
	if npc and nearby_npcs.has(npc):
		nearby_npcs.erase(npc)
