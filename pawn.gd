extends Sprite2D

signal debug_button_pressed

var progress_bar_node: NodePath = "ProgressBar"
var _progress: float = 0.0
var _target_duration: float = 0.0
var _elapsed_time: float = 0.0
var _is_progressing: bool = false
var _current_target_position: Vector2 = Vector2.ZERO
var _task_type: String = ""
@export var move_speed: float = 100.0  # Speed at which the pawn moves towards the target.
var _task_target: Node = null  # New variable to store the task target.
var has_moving_target: bool = false  # Renamed variable to track if the pawn has a moving target.

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
		
		# Check if the target has been reached and start the progress bar growth.
		if has_reached_target() and _task_target != null:
			# Assuming that the task target has a method to get the task duration, 
			# for example `get_task_duration()` which should return the task's duration.
			var task_duration = _task_target.get("task_duration")  # Replace with the actual property or method to get the duration.
			if task_duration > 0.0:
				start_progress_bar_growth(task_duration)
				
		return
	
	_elapsed_time += delta
	_progress = clamp(_elapsed_time / _target_duration, 0.0, 1.0)
	
	var progress_bar = get_node(progress_bar_node) as ColorRect
	var texture_size = texture.get_size()
	progress_bar.size.x = _progress * texture_size.x
	
	if _progress >= 1.0:
		_is_progressing = false


# Updated function to set the current task with a target, type, and task_target.
func set_current_task(target: Node, task_type: String) -> void:
	_task_type = task_type
	_task_target = target  # Set the task target.
	set_target_position(target.get_center_position())
	
	# Print the task type.
	print("Task type: ", _task_type)

# 判断是否到达目标位置
func has_reached_target() -> bool:
	var tolerance: float = move_speed * get_process_delta_time()  # 使用 delta 时间计算容差
	return position.distance_to(_current_target_position) <= tolerance

# New method to move towards a target at the specified speed, using has_reached_target for the check.
func move_towards_target(delta: float) -> void:
	if has_moving_target and not has_reached_target():
		var direction = (_current_target_position - position).normalized()
		position += direction * move_speed * delta
	elif has_moving_target:
		position = _current_target_position  # Snap to the target once within tolerance.
		_clear_target()  # Clear the target once it’s reached.

# New method to set the current target position.
func set_target_position(target_position: Vector2) -> void:
	_current_target_position = target_position
	has_moving_target = true  # Set the flag to indicate there is a target.

# Function to clear the target when it's reached or when we want to reset it.
func _clear_target() -> void:
	has_moving_target = false  # Clear the target flag.
	_current_target_position = Vector2.ZERO  # Optionally reset position, or just leave it as it is.

# Debug button signal method.
func _on_button_pressed():
	emit_signal("debug_button_pressed")
