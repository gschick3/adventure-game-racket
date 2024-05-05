#lang racket
(require "config.rkt")

; Commands
; help
(define (print-help game-state)
  (begin
    (print-location game-state)
    (print-inventory game-state)
    (displayln "Commands: help, north, south, east, west, location, description, search, inventory, take, fight")
    (displayln "Hint: If you are unable to fight someone, try collecting items from other fights first.")))
; movement
(define (move-player game-state x y)
  (let ([new-player (player-y-update (player-x-update (game-player game-state) (λ (x1) (+ x1 x))) (λ (y1) (+ y1 y)))])
    (if (or (> (abs (player-x new-player)) map-size) (> (abs (player-y new-player)) map-size))
        (begin
          (displayln "Cannot move in this direction.")
          game-state)
        (game-player-set game-state new-player))))
; location
(define (calculate-cell x y) ; calculate the order of the cell (0, 1, 2, ...) based on the 2d coordinate
  (+ x map-size (* (add1 (* map-size 2)) (- map-size y))))
(define (draw-map mapscii map-size game-state)
  (displayln (apply format `(,mapscii ,@(list-set (build-list (expt (add1 (* map-size 2)) 2) (λ (n) " "))
                                                  (calculate-cell (player-x (game-player game-state)) (player-y (game-player game-state)))
                                                  "^"))))
  (displayln "^ - You are here")
  (displayln "1 - The Old Farm")
  (displayln "2 - The Alchemist's Lab")
  (displayln "3 - The Witch Hut - Upper floor")
  (displayln "4 - The Witch Hut - Lower floor"))
(define (print-location game-state)
  (displayln (format "Location: ~a" (location-name (get-current-location game-state))))
  (draw-map ascii-map map-size game-state))
; description
(define (print-description game-state)
  (displayln (location-description (get-current-location game-state))))
; search
(define (print-search game-state)
  (displayln (cond
               [(location-boss (get-current-location game-state)) (format "~a is standing right in front of you, ready to fight." (location-boss (get-current-location game-state)))]
               [(location-item (get-current-location game-state)) (format "~a is on the ground before you." (location-item (get-current-location game-state)))]
               [else "There is nothing here."])))
; inventory
(define (print-inventory game-state)
  (displayln (format "Inventory: ~a"
                     (map ~s (filter identity
                                     (player-inventory (game-player game-state)))))))
; take
(define (take-item game-state)
  (if (and (not (location-boss (get-current-location game-state))) (location-item (get-current-location game-state))) ; can pick up item if boss is defeated and item is present
      (begin
        (displayln (format "You picked up ~a" (location-item (get-current-location game-state))))
        (update-location (game-player-set game-state
                                          (player-inventory-set (game-player game-state)
                                                                (list-set (player-inventory (game-player game-state))
                                                                          (get-location-index game-state (get-current-location game-state))
                                                                          (location-item (get-current-location game-state)))))
                         (location-item-set (get-current-location game-state) #f)))
      (begin
        (displayln "Nothing here.")
        game-state)))
; fight
(define (fight game-state)
  (if (can-fight-boss? game-state)
      (begin
        (displayln (~s (location-boss-quote (get-current-location game-state))))
        (fight-boss game-state))
      (begin
        (displayln "Unable to fight.")
        game-state)))

; Game Loop
(define (play-game game-state)
  (define (loop game-state)
    (if (equal? (count-inventory game-state) (length (player-inventory (game-player game-state)))) ; Win condition
        (displayln "You win!")
        (loop (begin
                (display "> ")
                (case (normalize-string (read-line))
                  [("help") (begin (print-help game-state) game-state)]
                  [("north" "up") (move-player game-state 0 1)]
                  [("south" "down") (move-player game-state 0 -1)]
                  [("east" "right") (move-player game-state 1 0)]
                  [("west" "left") (move-player game-state -1 0)]
                  [("location" "whereami") (begin (print-location game-state) game-state)]
                  [("description") (begin (print-description game-state) game-state)]
                  [("search" "look") (begin (print-search game-state) game-state)]
                  [("inventory" "pack") (begin (print-inventory game-state)) game-state]
                  [("take" "pick up") (take-item game-state)]
                  [("fight" "attack") (fight game-state)]
                  [else game-state])))))
  (begin
    (displayln "You have been wandering for days, returning to the kingdom that you once called home. Now, it is nothing but a wasteland, ruled by a dark king holding the crown hostage.")
    (displayln "You've heard of the strange creatures that now inhabit these lands. They feed on knowledge and are known for playing cruel games with those who come too close.")
    (displayln "Defeat the King and secure the Crown. The future of the kingdom rests on you.")
    (displayln "Here is a map to help you out:")
    (print-help game-state)
    (displayln "Type 'help' at any time to review this page")
    (loop game-state)))

; Location
(define (location-matches? state x-func y-func)
  (λ (loc) (and (equal? (x-func state) (location-x loc)) (equal? (y-func state) (location-y loc)))))
; grab location information for the cell that the player is currently on
(define (get-current-location game-state)
  (let ([filtered (filter (location-matches? (game-player game-state) player-x player-y) (game-map game-state))])
    (if (empty? filtered)
        (empty-location (player-x (game-player game-state)) (player-y (game-player game-state)))
        (first filtered))))
; get the index of a location by x and y values
(define (get-location-index game-state location)
  (index-of (game-map game-state) location (λ (a b) ((location-matches? a location-x location-y) b))))
; replace the current location with an updated location
(define (update-location game-state new-location)
  (game-map-set game-state
                (list-set (game-map game-state)
                          (get-location-index game-state new-location)
                          new-location)))

; Inventory
; count the number of items in the inventory
(define (count-inventory game-state)
  (foldl (λ (x total) (if x (add1 total) total)) 0 (player-inventory (game-player game-state))))

; Boss fights
; returns true if boss hasn't been defeated and player has the correct inventory items
(define (can-fight-boss? game-state)
  (let ([current-location (get-current-location game-state)])
    (and (location-boss current-location)
         (>= (count-inventory game-state) (location-required current-location)))))

(define (defeat-boss game-state)
  (let ([current-location (get-current-location game-state)])
    (update-location game-state (location-boss-set current-location #f))))

; Asks every riddle at current location, only returning true if each is answered correctly
(define (fight-boss game-state)
  (define (loop riddles)
    (or (empty? riddles)
        (and (begin (displayln (riddle-q (first riddles))) (string-ci=? (riddle-a (first riddles)) (normalize-string (read-line))))
             (loop (drop riddles 1)))))
  (if (loop (location-riddles (get-current-location game-state)))
      (begin
        (displayln (format "You have defeated ~a" (location-boss (get-current-location game-state))))
        (defeat-boss game-state))
      (begin
        (displayln "You lost. Try again.")
        game-state)))

; Helper function
(define (normalize-string s)
  (string-normalize-spaces (string-downcase s)))

; Start game
(play-game game-start)