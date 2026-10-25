extends CharacterBody3D

var health = 100
var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")
var speed = 5
var light = 16.0
var sprint_speed = 7
var jump_speed = 5
var mouse_sensitivity = 0.002
#System Nodes
@onready var gun: Node = $GunSys
#Raycast
@onready var bullet_raycast: RayCast3D = $Camera3D/BulletRayCast3D
#Muzzle_flash
@onready var flash: SpotLight3D = $Camera3D/CSGBox3D2/Muzzle_flash

#GUNS
var current_gun : laser = SMG
var can_shoot : bool = true
var is_reloading : bool = false
var current_bullets : int = current_gun.max_mag

const MELEE = preload("uid://decak7gghvnn1")
const PISTOL = preload("uid://cwxou34kvk8ji")
const SHOTGUN = preload("uid://b8j82ydgrmngd")
const SMG = preload("uid://bqm8cm43ws6l0")



var ammo :Dictionary = {
	"melee" : 1,
	"smg" : 250,
	"shotgun" : 15,
	"pistol" : 150,
}

func _ready():
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	

func _input(event):
	if event is InputEventMouseMotion and Input.mouse_mode == Input.MOUSE_MODE_CAPTURED:
		rotate_y(-event.relative.x * mouse_sensitivity)
		$Camera3D.rotate_x(-event.relative.y * mouse_sensitivity)
		$Camera3D.rotation.x = clampf($Camera3D.rotation.x, -deg_to_rad(70), deg_to_rad(70))
		
func _physics_process(delta):		
	if health < 0:
		$Camera3D/CSGBox3D2/Muzzle_flash.light_color = Color(255,0,0)
		$Camera3D/CSGBox3D2/Muzzle_flash.light_energy = 16.0
	$Camera3D/CSGBox3D2/SpotLight3D.light_energy = light
	$Camera3D/SpotLight3D2.light_energy = light
	if Input.is_action_pressed("escape") == true && Input.mouse_mode==Input.MOUSE_MODE_CAPTURED:
		Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
	if Input.is_action_pressed("shoot") == true && Input.mouse_mode==Input.MOUSE_MODE_VISIBLE:
		Input.mouse_mode=Input.MOUSE_MODE_CAPTURED
	if Input.is_action_pressed("light") == true:
		light = 0.0
	else:
		light = 16.0
		
	if Input.is_action_pressed("shoot") == true && Input.mouse_mode==Input.MOUSE_MODE_CAPTURED:
		$GunSys.shoot()
		
	velocity.y += -gravity * delta
	
	var input = Input.get_vector("left","right", "forward", "back")
	var movement_dir = transform.basis * Vector3(input.x, 0, input.y)
	
	if Input.is_action_pressed("sprint") == true:
		velocity.x = movement_dir.x * sprint_speed
		velocity.z = movement_dir.z * sprint_speed
	if Input.is_action_pressed("sprint") == false:
		velocity.x = movement_dir.x * speed
		velocity.z = movement_dir.z * speed
	if Input.is_action_pressed("gun_slot1"):
		current_gun = MELEE
		print(current_gun)
	if Input.is_action_pressed("gun_slot2"):
		current_gun = SHOTGUN
		print(current_gun)
	if Input.is_action_pressed("gun_slot3"):
		current_gun = SMG
		print(current_gun)
	if Input.is_action_pressed("gun_slot4"):
		current_gun = PISTOL
		print(current_gun)
		
	if Input.is_action_just_pressed("reload"):
		$GunSys.reload()
	move_and_slide()
	
	if is_on_floor() and Input.is_action_just_pressed("jump"):
		velocity.y = jump_speed
