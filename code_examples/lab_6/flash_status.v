wire   timeout   = data_from_flash[4];
assign status_ok = ( r_data == w_data )
assign error     = ~status_ok && timeout;