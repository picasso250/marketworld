@tool
extends EditorPlugin

@export var copy_button_text: String = "Copy Code"

var copy_button: Button

func _enter_tree():
	# 创建工具栏按钮
	copy_button = Button.new()
	copy_button.text = copy_button_text
	copy_button.tooltip_text = "Copy current file's code to clipboard."
	copy_button.connect("pressed", Callable(self, "_on_copy_button_pressed"))

	# 将按钮添加到编辑器工具栏
	add_control_to_container(CONTAINER_TOOLBAR, copy_button)

func _exit_tree():
	# 移除按钮以清理资源
	remove_control_from_container(CONTAINER_TOOLBAR, copy_button)
	copy_button.queue_free()

func _on_copy_button_pressed():
	var current_script: Script = get_script_editor().get_current_script()

	if current_script:
		# 读取当前脚本内容
		var script_code = current_script.get_source_code()
		var file_name = current_script.resource_path.get_file()
		# 包裹代码并添加文件名
		var formatted_code = "File: "+(file_name)+ "\n```\n" + script_code + "\n```\n\n需求： "
		# 将代码复制到剪贴板
		DisplayServer.clipboard_set(formatted_code)
		# 通知用户操作成功
		print("Code copied to clipboard.")
	else:
		print("No script is currently open.")

func get_script_editor() -> ScriptEditor:
	# 获取脚本编辑器实例
	return get_editor_interface().get_script_editor()
