extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_pawn_debug_button_pressed():
	$Pawn.set_current_task($Farmland, "harvest")
	#$Pawn.set_target_position( Vector2(800,800))
