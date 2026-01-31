extends Node2D

@export var npc_name: String = "NPC"
@export var dialogue_resource: DialogueResource
@export var dialogue_start: String = "start"

func get_npc_name() -> String:
	return npc_name

func get_dialogue_resource() -> DialogueResource:
	return dialogue_resource

func get_dialogue_start() -> String:
	return dialogue_start
