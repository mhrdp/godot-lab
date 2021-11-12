extends Control

export (String, FILE, "*.json") var dialogue_data

onready var text_label: RichTextLabel = $RichTextLabel
onready var tween: Tween = $Tween
onready var next_icon: Sprite = $IconSprite

var dialogue: Array = []
var dialogue_index: int = 0
var dialogue_finished: bool = false

func _ready() -> void:
	#load_dialogue()
	#visible = false
	pass

func _process(_delta: float) -> void:
	next_icon.visible = dialogue_finished
	#if Input.is_action_just_pressed("ui_accept"):
	#	visible = true
	
func load_dialogue() -> void:
	visible = true
	dialogue = load_json()
	if dialogue_index < dialogue.size():
		turn_off_player()
		dialogue_finished = false
		text_label.bbcode_text = dialogue[dialogue_index]["dialogue"]
		text_label.percent_visible = 0
		
		tween.interpolate_property(
			text_label, "percent_visible", 0, 1, 1,
			Tween.TRANS_LINEAR, Tween.EASE_IN_OUT
		)
		tween.start()
	else:
		visible = false
		turn_on_player()
		
		# Start from the beginning, for some reason you have to put -1 as an index in this case
		dialogue_index = -1
	dialogue_index += 1

func load_json():
	var file = File.new()
	if file.file_exists(dialogue_data):
		file.open(dialogue_data, file.READ)
		return parse_json(file.get_as_text())
		
func turn_on_player() -> void:
	var player = get_node("/root/Node2D/Sprite")
	if player:
		player.set_active(true)

func turn_off_player() -> void:
	var player = get_node("/root/Node2D/Sprite")
	if player:
		player.set_active(false)

func _on_Tween_tween_completed(_object, _key):
	dialogue_finished = true
