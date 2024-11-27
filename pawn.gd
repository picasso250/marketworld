extends Sprite2D

var progress_bar_node: NodePath = "ProgressBar"
var _progress: float = 0.0
var _target_duration: float = 0.0
var _elapsed_time: float = 0.0
var _is_progressing: bool = false

func _ready():
	if not has_node(progress_bar_node):
		push_error("ProgressBar node path is invalid.")
		return
	
	var progress_bar = get_node(progress_bar_node) as ColorRect
	if not progress_bar or not progress_bar.is_class("ColorRect"):
		push_error("Invalid progress bar node path or type.")
		return
	
	# Set progress bar size based on texture width.
	var texture_size = texture.get_size()
	progress_bar.size.x = texture_size.x
	progress_bar.position.x = -texture_size.x / 2

# Function to start growing the progress bar over a given duration.
func start_progress_bar_growth(duration: float) -> void:
	if duration <= 0.0:
		push_error("Duration must be greater than 0")
		return
	
	var progress_bar = get_node(progress_bar_node)
	if not progress_bar or not progress_bar.is_class("ColorRect"):
		push_error("Invalid progress bar node path or type.")
		return
	
	_progress = 0.0
	_target_duration = duration
	_elapsed_time = 0.0
	_is_progressing = true
	
	progress_bar.size.x = 0

# Function to stop progress bar growth manually.
func stop_progress_bar_growth() -> void:
	_is_progressing = false
	_progress = 0.0
	_elapsed_time = 0.0

func _process(delta: float) -> void:
	if not _is_progressing:
		return
	
	_elapsed_time += delta
	_progress = clamp(_elapsed_time / _target_duration, 0.0, 1.0)
	
	var progress_bar = get_node(progress_bar_node) as ColorRect
	var texture_size = texture.get_size()
	progress_bar.size.x = _progress * texture_size.x
	
	if _progress >= 1.0:
		_is_progressing = false

func _on_button_pressed():
	start_progress_bar_growth(3)
