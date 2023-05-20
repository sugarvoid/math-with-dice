extends Control


onready var btn_start: Button = $BtnStart


func _ready() -> void:
	self.btn_start.connect("pressed", self, "_start_game")


func _start_game() -> void:
	Global.gamemode = [Global.GAMEMODE.ADD]
	get_tree().change_scene("res://game/game.tscn")
