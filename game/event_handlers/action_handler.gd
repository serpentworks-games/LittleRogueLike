class_name ActionHandler
extends Node

enum ActionHandlers { MAIN_GAME, GAME_OVER, HISTORY_VIEWER }

@export var starting_action_handler: ActionHandlers

@onready var action_handler_nodes := {
	ActionHandlers.MAIN_GAME: $MainGameActionHandler,
	ActionHandlers.GAME_OVER: $GameOverActionHandler,
	ActionHandlers.HISTORY_VIEWER: $HistoryViewerActionHandler
}

var current_action_handler: BaseActionHandler

func _ready() -> void:
	transition_to(starting_action_handler)
	SignalBus.player_died.connect(
		transition_to.bind(ActionHandlers.GAME_OVER)
	)
	
func get_action(player: Entity) -> Action:
	return current_action_handler.get_action(player)

func transition_to(action_handler: ActionHandlers) -> void:
	if current_action_handler != null:
		current_action_handler.exit()
		
	current_action_handler = action_handler_nodes[action_handler]
	current_action_handler.enter()
