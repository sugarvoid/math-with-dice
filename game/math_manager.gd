class_name MathManager
extends Node


# Declare member variables here. Examples:
# var a: int = 2
# var b: String = "text"


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


"""
Problem Factory

Returns Array [
	LEFT,
	RIGHT,
	ANSWER
]

"""

func get_addition_problem() -> MathProblem:
	var a = []
	return a
	
func get_subtraction_problem() -> MathProblem:
	var a = []
	return a
	
func get_multiplication_problem() -> MathProblem:
	var a = []
	return a
# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta: float) -> void:
#	pass
