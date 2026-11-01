# Battle system

## Cards

Logical cards are instances of [GameCard](res://scripts/combat/game_card.gd).
Each implements methods for different actions, and should have at least a `play(ctl: PlayerCtl, _enemy_ctl:PlayerCtl) -> Array` method defined.
They are addressed by suits (numerically sorted by the `GameCard.S` enum: spades, clubs, hearts, diamonds, jokers and other cards) and ID.

To create a new card, add it to the [CardDatabase](res://scripts/globals/card_database.gd) using the `GameCard.create(suit: S, id: int, can_atk: Able, atk: Vector2i,...)` constructor into the `db[suit][id]` 2D array. 
Each card should also have an `img` attr set with the `img_texture` parameter.
Then, in _ready(), set all its relevant methods to callables. For a `can_atk != Able.NONE`, a `weapon_atk() -> Vector2i` should be set, returning a `Vector2i(damage,damage_type)`, by default this just returns the `atk`. Negative damage grants block for that particular damage type.
The `weapon_atk()` method is only used if the card is equipped. This should usually be diamond cards. To make a card equippable, return `[GameCard.Move.EQUIP]` from its `play()`

Each `play()` method returns an Array for future extensions.
For now only the first element matters. It's always GameCard.Move and says where the card should go after being played; this should usually be GameCard.Move.TRASH ("graveyard" in MtG terms)

### Visual cards

Visual cards are visual_card scenes controlled by [visual_card.gd](res://scripts/combat/visual_card.gd). Each needs an `index_in_deck`, `color` (suit) and `id`, and updates its appearance based on the associated GameCard's `img` when an `update_img(_color,_id)` is called on it.
Visual cards are aligned to positions defined by SnapPointX, children of SnapPoints. When a card is attached to a point `p`, it can be accessed through `$SnapPoints.occupied.get(p)`.
Cards in the upper 3 points will be played through [card_holder.gd](res://scripts/combat/card_holder.gd)'s `play_cards()` when the Play button is clicked. This method is also responsible for animating their movement as returned by `play()`.
When a card is trashed after playing, it is added to the `$SnapPoints.hidden_cards` array. From there, it is reused by a [PlayerCtl](res://scripts/combat/game_player_ctl.gd)'s `draw(count,gui)` function if `gui` is set to true.

## PlayerCtl

PlayerCtl is an object that keeps track of one player's game state: equipped cards, health and block, deck, cards and their locations.
Cards are usually represented by their index in the `permanent_deck`; this is why `equipped`, `hand`, `deck_order` etc. are Array[int], and why `play_card()` takes an int.
Since equipped (permanent) cards can change how much damage is taken or what the default attack is, PlayerCtl has helper functions such as `run_equipped(method: String,...)` for applying all equipped cards' modifiers in the priority order (with the `feedback` parameter controlling whether the methods just react to something, or modify the `vec: Vector2i` passed to them), or `player_attack(block:bool,choice:bool)` for executing a default or UI-chosen block/attack ability.

Either side's PlayerCtl can be accessed through the BattleManager node. To deal damage to a PlayerCtl, the opposing side should use BattleManager's `call_as_player("receive_dmg",[dmg],is_enemy)` with its own `is_enemy` attr; do not directly decrease HP outside of special effects.

## Battle inventory

A `Signals.BattleInv` represents all modifications to be done to a side when the battle starts. It's created with a `Signals.BattleInv.create(max_hp: int, input_deck, input_equipped, input_hand, ai_int: int)` call, where all `input_` arguments are an `Array[Vector2i]` of (suit,id). When a BattleInv is passed down to `battle_manager.gd` by being set as the `GameState.player_battle_inventory` or `RoomChangeGlobal.enemy_battle_inventory`, its `.deck` will be loaded as the respective side's deck, the `.starting_equipped` will be automatically equipped and displayed, and the side's hand will always contain cards from `.starting_hand`. An empty `deck` means the deck will be taken from `PlayerCtl.starter_deck()` when the battle starts.

There are also parameters that only affect the enemy and their AI: `ai_int` is currently unused and affects the decisions the NPC makes when choosing cards. `ai_atk_chance` and `ai_block_chance` are floats from 0 to 1 representing the chance to take a default attack (mini sword) or default block (mini shield in player UI) action. `1-(ai_atk_chance+ai_block_chance)` will then be the chance to actually play a card, therefore lowering these numbers makes the NPC more 'powerful'.

## Starting a battle

A battle can be started by emitting `Signals.start_battle(which_inv: int)` while `GameState.speaking_with` is set (while talking with an NPC), usually done by returning /`battle_init*`/ from a dialogue file.
If a NPC has a battle option, it should create a `Signals.BattleInv` object, set `RoomChangeGlobal.enemy_inv_dict[npc_name]` to an array, and append a BattleInv object to that array in its `_ready()`. Adding multiple different BattleInvs allows the NPC to have different loadouts in battles, for example `flicker.gd` having a 'smarter' version at position 1 of the array, which is used when `battle_init_spec` is returned from dialogue. Leaving `enemy_inv_dict[npc_name]` blank will make the battle start with the starter deck and default parameters.

The player's BattleInv is initialised once and stored in `GameState.player_battle_inventory`. All changes to it (for example, purchases in the shop adding cards to your deck) should work with its attributes, e.g. appending to `GameState.player_battle_inventory.deck`.
