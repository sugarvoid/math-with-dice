extends CanvasLayer


onready var lbl_input: Label = $LblInput
onready var lbl_score: Label = get_node("LblScore")

var lbl_input_length: int


func _ready() -> void:
	pass
	self.lbl_input.text = ''


func update_input(new_text: String) -> void:
	self.lbl_input.text = new_text
	
func update_round(new_text: String) -> void:
	$RoundInfo/LblRound.text = new_text
	
func update_time(milisec: int) -> void:
	$LblTime.text = str(milisec)
	
func update_time_string(milisec: String) -> void:
	$LblTime.text = (milisec)

func update_score(new_score: float) -> void:
	$LblScore.text = str(new_score)

func update_dice_vaule_labels(dice: Array) -> void:
	print("debug")
	$LeftDice.text = str(dice[0])
	$RightDice.text = str(dice[1])
