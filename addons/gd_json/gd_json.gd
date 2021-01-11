tool
extends EditorPlugin


# A class member to hold the dock during the plugin life cycle.
var dock


func _enter_tree():
	# Initialization of the plugin goes here.
	# Load the dock scene and instance it.
	dock = preload("res://addons/gd_json/dock.tscn").instance()
	dock.plugin = self;
	var fs = dock.get_node("PanelContainer/VBoxContainer/Tree");
	fs.plugin = self;

	# Add the loaded scene to the docks.
	add_control_to_dock(DOCK_SLOT_RIGHT_UL, dock)
	# Note that LEFT_UL means the left of the editor, upper-left dock.
	#get_editor_interface().get_resource_filesystem().connect("filesystem_changed", fs, "gen_files");


func _exit_tree():
	# Clean-up of the plugin goes here.
	# Remove the dock.
	remove_control_from_docks(dock)
	# Erase the control from the memory.
	dock.free()
