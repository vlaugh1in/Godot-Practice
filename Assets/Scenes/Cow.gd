extends KinematicBody2D

export var MAX_SPEED = 500
export var ACCELERATION = 100
export var FRICTION = 200

export var path_to_player = NodePath()

enum AI {
	IDLE,
	WANDER,
	RUN,
	ATTACK
}

var state = AI.IDLE
var velocity = Vector2.ZERO

onready var stats = $Stats
onready var hurtBox = $HurtBox
onready var stateText = $CowState
onready var milkedStateText = $MilkedState
onready var playerDetection = $PlayerDetection
onready var timer: Timer = $PathfindingUpdate
onready var player_node = get_node(path_to_player)
onready var agent: NavigationAgent2D = $NavigationAgent2D

func _ready():
	update_pathfinding()
	timer.connect("timeout", self, "update_pathfinding")

func _physics_process(delta):
	match state:
		AI.IDLE:
			idle_state(delta)
		AI.WANDER:
			pass
		AI.RUN:
			run_state(delta)
		AI.ATTACK:
			chase_state(delta)
	move()
	stateText.set_text("STATE: "+ AI.keys()[state])

func move():
	velocity = move_and_slide(velocity)

func idle_state(delta):
	velocity = velocity.move_toward(Vector2.ZERO, FRICTION * delta)
	seek_player()

func run_state(delta):
	var player = playerDetection.player
	if player == null:
		state = AI.IDLE
	else:
		var direction = -(player.global_position - global_position).normalized()
		velocity = velocity.move_toward(direction * MAX_SPEED, ACCELERATION * delta)


func chase_state(delta):
	var direction 
	var player = playerDetection.player
	if player == null:
		state = AI.IDLE
	else:
		if agent.is_navigation_finished():
			return
		direction = global_position.direction_to(agent.get_next_location())
		velocity = velocity.move_toward(direction * MAX_SPEED, ACCELERATION * delta)


func seek_player():
	if playerDetection.can_see_player():
		state = AI.ATTACK

func update_pathfinding():
	agent.set_target_location(player_node.global_position)
	
func _on_HurtBox_area_entered(area):
	stats.health -= area.DAMAGE

func _on_Stats_no_health():
	state = AI.RUN
	milkedStateText.set_text("Milked")
