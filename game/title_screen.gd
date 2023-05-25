extends Control


onready var btn_start: Button = $BtnStart
export var btngp_diff: ButtonGroup

onready var btn_adding: Button = $BtnAdding
onready var btn_subtraction: Button = $BtnSubtraction
onready var btn_multiplication: Button = $BtnMultiplication


func _ready() -> void:
	self.btn_start.connect("pressed", self, "_start_game")
	$Difficulty/Btn10.pressed = true

func _process(delta: float) -> void:
	btn_start.disabled = _is_math_mode_slected()

func _set_difficulty() -> void: 
	var selected: Button = self.btngp_diff.get_pressed_button()
	match selected.name:
		"Btn10":
			print("selected 10")
		"Btn20":
			print("selcted 20")
		"BtnEndless":
			print("selected endless")

func _is_math_mode_slected() -> bool:
	return !btn_adding.pressed and !btn_subtraction.pressed and !btn_multiplication.pressed

func _set_math_mode() -> void:
	if btn_adding.pressed():
		Global.math_mode += Global.MATHMODE.ADD
	if btn_subtraction.pressed():
		Global.math_mode += Global.MATHMODE.SUBTRACT
	if btn_multiplication.pressed():
		Global.math_mode += Global.MATHMODE.MULTIPLY


func _start_game() -> void:
	_set_difficulty()
	Global.math_mode = [Global.MATHMODE.ADD]
	get_tree().change_scene("res://game/game.tscn")
