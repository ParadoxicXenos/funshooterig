extends CharacterBody3D
@onready var player = get_node("../Player")
@onready var health = 100
var target_pos = Vector3() 
var speed = 2.0
@onready var gun: Node = $GunSys
@onready var bullet_raycast: RayCast3D = $CSGBox3D2/BulletRayCast3D
@onready var flash: SpotLight3D = $CSGBox3D2/Muzzle_flash
var light = 16.0

var current_gun : laser = PISTOL
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
	target_pos = player.global_position
	
func _physics_process(delta: float) -> void:
	if current_gun.ammo != "melee":
		ammo[current_gun.ammo] +=1
		print(ammo[current_gun.ammo])
	$CSGBox3D2/SpotLight3D.light_energy = light
	$CSGBox3D2/SpotLight3D2.light_energy = light
	$Label3D.text = str(health)
	if health<0:
		print("IM DED")
		queue_free()
	if Input.is_action_pressed("light") == false:
		target_pos = player.global_position
		$NavigationAgent3D.target_position = target_pos
	var next_pos = $NavigationAgent3D.get_next_path_position()
	var movement_dir = next_pos - global_position
	velocity.x = movement_dir.x * speed
	velocity.z = movement_dir.z * speed
	$CSGBox3D2.look_at(target_pos)
	$CSGBox3D2.rotation.x += 90
	look_at(Vector3(next_pos.x,global_position.y,next_pos.z))
	if current_bullets == 0:
		$GunSys.reload()
	$GunSys.shoot()
	move_and_slide()
