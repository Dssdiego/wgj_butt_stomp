extends KinematicBody2D

export (int) var speed = 280
export (int) var jump_speed = -400
export (int) var gravity = 1000
export (float) var stomp_wait_time = 0.5
export (float) var stomp_gravity_multiplier = 1.5

enum State {
	NORMAL,
	STOMP
}

var velocity = Vector2.ZERO
var gravity_default = gravity
var state = State.NORMAL
# TODO: Coyote time

func apply_screen_loop():
	var screen_size = get_viewport_rect().size
	if position.x > screen_size.x:
		position.x = 0
	
	if position.x < 0:
		position.x = screen_size.x
		
	if position.y > screen_size.y:
		position.y = 0
	
	if position.y < 0:
		position.y = screen_size.y

func get_input():
	velocity.x = 0
	
	# Moving right or left only on normal mode, i.e. blocked on STOMP mode
	if Input.is_action_pressed("ui_right") && state == State.NORMAL:
		velocity.x += speed
	if Input.is_action_pressed("ui_left") && state == State.NORMAL:
		velocity.x -= speed

func _physics_process(delta):
	get_input()
	
	# Apply gravity and horizontal speed
	velocity.y += gravity * delta
	
	
	# Blocks infinite acceleation when falling, i.e. max fall speed
	if velocity.y > gravity/2:
		velocity.y = gravity/2
	
	# Jump
	if Input.is_action_just_pressed("ui_up"):
		if is_on_floor():
			velocity.y = jump_speed
			
	# TODO: Variable jump height
	
	# Stomp action
	if Input.is_action_just_pressed("stomp"):
		if !is_on_floor():
			state = State.STOMP
			velocity.x = 0
			velocity.y = 0
			gravity = 0
			yield(get_tree().create_timer(stomp_wait_time), "timeout")
			gravity = gravity_default
			velocity.y = gravity * stomp_gravity_multiplier
			state = State.NORMAL
			
	velocity = move_and_slide(velocity, Vector2.UP)

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	print(velocity)
	apply_screen_loop()
