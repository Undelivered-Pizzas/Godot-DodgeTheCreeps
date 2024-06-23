extends Area2D
signal hit

# @export expression allows us to set variable's value from inspector
@export var speed = 400 # How fast the player moves in pixels
var screen_size # Size of the game window

func start(pos):
	# We reset the player default status when starting a new game
	position = pos
	show()
	$CollisionShape2D.disabled = false

# Called when the node enters the scene tree for the first time.
func _ready():
	screen_size = get_viewport_rect().size
	hide() # player is hidden when game starts


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	var velocity = Vector2.ZERO # The player's movement vector
	if Input.is_action_pressed("move_right"):
		velocity.x +=1
	if Input.is_action_pressed("move_left"):
		velocity.x -=1
	if Input.is_action_pressed("move_up"):
		# In the "y" axis, negative values represent moving upwards,
		# this is commong in computer graphics
		velocity.y -=1
	if Input.is_action_pressed("move_down"):
		velocity.y +=1 
	pass
	
	if velocity.length() > 0:
		velocity = velocity.normalized() * speed
		# The $ is a shorhand for get_node(), so is the same as get_node("AnimatedSprite2D").play()
		# returns null if node is not found in the relative path of the current node
		$AnimatedSprite2D.play()
	else:
		$AnimatedSprite2D.stop()
	
	# The delta parameter in the _process() function refers to the frame length - the amount of time that the previous
	# frame took to complete.
	# Using this value ensures that your movement will remain consistent even if the frame rate changes.
	position += velocity * delta
	# Function clamp() restricts a value to a given range
	# in this case, we prevent the player to leave the screen
	position = position.clamp(Vector2.ZERO, screen_size)
	
	if velocity.x != 0:
		$AnimatedSprite2D.animation = "walk"
		$AnimatedSprite2D.flip_v = false
		$AnimatedSprite2D.flip_h = velocity.x < 0 # this is a boolean assignment
		
	elif velocity.y != 0:
		$AnimatedSprite2D.animation = "up"
		$AnimatedSprite2D.flip_v = velocity.y > 0
	


func _on_body_entered(body):
	hide() # player disappears after being hit
	hit.emit()
	
	# We disable player's collision shape, so the hit signal is not triggered more than once.
	# Disabling area's collision can cause error if it happens in the middle of the collision,
	# we use set_deferred() method to tell Godot to wait until it's safe to disable it.
	$CollisionShape2D.set_deferred("disabled", true)
