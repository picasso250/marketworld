extends Label


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func update_status(text: String) -> void:
	self.text = text
	show()

func show_status_with_fade(text: String) -> void:
	update_status(text)

	# 创建一个Tween节点（如果场景中没有的话）
	var tween = get_tree().create_tween()

	# 设置初始透明度
	self.modulate.a = 1.0
	
	# 透明度动画
	tween.tween_property(
		self, # 动画目标节点
		"modulate:a", # 修改透明度属性
		0.0, # 结束值
		2.0, # 持续时间
	)
	
	# 动画完成后隐藏文本
	tween.connect("tween_completed", _on_fade_out_complete)
	
	tween.play()

# 动画完成后的回调函数
func _on_fade_out_complete() -> void:
	hide()
	# 设置初始透明度
	self.modulate.a = 1.0
