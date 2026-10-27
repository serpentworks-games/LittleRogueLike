class_name EntityDefinition
extends Resource

@export_category("Visuals")
@export var name: StringName = "Unnamed Entity"
@export var texture: AtlasTexture
@export_color_no_alpha var color: Color = Color.WHITE

@export_category("Mechanics")
@export var entity_type: Entity.EntityType = Entity.EntityType.ACTOR
@export var can_block_movement: bool = true

@export_category("Components")
@export var fighter_definition: FighterComponentDefinition
@export var ai_type: Entity.AIType
@export var consumable_definition: ConsumableComponentDefinition
@export var inventory_capacity: int = 0
