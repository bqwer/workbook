wire writing = ((main_state == w1) ||
                (main_state == w2) ||
                (main_state == w3) ||
                (main_state == w4));
                
assign flash_data = writing? w_data : 8'hZZ;
assign flash_noe  = writing? write_noe : read_noe;
assign flash_nce  = (main_state == idle);
assign flash_nwe  = writing? write_nwe : read_nwe;