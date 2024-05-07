#lang racket
(require struct-update)
(struct player (x y inventory))
(struct location (x y name description item boss boss-quote required riddles))
(struct game (player map))
(struct riddle (q a))
(define-struct-updaters player)
(define-struct-updaters location)
(define-struct-updaters game)

(define player-start (player 0 0 '(#f #f #f #f #f)))
(define map-start `(,(location -1 2
                               "Old Farm"
                               "Nothing but an old farmhouse and on an empty plot of land. You can see a graveyard in the distance."
                               "King's Tombstone"
                               "The King"
                               "Congratulation on beating the others, but I won't be so easy."
                               3
                               (list (riddle "What port number is used for http?" "80")
                                     (riddle "What language is most commonly used for database queries?" "SQL")
                                     (riddle "What development methodology has strictly ordered phases?" "Waterfall")))
                    ,(location -2 -1
                               "Alchemist's Lab"
                               "Various contraptions are scattered around the lab. It looks like it has been recently used."
                               "Golden Fleece"
                               "The Rabbit"
                               "Hello, again. You may have beaten me before, but I am determined to win this time."
                               1
                               (list (riddle "A monoid requires associativity, identity element, and _________." "closure")
                                     (riddle "What function is used to apply a function to every element of a list?" "map")
                                     (riddle "t/f: Racket uses lazy evaluation by default." "f")))
                    ,(location 1 1
                               "Witch Hut - Upper floor"
                               "Cauldrons line the walls, some empty, some bubbling with mysterious liquids."
                               "Protection Potion"
                               "The Turtle"
                               "I may be slow, but I have had 10 of your lifetimes to prepare for this."
                               1
                               (list (riddle "What is the safer version of the strcpy function in C?" "strncpy")
                                     (riddle "What is the maximum integer value?" "2147483647")
                                     (riddle "What model does Microsoft use for threat modeling?" "STRIDE")))
                    ,(location 1 0
                               "Witch Hut - Lower floor"
                               "It looks like a library. Shelves filled with books surround the room. You smell something strange coming from the floor above."
                               "Magic Recipes"
                               "The Rabbit"
                               "If you want the throne, you have to go through us first."
                               0
                               (list (riddle "What format is Java source code compiled into?" "bytecode")
                                     (riddle "A parse tree is to syntax analysis as an AST is to ________ analysis" "semantic")
                                     (riddle "What link is not used in languages that don't support function nesting? (static/dynamic)" "static")))
                    ,(location 2 -2
                               "Feast Hall"
                               "A wizard sits in the corner, staring out of the window."
                               "The Crown"
                               "The Wizard"
                               "You need not fight me. Welcome back, your highness."
                               4
                               empty)))
(define game-start (game player-start map-start))

(define map-size 2) ; starting at (0, 0), the map only goes 2 blocks in every direction
(define ascii-map " __ __ __ __ __ __ __ __ __ __
|     |  1  |     |     |     |
|__~a__|__~a__|__~a__|__~a__|__~a__|
|     |     |     |  3  |     |
|__~a__|__~a__|__~a__|__~a__|__~a__|
|     |     |     |  4  |     |
|__~a__|__~a__|__~a__|__~a__|__~a__|
|  2  |     |     |     |     |
|__~a__|__~a__|__~a__|__~a__|__~a__|
|     |     |     |     |  5  |
|__~a__|__~a__|__~a__|__~a__|__~a__|") ; map with all potential player locations filled with ~a


(define (empty-location x y)
  (location x y "Outside" "Nothing here." #f #f #f 0 empty))

(provide (all-defined-out))