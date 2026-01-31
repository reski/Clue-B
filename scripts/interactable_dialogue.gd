extends Area2D

@export_file("*.dialogue") var dialogue_path: String = ""
@export var start_title: String = "start"

func _ready() -> void:
	add_to_group("interactable")

func interact() -> void:
	if dialogue_path.is_empty():
		push_warning("NPC sin dialogue_path asignado.")
		return

	var dialogue_res: Resource = load(dialogue_path)
	if dialogue_res == null:
		push_warning("No pude cargar: %s" % dialogue_path)
		return

	# Muestra el balloon/ventana de diálogo provista por el plugin. :contentReference[oaicite:7]{index=7}
	DialogueManager.show_dialogue_balloon(dialogue_res, start_title)
