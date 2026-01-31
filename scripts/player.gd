extends CharacterBody2D

@export var speed: float = 90.0

var nearby_npcs: Array[Node2D] = []
var dialogue_active := false
var active_balloon: Node = null

@onready var interact_detector: Area2D = $InteractDetector
@onready var dialogue_manager: Node = get_node_or_null("/root/DialogueManager")

func _ready() -> void:
	if dialogue_manager:
		if dialogue_manager.has_signal("dialogue_started"):
			dialogue_manager.dialogue_started.connect(_on_dialogue_started)
		if dialogue_manager.has_signal("dialogue_ended"):
			dialogue_manager.dialogue_ended.connect(_on_dialogue_ended)

	interact_detector.area_entered.connect(_on_area_entered)
	interact_detector.area_exited.connect(_on_area_exited)

func _physics_process(_delta: float) -> void:
	if dialogue_active:
		velocity = Vector2.ZERO
		move_and_slide()
		return

	var dir := Input.get_vector("move_left", "move_right", "move_up", "move_down")
	velocity = dir * speed
	move_and_slide()

func _unhandled_input(event: InputEvent) -> void:
	if dialogue_active:
		return

	var pressed_interact := event.is_action_pressed("ui_accept")
	if event is InputEventKey and event.pressed and not event.echo and event.keycode == KEY_E:
		pressed_interact = true

	if pressed_interact:
		_try_interact()

func _try_interact() -> void:
	if dialogue_manager == null:
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

	if best_npc != null and best_npc.has_method("get_dialogue_resource"):
		var dialogue_resource = best_npc.get_dialogue_resource()
		var dialogue_start := "start"
		if best_npc.has_method("get_dialogue_start"):
			dialogue_start = best_npc.get_dialogue_start()

		if dialogue_resource:
			dialogue_active = true
			active_balloon = dialogue_manager.show_dialogue_balloon(dialogue_resource, dialogue_start)
			if active_balloon:
				active_balloon.tree_exited.connect(_on_dialogue_balloon_exited)

func _on_area_entered(area: Area2D) -> void:
	var npc := area.get_parent() as Node2D
	if npc and npc.has_method("get_dialogue_resource"):
		if not nearby_npcs.has(npc):
			nearby_npcs.append(npc)

func _on_area_exited(area: Area2D) -> void:
	var npc := area.get_parent() as Node2D
	if npc and nearby_npcs.has(npc):
		nearby_npcs.erase(npc)

func _on_dialogue_started(_title := "") -> void:
	dialogue_active = true

func _on_dialogue_ended(_title := "") -> void:
	dialogue_active = false
	active_balloon = null

func _on_dialogue_balloon_exited() -> void:
	dialogue_active = false
	active_balloon = null
