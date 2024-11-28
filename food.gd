extends ColorRect

@export var task_durations = {
	"eat": 1,
}

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func get_center_position() -> Vector2:
	return position + size / 2

func do_task(task_type: String):
	match task_type:
		"eat":
			print("Task: Eating")
			_perform_eating_task()


		_:
			print("Unknown task type: %s" % task_type)
			# Handle unknown task type if necessary

# Define the specific task functions
func _perform_eating_task():
	# Implementation of eating task
	print("Performing eating task")
	var duration = task_durations["eat"]
	print("Duration: %s" % duration)
	queue_free()
