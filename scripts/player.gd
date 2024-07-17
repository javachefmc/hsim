# Calculates attributes and functions for each player instance

extends FPController
class_name Player

signal params_changed(params : Dictionary)
signal health_changed(value : int)
signal food_changed(value : int)
signal water_changed(value : int)
signal stamina_changed(value : int)

# Set playerdata first
var player_data : PlayerData = PlayerData.new()

# vars grabbing things from Player scene

@onready var camera : Camera3D = $Head/Camera3D
@onready var anim_player : AnimationPlayer = $Head/Camera3D/AnimationPlayer

@onready var raycast : RayCast3D = $Head/Raycast
@onready var hitbox : Area3D = $Head/PlayerHitbox

@onready var hunger_tick: Timer = $HungerTick

## ATTRIBUTES

@export var inventory : PlayerInventory

const max_param : int = 100

## Adjustable parameters (appear as bars)

@export var health : int = player_data.health:
	set(val):
		health = val
		health_changed.emit(val)
@export var food : int = player_data.food:
	set(val):
		food = val
		food_changed.emit(val)
@export var water : int = player_data.water:
	set(val):
		water = val
		water_changed.emit(val)
@export var stamina : int = player_data.stamina:
	set(val):
		stamina = val
		stamina_changed.emit(val)

## Reactive parameters (appear as bars)

var heat : int = 0
var cold : int = 0

# fall damage system

@export var fall_safe_distance : float = 10
@export var fall_damage_multiplier : float = 0.5

# stamina system

@export var stamina_cooldown : float = 6
@export var stamina_run_affect : float = 0.4
@export var stamina_jump_affect :int = 5
@export var stamina_recover : float = 0.2
var encumbered : bool = false;

# hunger system

@export var food_affect : int = 2 # amount that food is reduced
@export var food_encumbered_affect : int = 5 # amount food is reduced when recovering stamina
var saturation : int = 0 # saturation delays how long hunger reduction is paused
@export var saturation_affect : int = food_affect # amount that saturation is reduced

# thirst system

@export var water_recover : float = 0.6
@export var water_heat_affect : float = 0.2

# temperature system

var local_temp : float = 72
const normal_temp : float = 98.6
@export var body_temp : float = normal_temp # THIS SHOULD BE SET

@export var temp_midpoint : float = 72
@export var temp_comfort_range : float = 8
@export var temp_affect : float = 0.2	# debuff
@export var temp_recover : float = 0.6	# return speed
@export var temp_damage : float = 1

## SIGNALS

func _ready() -> void:
	# Set head node for FPController
	head = get_node("Head")
	# Set animation controller for FPController
	animation_controller = get_node("Head/Camera3D/AnimationPlayer")
	# Prevents selecting self when doing functions with raycast
	raycast.add_exception(hitbox)
	
	# Get player inventory from world save.
	# TODO: don't do this for multiplayer
	update_inventory_from_save()
	
	params_changed.emit({
		"health": health,
		"food": food,
		"water": water,
		"stamina": stamina
	})

func _process(delta : float) -> void:
	super(delta) # Run the process function for FPController

func _unhandled_input(event : InputEvent) -> void:
	super(event) # Run input function for FPController
	
	# Perform use checks
	if Input.is_action_just_pressed("use"):
		pick_object()
	
	if Input.is_action_just_pressed("1"): # debug take damage
		change_health(-10)
	if Input.is_action_just_pressed("2"): # debug eat food
		change_food(10)
	if Input.is_action_just_pressed("3"): # debug heal
		change_health(10)
	if Input.is_action_just_pressed("4"): # debug reduce food
		change_food(-10)

func pick_object() -> void:
	var collider : Node = raycast.get_collider()
	if collider != null and collider is Area3D:
		print("picking object")
		collider.get_parent().collect()
		# Add collector here to determine what to do with collected item

func update_inventory_from_save() -> void:
	pass

func collect(item) -> void:
	inventory.insert(item)

# Parameter changing systems

func change_health(amount : int) -> void:
	health += amount
	if amount < 0:
		animation_controller.play("damage")
	#health = clamp(health, 0, max_param)
	if health == 0: die()
	
func change_stamina(amount : int) -> void:
	stamina += amount
	#stamina = clamp(stamina, 0, max_param)
	
func change_food(amount : int) -> void:
	food += amount
	#food = clamp(food, 0, max_param)
	
func change_water(amount : int) -> void:
	water += amount
	#water = clamp(water, 0, max_param)
	
func die() -> void:
	health = 0 # set again in case of direct function call
	print("You have died")
	# Present death gui depending on game mode
	
	
func temperature_tick() -> void:
	# A local temp is calculated at position of the player.
	# Player parameters have a "comfort" range; inside of this, nothing should happen
	# When temp is outside this range, their body temperature goes up or down
	# Heat or cold bars appear proportional to how far out of range it is
	# Damage is also applied proportional to this
	
	# Update body temperature
	if local_temp < temp_midpoint - temp_comfort_range:
		# decrease body temp
		body_temp -= temp_affect * ((temp_midpoint - temp_comfort_range) - local_temp)
	elif local_temp > temp_midpoint + temp_comfort_range:
		# increase body temp
		body_temp += temp_affect * (local_temp - (temp_midpoint + temp_comfort_range))
	else:
		# Reduce coldness and overheating
		body_temp = lerp(body_temp, normal_temp, temp_recover)
	
	# Update heat and cold bars
	var temp_delta : float = body_temp - normal_temp
	
	if round(temp_delta) > 0:
		cold = 0
		heat = clamp(round(abs(temp_delta) * 10), 0, max_param)
	elif round(temp_delta) < 0:
		heat = 0
		cold = clamp(round(abs(temp_delta) * 10), 0, max_param)
	else:
		heat = 0
		cold = 0
		
	change_health(-abs(temp_delta) * temp_damage)

func _on_hunger_tick_timeout() -> void:
	# Hunger constantly falls off
	# Different food items should have different saturation amounts
	# Saturation pauses food reduction for the same duration that an equivalent food value takes to diminish
	
	if saturation == 0:
		# constantly diminish player hunger
		food -= food_affect
	else:
		# diminish saturation instead of hunger
		saturation -= saturation_affect
		if saturation < 0: saturation = 0
		
	if food <= 0:
		change_health(-5)
