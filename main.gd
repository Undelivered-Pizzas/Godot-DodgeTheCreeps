extends Node

@export var mob_scene: PackedScene
var score


# Called when the node enters the scene tree for the first time.
func _ready():
	# new_game() is COMMENTED because we don't want the game to start automatically
	# new_game()
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

# This is a hit signal from Player handled by the Main script
func game_over():
	$ScoreTimer.stop()
	$MobTimer.stop()
	
	$HUD.show_game_over()
	
func new_game():
	# HUD score setup
	score = 0
	$HUD.update_score(score)
	$HUD.show_message("Get Ready")

	# Player position setup
	$Player.start($StartPosition.position)
	$StartTimer.start()
	
	# Calling "mobs" group defined in Node/Groups tab on mob.tscn root node
	# calls the named function on every node in a group - in this case we are telling every mob to delete itself.
	get_tree().call_group("mobs", "queue_free")

func _on_start_timer_timeout():
	$MobTimer.start()
	$ScoreTimer.start()


func _on_score_timer_timeout():
	score += 1


func _on_mob_timer_timeout():
	# Create a new instance of the Mob scene
	var mob = mob_scene.instantiate()
	
	# Choose a random location on Path2D
	var mob_spawn_location = $MobPath/MobSpawnLocation
	mob_spawn_location.progress_ratio = randf()
	
	# Set the mob's direction perpendicular to the path direction
	# PI is because in functions requiring angles, Godot uses radians, not degrees
	var direction = mob_spawn_location.rotation + PI / 2
	
	# Set the mob's position to a random location
	mob.position = mob_spawn_location.position
	
	# Add som randomness to the direction
	direction += randf_range(-PI / 4, PI / 4)
	mob.rotation = direction
	
	# Choose the velocity of the mob
	var velocity = Vector2(randf_range(150.0, 250.0), 0.0)
	mob.linear_velocity = velocity.rotated(direction)
	
	# Spawn the mob by adding it to the Main scene
	add_child(mob)
