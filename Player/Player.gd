extends KinematicBody2D

const MAX_SPEED = 80
const ROLL_SPEED = 125
const ACCELERATION = 500
const FRICTION = 500

enum {
	MOVE,
	ROLL,
	ATTACK
}

var state = MOVE
var velocity = Vector2.ZERO
var roll_vector = Vector2.ZERO

onready var animationPlayer = $AnimationPlayer  # raccourci pour la fonction "_ready"
onready var animationTree = $AnimationTree
onready var animationState = animationTree.get("parameters/playback")

# Called when the node enters the scene tree for the first time.
func _ready():
	animationTree.active = true

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	match state:  # équivalent du switch
		MOVE:
			move_state(delta)
		ROLL:
			roll_state(delta)
		ATTACK:
			attack_state(delta)

func move_state(delta):
	var input_vector = Vector2.ZERO
	input_vector.x = Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left")
	input_vector.y = Input.get_action_strength("ui_down") - Input.get_action_strength("ui_up")
	input_vector = input_vector.normalized()

	if input_vector != Vector2.ZERO:
		roll_vector = input_vector
		animationTree.set("parameters/Idle/blend_position", input_vector)
		animationTree.set("parameters/Run/blend_position", input_vector)
		animationTree.set("parameters/Attack/blend_position", input_vector)  # je laisse ça ici pour pas que le joueur change d'angle d'attaque durant l'animation
		animationTree.set("parameters/Roll/blend_position", input_vector)
		animationState.travel("Run")
		
		velocity = velocity.move_toward(input_vector * MAX_SPEED, ACCELERATION * delta)
	else:
		animationState.travel("Idle")
		velocity = velocity.move_toward(Vector2.ZERO, FRICTION * delta)
		
	move()
	
	if Input.is_action_just_pressed("Attack"):
		state = ATTACK
		
	if Input.is_action_just_pressed("Roll"):
		state = ROLL
		
func move():
	velocity = move_and_slide(velocity)

func attack_state(_delta):
	velocity = Vector2.ZERO
	animationState.travel("Attack")
	
func roll_state(_delta):
	velocity = roll_vector * ROLL_SPEED
	animationState.travel("Roll")
	move()

# cette méthode est appelée par AnimationPlayer après la fin de chaque animation d'attaque
func attack_animation_finished():
	state = MOVE

func roll_animation_finished():
	velocity = velocity / 1.5
	state = MOVE
	
