extends Node

enum colors_enum {RED, BLUE, GREEN, YELLOW, PURPLE}

var colors_array = [["#ea323c", "#891e2b"], ["#0098dc", "#00396d"], ["#5ac54f", "#1e6f50"], ["#ffc825", "#ffa214"], ["#93388f", "#3b1443"]]

var coils = [[], [], [], [], []]

var levels = [false, false, false, false, false, false, false, false, false, false]

var current_level : int = 0

var unlit_bulbs = 999
