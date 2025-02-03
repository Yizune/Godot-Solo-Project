extends CanvasLayer

@onready var title_label = $Title
@onready var description_label = $Description
@onready var tutorial_image = $TextureRect
@onready var next_button = $Next
@onready var previous_button = $Previous
@onready var close_button = $Close
@onready var background = $ColorRect  # Darkened background

var tutorial_pages = [
	{
		"title": "Movement",
		"description": "Use WASD to move your character.",
		"image": preload("res://my_stuff/tutorial1.png")
	},
	{
		"title": "Attacking",
		"description": "Press Space to attack enemies.",
		"image": preload("res://my_stuff/tutorial2.png")
	},
	{
		"title": "Exploration",
		"description": "Explore the world to find secrets!",
		#"image": preload("res://path/to/exploration_image.png")
	}
]

var current_page = 0  # Track which tutorial page we're on

func _ready():
	update_tutorial_page()

func show_tutorial():
	visible = true
	background.visible = true
	update_tutorial_page()

func close_tutorial():
	visible = false
	background.visible = false

func next_page():
	if current_page < tutorial_pages.size() - 1:
		current_page += 1
		update_tutorial_page()

func previous_page():
	if current_page > 0:
		current_page -= 1
		update_tutorial_page()

func update_tutorial_page():
	var page_data = tutorial_pages[current_page]
	title_label.text = page_data["title"]
	description_label.text = page_data["description"]
	tutorial_image.texture = page_data["image"]

	# Hide/Show buttons based on the current page
	previous_button.visible = current_page > 0
	next_button.visible = current_page < tutorial_pages.size() - 1

# Connect these functions to button signals in the Inspector
func _on_next_pressed():
	next_page()

func _on_previous_pressed():
	previous_page()

func _on_close_pressed():
	close_tutorial()
