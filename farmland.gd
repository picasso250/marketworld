extends ColorRect

# 定义农田成熟时间间隔（单位：秒），这里假设为10秒，可根据实际需求修改
@export var maturity_interval = 10

# 用于记录自上次成熟后经过的时间
var time_since_last_maturity = 0

# 标记农田是否已经成熟
var is_mature = false

var task_duration = 1


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	# 更新自上次成熟后经过的时间
	time_since_last_maturity += delta
	update_tooltip()

	# 判断是否到达成熟时间间隔
	if time_since_last_maturity >= maturity_interval:
		is_mature = true
		time_since_last_maturity = 0


# 用于更新tooltip显示的内容
func update_tooltip():
	if is_mature:
		self.tooltip_text = "这片农田已经成熟，可以收割啦！"
	else:
		self.tooltip_text = "这片农田正在生长中，请耐心等待成熟。"+str(time_since_last_maturity)

# 返回农田的中心位置（二维向量）
func get_center_position() -> Vector2:
	return position + size / 2
