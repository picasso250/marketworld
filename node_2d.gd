extends Node2D

# 定义一个私有变量
var _health: int = 100

# 使用属性语法定义 getter 和 setter
var health: int:
	get:
		return _health
	set(value):
		_health = value
		# 可以在这里添加额外的逻辑，例如触发信号
		print("Health set to: ", _health)

func _ready():
	# 测试属性
	print(health)  # 输出: 100
	health = 80    # 设置健康值
