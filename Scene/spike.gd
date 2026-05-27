extends TileMapLayer

func touched_spike(pos) -> bool:  #pos is player.global_position
	var local_pos = to_local(pos) 
	var cell_pos = local_to_map(local_pos) 
	var data = get_cell_tile_data(cell_pos)
	
	if data == null:
		return false
	
	return data.get_custom_data('spike')
