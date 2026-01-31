extends Control

@onready var name_label: Label = $Panel/Margin/Layout/NameLabel
@onready var text_label: RichTextLabel = $Panel/Margin/Layout/Text
@onready var next_hint: Label = $Panel/Margin/Layout/NextHint

func open(speaker_name: String, line: String) -> void:
	visible = true
	name_label.text = speaker_name
	set_line(line)

func set_line(line: String) -> void:
	text_label.clear()
	text_label.append_text(line)
	next_hint.text = "Enter / E para continuar"

func close() -> void:
	visible = false
