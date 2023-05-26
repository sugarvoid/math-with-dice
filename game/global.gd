extends Node


# Declare member variables here. Examples:
# var a: int = 2
# var b: String = "text"
enum MATHMODE {
	ADD,
	SUBTRACT,
	MULTIPLY,
	DIVIDE
}

enum GAMEMODE {
	TEN,
	TWENTY,
	ENDLESS
}


var math_mode: int
var game_mode: int

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta: float) -> void:
#	pass
