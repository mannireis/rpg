# Battle system

## Cards

Logical cards are instances of [GameCard](res://scripts/combat/game_card.gd).
Each implements methods for different actions, and should have at least a play(ctl: PlayerCtl, _enemy_ctl:PlayerCtl) method defined.
They are addressed by suits (numerically sorted by the `GameCard.S` enum: spades, clubs, hearts, diamonds, jokers and other cards) and ID.

To create a new card, add it to the [CardDatabase](res://scripts/globals/card_database.gd) using the `GameCard.create(suit: S, id: int, can_atk: Able, atk: Vector2i,...)` constructor into the `db[suit][id]` 2D array. 
Each card should also have an `img` attr set with the `img_texture` parameter.
Then, in _ready(), set all its relevant methods to callables. For a `can_atk != Able.NONE`, a `weapon_atk() -> Vector2i` should be set, returning a `Vector2i(damage,damage_type)`. Negative damage grants block for that particular damage type.

Each `play()` method returns an Array for future extensions.
For now only the first element matters. It's always GameCard.Move and says where the card should go after being played; this should usually be GameCard.Move.TRASH ("graveyard" in MtG terms)

Visual cards are visual_card scenes controlled by [visual_card.gd](res://scripts/combat/visual_card.gd). Each needs an `index_in_deck`, `color` (suit) and `id`, and updates its appearance based on the associated GameCard's `img` when an `update_img(_color,_id)` is called on it
