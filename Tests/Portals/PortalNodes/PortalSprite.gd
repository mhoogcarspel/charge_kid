extends Sprite



onready var camera = null
onready var shader = self.get_material()

onready var time = 0



func _ready():
	generate_speeds()

func _process(delta):
	time += delta
	shader.set_shader_param("time", time)
	if get_tree().get_nodes_in_group("camera").size() > 0:
		camera = get_tree().get_nodes_in_group("camera")[0]
		shader.set_shader_param("dist", camera.get_camera_screen_center().x/512)



func generate_speeds():
	var ratio_1 = (randi()%21 + 40)/100 as float
	var ratio_2 = (randi()%11 + 20)/100 as float
	
	var velocity = Vector2.ZERO
	velocity.x = (randi()%41 - 20)/1000 as float
	velocity.y = (randi()%41 - 20)/1000 as float
	
	shader.set_shader_param("ratio_1", ratio_1)
	shader.set_shader_param("ratio_2", ratio_2)
	shader.set_shader_param("velocity_1", velocity)
	shader.set_shader_param("velocity_2", velocity*ratio_2/ratio_1)


