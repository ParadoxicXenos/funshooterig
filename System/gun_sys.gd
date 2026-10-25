extends Node

@export var parent : CharacterBody3D
@onready var cooldown_timer: Timer = $CooldownTimer
@onready var collider: Object
@onready var collider_location: Vector3
var current_gun : laser

func shoot():
	current_gun = parent.current_gun
	if parent.can_shoot == true and parent.current_bullets>0:
		parent.flash.light_energy = 16.0
		$FlashTimer.start()
		parent.bullet_raycast.target_position = Vector3(0,current_gun.bullet_range*-1,0)
		parent.bullet_raycast.enabled = true
		parent.bullet_raycast.force_raycast_update() 
		if parent.bullet_raycast.is_colliding():
			collider = parent.bullet_raycast.get_collider()
			collider_location = parent.bullet_raycast.get_collision_point()
			if collider.get_class() == "CharacterBody3D":
				collider.health -= current_gun.damage
				if collider.health <0:
					parent.ammo[current_gun.ammo] += 20
				print(collider,"hit\nHealth:",collider.health)
			else:
				print(collider.get_class())
		
		if current_gun.type != laser.WeaponType.MELEE:
			parent.current_bullets -=1
		parent.bullet_raycast.enabled = false
		#Cooldowns and shi
		parent.can_shoot = false
		cooldown_timer.start(current_gun.cooldown)
		
		#SFX
		$AudioStreamPlayer3D.stream = current_gun.firing_sounds[randi_range(0,19)]
		$AudioStreamPlayer3D.play()
		
		
	if parent.current_bullets==0:
		$AudioStreamPlayer3D.stream = current_gun.dry_fire_sound
		$AudioStreamPlayer3D.play()

func reload():
	if current_gun.ammo != "melee":
		var ammo_to_add= current_gun.max_mag - parent.current_bullets
		if parent.ammo[current_gun.ammo] > ammo_to_add:
			parent.ammo[current_gun.ammo] -= ammo_to_add
			parent.current_bullets += ammo_to_add
		if parent.ammo[current_gun.ammo] < ammo_to_add:
			parent.current_bullets += parent.ammo[current_gun.ammo]
			parent.ammo[current_gun.ammo] = 0
		cooldown_timer.start(randf_range(1.3,3.6))
		parent.can_shoot = false

func _on_cooldown_timer_timeout() -> void:
	parent.can_shoot = true


func _on_flash_timer_timeout() -> void:
	parent.flash.light_energy = 0.0
