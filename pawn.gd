extends Sprite2D

signal debug_button_pressed

var progress_bar_node: NodePath = "ProgressBar"
var _progress: float = 0.0
var _target_duration: float = 0.0
var _elapsed_time: float = 0.0
var _is_progressing: bool = false
var _current_target_position: Vector2 = Vector2.ZERO
var _task_type: String = ""
var _task_speed: float = 100.0  # Adjust the speed as needed.
@export var move_speed: float = 100.0  # Speed at which the pawn moves towards the target.

func _ready():
	var progress_bar = get_node(progress_bar_node) as ColorRect
	# You can safely assume that the ProgressBar will be available.
	# Set progress bar size based on texture width.
	var texture_size = texture.get_size()
	progress_bar.size.x = texture_size.x
	progress_bar.position.x = -texture_size.x / 2

# Function to start growing the progress bar over a given duration.
func start_progress_bar_growth(duration: float) -> void:
	if duration <= 0.0:
		push_error("Duration must be greater than 0")
		return
	
	var progress_bar = get_node(progress_bar_node) as ColorRect
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
		# Move towards target if a target is set.
		move_towards_target(delta)
		return
	
	_elapsed_time += delta
	_progress = clamp(_elapsed_time / _target_duration, 0.0, 1.0)
	
	var progress_bar = get_node(progress_bar_node) as ColorRect
	var texture_size = texture.get_size()
	progress_bar.size.x = _progress * texture_size.x
	
	if _progress >= 1.0:
		_is_progressing = false

# Function to set the current task with a target and type, and move towards the target.
func set_current_task(target: Node, task_type: String) -> void:
	_task_type = task_type
	set_target_position(target.get_center_position())
	
	# Print the task type.
	print("Task type: ", _task_type)

# 判断是否到达目标位置
func has_reached_target() -> bool:
	var tolerance: float = move_speed * get_process_delta_time()  # 使用 delta 时间计算容差
	return position.distance_to(_current_target_position) <= tolerance

# New method to move towards a target at the specified speed, using speed * delta as tolerance.
func move_towards_target(delta: float) -> void:
	var tolerance: float = move_speed * delta  # Calculate tolerance based on speed and delta time.
	
	if position.distance_to(_current_target_position) > tolerance:
		var direction = (_current_target_position - position).normalized()
		position += direction * move_speed * delta
	else:
		position = _current_target_position  # Snap to the target once within tolerance.

# Debug button signal method.
func _on_button_pressed():
	emit_signal("debug_button_pressed")

# New method to set the current target position.
func set_target_position(target_position: Vector2) -> void:
	_current_target_position = target_position
