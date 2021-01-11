tool
extends Tree


# Declare member variables here. Examples:
# var a = 2
# var b = "text"

var root;
var res;
var files:Array;

var plugin:EditorPlugin;
# Called when the node enters the scene tree for the first time.
func _ready():
	gen_files();

func get_file_if_json(var directory:Directory)->String:
	var f = directory.get_next();
	if !f.empty():
		if f.get_extension() == "json" || f.get_extension().empty():
			return f;
		else:
			return get_file_if_json(directory);
	else:
		return "";

var filter:String;

func filter_tree():
	var selec
	clear();
	root = create_item();
	#var refresh = root.add_button(0, plugin.get_editor_interface().get_base_control().get_icon("Reload", "EditorIcons"), -1, false, "Refresh");
	root.set_text(0, "res://");
	root.set_icon(0, plugin.get_editor_interface().get_base_control().get_icon("Folder", "EditorIcons"));
	if files.empty():
			var empty := create_item(root);
			empty.set_custom_color(0, "#646464");
			empty.set_selectable(0, false);
			empty.set_text(0, "No JSON files found");
			empty.set_icon_modulate(0, Color("#646464"));
			empty.set_icon(0, plugin.get_editor_interface().get_base_control().get_icon("ScriptRemove", "EditorIcons"));
	else:
		for i in files:
			if !filter.empty():
				if !(filter in i.replacen(".json", "")):
					continue;
			var file = create_item(root)
			file.set_text(0, i)
			file.set_icon(0, plugin.get_editor_interface().get_base_control().get_icon("Script", "EditorIcons"));

func get_files_in_dir(var subdir:String="")->Array:
	var dir = Directory.new();
	if dir.open(ProjectSettings.globalize_path("res://" + subdir)) == OK:
		dir.list_dir_begin(true, true);
		var file_name = get_file_if_json(dir);
		var subdirs = [];
		while file_name != "":
			if dir.current_is_dir():
				print(file_name);
				subdirs.append(file_name);
			else:
				print("Found file: " + file_name)
				files.append(file_name);
			file_name = get_file_if_json(dir)
		dir.list_dir_end();
		return subdirs;
	else:
		print("An error occured while trying to open 'res://'");
		return [];

#Generate FileSystem Tree
func gen_files():
	files.clear();
	var subdirs = get_files_in_dir();
	print(subdirs);
	for sub in subdirs:
		print(sub);
		get_files_in_dir(sub);
	filter_tree();
	#dir.free();

func _notification(what):
	match what:
		NOTIFICATION_WM_FOCUS_IN:
			gen_files();
		NOTIFICATION_WM_FOCUS_OUT:
			gen_files();
