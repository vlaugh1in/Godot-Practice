extends KinematicBody2D

export var MAX_SPEED = 600
export var ACCELERATION = 600
export var DESPAWN_TIME = 1
var projectile_velocity = Vector2.ZERO
var direction 

onready var timer = $DespawnTimer

func _ready():
	direction = get_local_mouse_position()
	timer.start(DESPAWN_TIME)
	
func _physics_process(delta):
	projectile_velocity = projectile_velocity.move_toward(direction * MAX_SPEED, ACCELERATION * delta)
	projectile_velocity = move_and_slide(projectile_velocity)
	
func _on_HitBox_area_entered(area):
	queue_free()

func _on_DespawnTimer_timeout():
	queue_free()
