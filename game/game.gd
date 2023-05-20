extends Node2D

const MULTIPLIER_TIME: float = 5.0
const BASE_CORRECT_VALUE: float = 5.0

enum OPERATORS {
	ADD,
	SUBTRACT,
	MULTIPLY,
	DIVIDE
}

onready var hud: CanvasLayer = $HUD
onready var dice: Node2D = $Dice
onready var tmr_multiplier: Timer = $TmrMultiplier


var submission: String 

var round_start_time: int

var exspected_answer: int

var operator: int = OPERATORS.ADD

var left_operand: int
var right_operand: int

var round_number: int
var player_score: float


func _ready() -> void:
	hud.update_score(player_score)
	self.round_number = 0
	randomize()
	start_new_round()

	#$Timer.connect("timeout", self, "_roll_dice")
	pass 

func _process(delta: float) -> void:
	hud.update_time(Time.get_ticks_msec() - round_start_time)

func start_new_round() -> void:
	self.tmr_multiplier.start(MULTIPLIER_TIME)
	self.round_number += 1
	self.round_start_time = Time.get_ticks_msec()
	_roll_dice()
	load_operands()
	# TODO: Get random operator
	self.exspected_answer = self.get_answer(self.left_operand, self.right_operand, self.operator)


func _unhandled_key_input(event: InputEventKey) -> void:
	if event.is_pressed() and not event.is_echo():
		var key = OS.get_scancode_string(event.scancode)
		## print(key)
		
		# This removes the "Kp" from string when using the number pad
		if key.left(2) == "Kp":
			key = key.substr(3, key.length())
		
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
	self.submission = ""
	self.hud.update_input(submission)

func _roll_dice() -> void:
	for d in $Dice.get_children():
		d.reroll()

func load_operands() -> void:
	self.left_operand = self.dice.get_child(0).get_value() + self.dice.get_child(1).get_value() 
	self.right_operand = self.dice.get_child(2).get_value() + self.dice.get_child(3).get_value() 


func submit_answer() -> void:
	if !self.submission.empty():
		print(str("Round: ", self.round_number,"  Elapsed time: ", (Time.get_ticks_msec() - round_start_time)))
		print(str("Input: ", int(submission), ".", " Exspected: ", self.exspected_answer))
		if self.compare_values(self.exspected_answer, int(self.submission)): 
			# Answer was right
			$SoundCorrect.play()
			
			var multi = $TmrMultiplier.time_left
			print(str("time left: ", $TmrMultiplier.time_left))
			
			#prevent multiplying score by 0
			if multi == 0:
				multi = 1
			self.player_score += (BASE_CORRECT_VALUE * multi)
			
			player_score = stepify(player_score, 0.01)
			
			hud.update_score(player_score)
			
			# get operator code
			# get new question
			self.start_new_round()
			
		else:
			# Answer was wrong
			$SoundWrong.play()
			
			
			
			self.start_new_round()
		
		
		
		self._clear_submission()


static func remove_last_input(input: String) -> String:
	var current_text = input   # grab the text
	current_text.erase(current_text.length() - 1, 1) # remove the last char
	return current_text
	

func get_answer(left_o: int, right_o: int, operator: int) -> int:
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


func compare_values(expected: int, entered: int) -> bool:
	return expected == entered
