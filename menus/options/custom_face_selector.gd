extends PanelContainer
class_name CustomFaceSelector

signal cancel


func _on_cancel_pressed()->void:
	visible=false
	cancel.emit()


func _on_save_pressed()->void:
	visible=false
	cancel.emit()
