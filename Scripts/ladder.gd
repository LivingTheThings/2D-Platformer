#world pos
#local
#map/cell pos

extends TileMapLayer

var count :int = 0

func _on_ladder_on_player(pos) -> bool:  #pos is player.global_position
	var local_pos = to_local(pos) 
	var cell_pos = local_to_map(local_pos) 
	var data = get_cell_tile_data(cell_pos)
	
	if data == null:
		return false
	
	return data.get_custom_data('type') == 'ladder'
	
func touched_spike(pos) -> bool:  #pos is player.global_position
	var local_pos = to_local(pos) 
	var cell_pos = local_to_map(local_pos) 
	var data = get_cell_tile_data(cell_pos)
	
	if data == null:
		return false
	
	return data.get_custom_data('spike')
		


	
