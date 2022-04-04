extends RigidBody2D

#las variables a continuacion son las de los sonidos
onready var break_s : AudioStreamPlayer2D = get_node("break")
onready var hit_s : AudioStreamPlayer2D = get_node("hit")
onready var lose_s : AudioStreamPlayer2D = get_node("lose")
onready var start_s : AudioStreamPlayer2D = get_node("start")
onready var you_win_s : AudioStreamPlayer2D = get_node("you_win")

#Variable para ejecutar un sola vez la funcion inciar
var game_started : bool = false
var replay_scene = load("res://title/replay.tscn")

const speed_x = 50
const speed_y = -300

func _input(event):
	if event.is_action_pressed("iniciar") and not game_started:
		linear_velocity = Vector2(speed_x, speed_y)
		game_started = true
		start_s.play()

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
# warning-ignore:unused_argument
func _physics_process(delta):
	for body in get_colliding_bodies():
		if body.is_in_group("gr_blocks"):
			body.queue_free()
			break_s.play()
			if body.get_parent().get_child_count() == 1:
				print("¡¡¡YOU WIN!!!") 
				get_tree().paused = true
				you_win_s.play()	
				yield(you_win_s, "finished")
				queue_free()
				get_parent().add_child(replay_scene.instance())
				
		else:
			hit_s.play()
			

func _on_VisibilityNotifier2D_screen_exited():
	print("¡¡¡YOU LOSE!!!")
	get_tree().paused = true
	lose_s.play()
	yield(lose_s,"finished")
	queue_free()
	get_parent().add_child(replay_scene.instance())
	
