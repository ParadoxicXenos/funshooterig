extends Resource
class_name laser

enum WeaponType {
	MELEE,
	PISTOL,
	SHOTGUN,
	SMG
}

@export var type : WeaponType
@export var ammo : String
@export var mesh : Mesh
@export var cooldown : float
@export var sway : float
@export var auto : bool

@export_category("Sounds")
@export var firing_sounds : Array[AudioStream]
@export var reload_sound : AudioStream
@export var dry_fire_sound : AudioStream = preload("uid://dofl2expuur13")

@export_category("beam stats")
@export var damage : int
@export var spread : float
@export var max_mag : int
@export var bullet_amt : int = 1
@export var bullet_range : int =40
