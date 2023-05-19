extends CanvasLayer


onready var lbl_input: Label = $LblInput

var lbl_input_length: int


func _ready() -> void:
	pass
	self.lbl_input.text = ''


func update_input(new_text: String) -> void:
	self.lbl_input.text = new_text
