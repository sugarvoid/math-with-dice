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

onready var tmr_multiplier: Timer = $TmrMultiplier
onready var tmr_round_time: Timer = $TmrRoundTime


var elapsed = 0

var submission: String 

var round_start_time: int

var exspected_answer: int

var operator: int = OPERATORS.ADD

var left_operand: int
var right_operand: int

var round_number: int
var player_score: float

var round_string: String #= "{0} of {1}".format([self.round_number, str(10)]) 


func _ready() -> void:
	set_up_operator_sprite()
	self.tmr_round_time.connect("timeout", self, "tic")
	hud.update_score(player_score)
	self.round_number = 1
	randomize()
	start_new_round()
	

	#$Timer.connect("timeout", self, "_roll_dice")
	pass 

func _process(delta: float) -> void:
	#hud.update_time(Time.get_ticks_msec() - round_start_time)
	tic()
	

func tic() -> void:
	elapsed += 0.1
	stepify(elapsed,0.01)
	hud.update_time_string("%0.1f" % elapsed)

func set_up_operator_sprite() -> void:
	match Global.math_mode:
		Global.MATHMODE.ADD:
			$Operator.frame = 2
			$HUD/LblOperator.text = "+"
		Global.MATHMODE.SUBTRACT:
			$Operator.frame = 1
			$HUD/LblOperator.text = "-"
		Global.MATHMODE.MULTIPLY:
			$Operator.frame = 0
			$HUD/LblOperator.text = "*"

func start_new_round() -> void:
	self.round_string = "{0} of {1}".format([self.round_number, str(Global.num_of_rounds)]) 
	self.hud.update_round(round_string)
	self.operator = Global.math_mode
	self.elapsed = 0
	self.tmr_round_time.start()
	self.tmr_multiplier.start(MULTIPLIER_TIME)
	
	self.round_start_time = Time.get_ticks_msec()
	
	if Global.math_mode == Global.MATHMODE.SUBTRACT:
		while right_operand >= left_operand:
			print("right was larger than left")
			_roll_left_dice()
			_roll_right_dice()
	else:
		_roll_right_dice()
		_roll_left_dice()
	# TODO: Get random operator
	self.exspected_answer = self.get_answer(self.left_operand, self.right_operand, self.operator)
	hud.update_dice_vaule_labels([left_operand, right_operand])
	left_operand = 0
	right_operand = 0


func _unhandled_key_input(event: InputEventKey) -> void:
	if event.is_pressed() and not event.is_echo():
		var key = OS.get_scancode_string(event.scancode)
		## print(key)
		
		# This removes the "Kp" from string when using the number pad
		if key.left(2) == "Kp":
			key = key.substr(3, key.length())
		
		if key == "BackSpace":
			submission = self.remove_last_input(submission)
		
		if key == "Escape":
			get_tree().change_scene("res://game/title_screen.tscn")
			
		if key.is_valid_integer():
			if submission.length() == 4:
				return
			else:
				self.submission += key
		self.hud.update_input(submission)
		
		if key == "Enter":
			self.submit_answer()

func increase_round_num() -> void:
	self.round_number += 1
	

func _clear_submission() -> void:
	self.submission = ""
	self.hud.update_input(submission)

func _roll_left_dice() -> void:
	print("left dice roll")
	for d in $DiceLeft.get_children():
		d.reroll()
	self.left_operand = $DiceLeft.get_child(0).get_value() + $DiceLeft.get_child(1).get_value() 

func _roll_right_dice() -> void:
	for d in $DiceRight.get_children():
		d.reroll()
	self.right_operand = $DiceRight.get_child(0).get_value() + $DiceRight.get_child(1).get_value() 

func load_operands() -> void:
	self.left_operand = $DiceLeft.get_child(0).get_value() + $DiceLeft.get_child(1).get_value() 
	self.right_operand = $DiceRight.get_child(0).get_value() + $DiceRight.get_child(1).get_value() 
	


func submit_answer() -> void:
	if !self.submission.empty():
		#print(str(stepify(elapsed,0.01)))
		print(str("Round: ", self.round_number,"  Elapsed time: ", stepify(elapsed,0.01)))
		print(str("Input: ", int(submission), ".", " Exspected: ", self.exspected_answer))
		if self.compare_values(self.exspected_answer, int(self.submission)): 
			# Answer was right
			$SoundCorrect.play()
			
			
			var multi = $TmrMultiplier.time_left
			print(str("time left: ", $TmrMultiplier.time_left))
			print(str(stepify(elapsed,0.01)))
			
			#prevent multiplying score by 0
			if multi == 0:
				multi = 1
			self.player_score += (BASE_CORRECT_VALUE * multi)
			
			player_score = stepify(player_score, 0.01)
			
			hud.update_score(player_score)
			
			
			
			# get operator code
			# get new question

			
		else:
			# Answer was wrong
			$SoundWrong.play()
			
			
			
		
		if self.round_number == Global.num_of_rounds:
			# end the game
			# go to reseult screen 
			# stop timers 
			pass
		else:
			self.increase_round_num()
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
