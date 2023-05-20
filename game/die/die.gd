class_name Die
extends Node2D


onready var sprite: Sprite = $Sprite

var _pips: int


func _ready() -> void:
	pass 

func update_sprite() -> void:
	self.sprite.frame = self._pips

func get_value() -> int:
	
	return self._pips + 1
	print_debug(_pips)
	

func reroll() -> void:
	randomize()
	self._pips = randi() % 5
	self.update_sprite()
