extends Node

var player: PlayerEntity:
    set(v):
        player = v
        on_player_chanegd.emit()
        
signal on_player_chanegd
