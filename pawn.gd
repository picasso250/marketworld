extends Sprite2D

signal debug_button_pressed
signal debug_button_pressed2

## 速度
@export var move_speed: float = 100.0  # Speed at which the pawn moves towards the target.

## 饱食度
@export var satiation: float: # 饱食度
	get:
		return _satiation
	set(value):
		_satiation = min(value, satiation_cap)  # Ensure satiation doesn't exceed the cap.
## 最大饱食度
@export var satiation_cap: float = 100.0  # The maximum satiation value.
## 饥饿速率
@export var hunger_rate: float = 5.0  # Speed at which satiation decreases over time.

var _satiation: float = 100.0  # 饱食度

var _current_target_position: Vector2 = Vector2.ZERO
var _task_type: String = ""
var _task_target: Node = null  # New variable to store the task target.
var _has_moving_target: bool = false  # Renamed variable to track if the pawn has a moving target.
var _is_progress_bar_active: bool = false  # New variable to track if the progress bar is active.
var _task_completed: bool = false  # New variable to track if the task is completed.

func _process(delta: float) -> void:
	
	# Move towards target if a target is set.
	move_towards_target(delta)
	
	# Reduce satiation over time.
	reduce_satiation(delta)
	
	# Check if the target has been reached and start the progress bar growth.
	if has_reached_target() and _task_target != null and not _is_progress_bar_active and not _task_completed:
		var task_duration = _task_target.get("task_durations").get(_task_type)
		if task_duration > 0.0:
			start_progress_bar(task_duration)

# Method to reduce satiation over time.
func reduce_satiation(delta: float) -> void:
	_satiation -= hunger_rate * delta
	if _satiation < 0:
		_satiation = 0
	$Label.text = "饱食度："+str(round(_satiation))

# 启动进度条增长的方法
func start_progress_bar(task_duration: float) -> void:
	if _is_progress_bar_active:
		return  # If progress bar is already active, do nothing.
	
	_is_progress_bar_active = true  # Set the flag to indicate the progress bar is active.
	var progress_bar = $ProgressBar as ProgressBar  # 假设进度条节点是 ProgressBar 类型，并作为本脚本的子节点。

	progress_bar.value = 0  # 初始化为 0
	progress_bar.visible = true  # 确保进度条可见
	
	$StatusText.update_status("收获中……")

	# 使用 Tween 逐渐增长进度条
	var tween = get_tree().create_tween()
	tween.set_process_mode(Tween.TWEEN_PROCESS_PHYSICS)
	tween.tween_property(progress_bar, "value", 100, task_duration)
	tween.tween_callback(after_proc)

func after_proc():
	print("收获完成")
	_is_progress_bar_active = false  # Reset the flag when the task is complete.
	_task_completed = true  # Set the task completed flag.
	$ProgressBar.visible = false
	
	$StatusText.show_status_with_fade(_task_type+" 完成")
	
	_task_target.do_task(_task_type, self)

# Updated function to set the current task with a target, type, and task_target.
func set_current_task(target: Node, task_type: String) -> void:
	_task_type = task_type
	_task_target = target  # Set the task target.
	_task_completed = false  # Reset the task completed flag.
	set_target_position(target.get_center_position())
	
	# Print the task type.
	print("Task type: ", _task_type)

# 判断是否到达目标位置
func has_reached_target() -> bool:
	var tolerance: float = move_speed * get_process_delta_time()  # 使用 delta 时间计算容差
	return position.distance_to(_current_target_position) <= tolerance

# New method to set the current target position.
func set_target_position(target_position: Vector2) -> void:
	_current_target_position = target_position
	_has_moving_target = true  # Set the flag to indicate there is a target.

func move_towards_target(delta: float) -> void:
	if _has_moving_target and not has_reached_target():
		var direction = (_current_target_position - position).normalized()
		position += direction * move_speed * delta
		
		# Prevent small jitter by checking the final position
		if has_reached_target():
			position = _current_target_position  # Snap to the target once within tolerance.
			_clear_target()  # Clear the target once it’s reached.
	elif _has_moving_target:
		position = _current_target_position  # Snap to the target once within tolerance.
		_clear_target()  # Clear the target once it’s reached.

func _clear_target() -> void:
	_has_moving_target = false  # Clear the target flag.
	# Do not reset the position to Vector2.ZERO to avoid unnecessary movements.

# Debug button signal method.
func _on_button_pressed():
	emit_signal("debug_button_pressed")

func find_items_by_name(item_name: String) -> Array:
	var parent = get_parent()
	var children = parent.get_children()
	var results = []

	for child in children:
		if child.name == item_name:
			results.append(child)
	
	return results

func _on_button_2_pressed():
	var items = find_items_by_name("Food")
	
	if items.size() > 0:
		var first_item = items[0]
		set_current_task(first_item, "eat")
