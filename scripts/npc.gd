extends Node2D

@export var npc_name: String = "NPC"
@export var dialogue_lines: Array[String] = ["Hola!", "¿Cómo andás?"]

func get_npc_name() -> String:
	return npc_name

func get_dialogue_lines() -> Array[String]:
	return dialogue_lines
