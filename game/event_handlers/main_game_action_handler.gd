extends BaseActionHandler

const MOVE_DIRECTIONS = {
	"move_up": Vector2i.UP,
	"move_down": Vector2i.DOWN,
	"move_left": Vector2i.LEFT,
	"move_right": Vector2i.RIGHT,
}

const INVENTORY_MENU = preload("res://ui/inventory_menu.tscn")

func get_action(player: Entity) -> Action:
	var action: Action = null
	
	for direction in MOVE_DIRECTIONS:
		if Input.is_action_just_pressed(direction):
			var offset: Vector2i = MOVE_DIRECTIONS[direction]
			action = BumpAction.new(player, offset.x, offset.y)
	
	if Input.is_action_just_pressed("wait"):
		action = WaitAction.new(player)
		
	if Input.is_action_just_pressed("view_history"):
		get_parent().transition_to(ActionHandler.ActionHandlers.HISTORY_VIEWER)
		
	if Input.is_action_just_pressed("pickup"):
		action = PickupAction.new(player)
	
	if Input.is_action_just_pressed("quit"):
		action = EscapeAction.new(player)

	return action
	
func get_item(window_title: String, inv: InventoryComponent) -> Entity:
	var inv_menu: InventoryMenu = INVENTORY_MENU.instantiate()
	add_child(inv_menu)
	inv_menu.build_inv(window_title, inv)
	get_parent().transition_to(ActionHandler.ActionHandlers.INVENTORY)
	
	var selected_item: Entity = await inv_menu.item_selected
	await get_tree().physics_frame
	
	get_parent().call_deferred("transition_to", ActionHandler.ActionHandlers.MAIN_GAME)
	return selected_item
	
