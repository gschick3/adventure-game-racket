# adventure-game-racket
## Overview
### Setting
The player is dropped into a kingdom of 25 grid squares, consisting of 5 structures and 20 blanks. The lore is explained a little bit at the start of the game. The players is required to visit the different locations, answer the "riddles", and collect the items that the entities drop.
### Locations
#### The Witch Hut
The Witch hut consists of 2 floors, acting like 2 separate buildings. The first floor hosts the Rabbit and the second floor hosts the Turtle. The first floor of the Witch hut is the only place the player can fight with no items. The second floor requires a single item to be acquired.
#### The Alchemist's Lab
The Alchemist's Lab sees the Rabbit returning. To defeat the Rabbit at this location, you must have already defeated the Rabbit in the Witch Hut.
#### The Old Farm
The Old Farm is where the King stays. To defeat the King, one must collect the 3 items in from the above locations and answer the "riddles" he gives.
#### The Feast Hall
The Feast Hall hosts the Wizard. Initially, you are given the option of fighting the Wizard, but once you collect all the items, the Wizard reveals himself to be on your side, simply welcoming you back to the Kingdom.
### Inventory Items
#### Magic Recipes
Dropped by the Rabbit in the Witch Hut, this item is required to fight in the Alchemist's Lab and the upper floor of the Witch Hut
#### Protection Potion
The Turtle drops this, which doesn't grant any more power on its own. Paired with the Golden Fleece, the player is able to fight the King.
#### Golden Fleece
The Rabbit drops this when fought in the Alchemist's Lab. Paired with the Protection Potion, the player is able to fight the King.
#### King's Tombstone
The King drops this when defeated. By claiming it, the player is then able to confront the Wizard.
#### The Crown
Once the Wizard is confronted, he reveals himself to be your ally and gives you the Crown. Once picked up, the game has ended and the player has won.
### Goal
The goal of the game is to save the Kingdom by defeating the King and confronting the Wizard. This requires the player to fight with other entities by answering "riddles" correctly.
## Running the Game
The main file already has a function call to the game loop, passing in the `game-state` configuration from `config.rkt`
## Sources
* My noggin
* Racket Docs
## Notes
After answering a few of the "riddles", it becomes obvious that this is a sort of abstraction and refinement based on my classes from this semester. The enemy names, locations, and items are all interpretations of the instructors, buildings, and concepts I have been experiencing. Some are more obvious than others.
