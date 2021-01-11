tool
extends LineEdit

var fs:Tree;

var throttleTimer:Timer;

# Declare member variables here. Examples:
# var a = 2
# var b = "text"
# Called when the node enters the scene tree for the first time.
func _ready():
	fs = get_node('../Tree');
	throttleTimer = Timer.new();
	throttleTimer.wait_time = .5;
	throttleTimer.autostart = false;
	throttleTimer.connect("timeout", fs, "filter_tree");
	add_child(throttleTimer);
	right_icon = get_node("../../../").plugin.get_editor_interface().get_base_control().get_icon("Search", "EditorIcons")
	connect("text_changed", self, "filter");
	connect("focus_exited", self, "focus_exit");
func filter(var tex):
	fs.filter = tex;
	throttleTimer.start();
func focus_exit():
	throttleTimer.stop();
	fs.filter_tree();
