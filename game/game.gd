extends Node2D


enum OPERATORS {
	ADD,
	SUBTRACT,
	MULTIPLY,
	DIVIDE
}

onready var hud: CanvasLayer = $HUD

var submission: String 

var exspected_answer: int

var left_operand: int
var right_operand: int


func _ready() -> void:
	push_error("test error")
	
	$Timer.connect("timeout", self, "_roll_dice")
	pass 


func _unhandled_key_input(event: InputEventKey) -> void:
	if event.is_pressed() and not event.is_echo():
		var key = OS.get_scancode_string(event.scancode)
		print(key)
		if key == "BackSpace":
			submission = self.remove_last_input(submission)
			
		if key.is_valid_integer():
			if submission.length() == 3:
				return
			else:
				self.submission += key
		self.hud.update_input(submission)
		
		if key == "Enter":
			self.submit_answer()

func _clear_submission() -> void:
	self.submission.empty()

func _roll_dice() -> void:
	for d in $Dice.get_children():
		d.reroll()

func submit_answer() -> void:
	print(str("Submitting: ", int(submission)))
	if self.compare_values(self.exspected_answer, int(self.submission)): 
		print ("Answer was right!")
		# get new question
	else:
		print("Wrong!!!!")
	
	self._clear_submission()


static func remove_last_input(input: String) -> String:
	print("here")
	var current_text = input   # grab the text
	current_text.erase(current_text.length() - 1, 1) # remove the last char
	return current_text
	

static func get_answer(left_o: int, right_o: int, operator: int) -> int:
	match(operator):
		OPERATORS.ADD:
			return left_o + right_o
		OPERATORS.SUBTRACT:
			return left_o - right_o
		OPERATORS.MULTIPLY:
			return left_o * right_o
		OPERATORS.DIVIDE:
			return left_o / right_o
		_:
			assert( false, "ERROR: You must give operator a value.")
			return 0


func get_die_value(die_number: int) -> int:
	return $Dice.get_child(die_number - 1).get_pips()


static func compare_values(expected: int, entered: int) -> bool:
	return expected == entered
