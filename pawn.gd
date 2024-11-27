extends Sprite2D

# 用于获取对应的进度条节点
var progress_bar

# Called when the node enters the scene tree for the first time.
func _ready():
	# 获取场景中的进度条节点
	progress_bar = get_node("ProgressBar")


# Called every frame. 'Delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

# 函数：开始增长进度条，参数为时间（单位：秒）
func start_growth_progress(time):
	# 假设进度条增长是线性的，根据总时间和每一帧的时间间隔来计算每帧增长的比例
	var growth_per_frame = 1 / (time / delta)

	# 设置进度条的初始值为0
	progress_bar.value = 0

	# 定义一个变量来记录已经经过的时间
	var elapsed_time = 0

	# 循环更新进度条的值，直到达到总时间或者进度条已满
	while elapsed_time < time and progress_bar.value < progress_bar.max:
		elapsed_time += delta
		progress_bar.value += growth_per_frame

		if progress_bar.value > progress_bar.max:
			progress_bar.value = progress_bar.max

		yield(get_tree().create_timer(delta), "timeout")
