extends CanvasLayer

export (String, FILE, "*.json") var dialogue_file

onready var containerbox: NinePatchRect = $NinePatchRect
onready var namebox: RichTextLabel = $NinePatchRect/Name
onready var textbox: RichTextLabel = $NinePatchRect/Text
onready var timer: Timer = $Timer

var current_dialogue_id: int = 0
var dialogues: Array = []
var is_dialogue_actice: bool = false

# Called when the node enters the scene tree for the first time.
func _ready():
	containerbox.visible = false
	#play()

func _input(event: InputEvent):
	if not is_dialogue_actice:
		return
	
	if Input.is_action_pressed("ENTER") and dialogues.size() != 0:
		next_line()

func play():
	if is_dialogue_actice:
		return
	
	dialogues = load_dialogue()
	
	containerbox.visible = true
	is_dialogue_actice = true
	
	current_dialogue_id -= 0
	next_line()
	print(current_dialogue_id)

func next_line():
	current_dialogue_id += 1
	
	if current_dialogue_id >= dialogues.size():
		timer.start()
		containerbox.visible = false
		return
		
	namebox.text = dialogues[current_dialogue_id]["name"]
	textbox.text = dialogues[current_dialogue_id]["dialogue"]
	print(textbox.text)
	
func load_dialogue():
	var file = File.new()
	if file.file_exists(dialogue_file):
		file.open(dialogue_file, file.READ)
		return parse_json(file.get_as_text())

func _on_Timer_timeout():
	is_dialogue_actice = false
	current_dialogue_id = 0
