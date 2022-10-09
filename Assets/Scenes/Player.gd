extends KinematicBody2D

const projectile = preload("res://Assets/Scenes/Projectile.tscn")

export var MAX_SPEED = 200
export var ACCELERATION = 1000
export var FRICTION = 300
export var SPRINT_RATE = 1.2
export var CANDY_SPEED = 400

var stats = Stats

var up_input = Vector2.ZERO.y
var down_input = Vector2.ZERO.y
var left_input = Vector2.ZERO.x
var right_input = Vector2.ZERO.x
var sprint_input = Vector2.ZERO
var use_input

var can_sprint = true

# DEBUG
onready var PlayerLabel = $"%PlayerState"
onready var UseLabel = $"%UseState"
onready var StatsLabel = $"%Stats"

enum PLAYER {
	IDLE,
	MOVE,
	SPRINT
}

enum USE {
	IDLE,
	SHOOT,
	MILK
}

var state = PLAYER.IDLE
var use_state = USE.IDLE
var sprintSpeed = MAX_SPEED * SPRINT_RATE
var velocity = Vector2.ZERO
var input_vector = Vector2.ZERO
var sprint_vector = Vector2.DOWN

func _ready():
	stats.connect("no_health", self, "dead")
	stats.connect("no_stamina", self, "no_stamina")


func _process(delta):
	up_input = Input.get_action_strength("Up")
	down_input = Input.get_action_strength("Down")
	left_input = Input.get_action_strength("Left")
	right_input = Input.get_action_strength("Right")
	sprint_input = Input.is_action_pressed("Sprint")
	use_input = Input.is_action_just_released("Use")
	
func _physics_process(delta):	
	
	match state:
		PLAYER.IDLE:
			idle_state(delta)
		PLAYER.MOVE:
			move_state(delta)
		PLAYER.SPRINT:
			sprint_state(delta)
	
	match use_state:
		USE.IDLE:
			pass
		USE.SHOOT:
			shoot_state()
		USE.MILK:
			pass
	
	input_vector.x = right_input - left_input
	input_vector.y = down_input - up_input
	input_vector = input_vector.normalized()
	PlayerLabel.set_text("PLAYER: " + PLAYER.keys()[state] + " " + str(input_vector))
	UseLabel.set_text("USE: "+ USE.keys()[use_state])
	StatsLabel.set_text("HEALTH: "+ str(stats.health) + "STAMINA: " + str(stats.stamina))
	
	if input_vector != Vector2.ZERO:
		state = PLAYER.MOVE
	else:
		state = PLAYER.IDLE
	
	if sprint_input and can_sprint:
		state = PLAYER.SPRINT

	if use_input:
	# Figure out what action state that is to be performed
		use_state = USE.SHOOT
	else:
		use_state = USE.IDLE
	
	if stats.stamina == stats.MAX_STAMINA:
		can_sprint = true
	
	move()
	

func idle_state(delta):
	regen_stamina()
	velocity = velocity.move_toward(Vector2.ZERO, FRICTION * delta)

func move_state(delta):
	regen_stamina()
	if input_vector != Vector2.ZERO:
		velocity(MAX_SPEED, delta)
	else:
		state = PLAYER.IDLE	

func sprint_state(delta):
	stats.stamina -= 1
	velocity(sprintSpeed, delta)
	move()
	
func shoot_state():
	var candy_instance = projectile.instance()
	candy_instance.position = global_position #* offset
	get_tree().get_root().call_deferred("add_child", candy_instance)
	
func move():
	velocity = move_and_slide(velocity)
	
func velocity(speed, delta):
	velocity = velocity.move_toward(input_vector * speed, ACCELERATION * delta)

func no_stamina():
	can_sprint = false

func regen_stamina():
	if stats.stamina <= stats.MAX_STAMINA:
		stats.stamina += 1

func dead():
	pass
