extends CanvasLayer

@onready var jump_counter: Label = $Gui/MarginContainer/VBoxContainer/JumpCounter
@onready var player: CharacterBody3D = $"../Player"

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	var jump_count: int = player.jump_count
	jump_counter.set_text(str(jump_count))
