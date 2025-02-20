class_name EnemyDefinition
extends Resource

@export_category("Visuals")
@export var name: String = "Unnamed Enemy"
@export var texture: AtlasTexture = AtlasTexture.new()
@export_color_no_alpha var color: Color = Color.RED

@export_category("Mechanics")
@export var hp: int = 10
@export var size: int = 100
@export var ev: int = 0
@export var ac: int = 0
@export var armor_coverage: int = 0

@export_category("Items")

@export_category("Components")
# @export var ai_type: enum
