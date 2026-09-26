# Battle system

## Cards

Logical cards are instances of [GameCard](res://scripts/combat/game_card.gd).
Each implements methods for different actions, and should have at least a `play(ctl: PlayerCtl, _enemy_ctl:PlayerCtl) -> Array` method defined.
They are addressed by suits (numerically sorted by the `GameCard.S` enum: spades, clubs, hearts, diamonds, jokers and other cards) and ID.

To create a new card, add it to the [CardDatabase](res://scripts/globals/card_database.gd) using the `GameCard.create(suit: S, id: int, can_atk: Able, atk: Vector2i,...)` constructor into the `db[suit][id]` 2D array. 
Each card should also have an `img` attr set with the `img_texture` parameter.
Then, in _ready(), set all its relevant methods to callables. For a `can_atk != Able.NONE`, a `weapon_atk() -> Vector2i` should be set, returning a `Vector2i(damage,damage_type)`. Negative damage grants block for that particular damage type.

Each `play()` method returns an Array for future extensions.
For now only the first element matters. It's always GameCard.Move and says where the card should go after being played; this should usually be GameCard.Move.TRASH ("graveyard" in MtG terms)

### Visual cards

Visual cards are visual_card scenes controlled by [visual_card.gd](res://scripts/combat/visual_card.gd). Each needs an `index_in_deck`, `color` (suit) and `id`, and updates its appearance based on the associated GameCard's `img` when an `update_img(_color,_id)` is called on it.
Visual cards are aligned to positions defined by SnapPointX, children of SnapPoints. When a card is attached to a point `p`, it can be accessed through `$SnapPoints.occupied.get(p)`.
Cards in the upper 3 points will be played through [card_holder.gd](res://scripts/combat/card_holder.gd)'s `play_cards()` when the Play button is clicked. This method is also responsible for animating their movement as returned by `play()`.

## PlayerCtl

PlayerCtl is an object that keeps track of one player's game state: equipped cards, health and block, deck, cards and their locations.
Cards are usually represented by their index in the `permanent_deck`; this is why `equipped`, `hand`, `deck_order` etc. are Array[int], and why `play_card()` takes an int.
Since equipped (permanent) cards can change how much damage is taken or what the default attack is, PlayerCtl has helper functions such as `run_equipped(method: String,...)` for applying all equipped cards' modifiers in the priority order (with the `feedback` parameter controlling whether the methods just react to something, or modify the `vec: Vector2i` passed to them), or `player_attack(block:bool,choice:bool)` for executing a default or UI-chosen block/attack ability.

Either side's PlayerCtl can be accessed through the BattleManager node. To deal damage to a PlayerCtl, the opposing side should use BattleManager's `call_as_player("receive_dmg",[dmg],is_enemy)` with its own `is_enemy` attr; do not directly decrease HP outside of special effects.

