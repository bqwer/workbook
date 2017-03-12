//регистр счётчика
reg [16:0] pulse_counter;

//описание компаратора
wire hundredth_of_second_passed = 
              (pulse_counter == "17’d259999");

//описание счётчика
always @(posedge clk or posedge reset) begin
   if (reset) pulse_counter <= 0; 
       //асинхронный сброс
   
   //"сигнал разрешения работы счётчика"
   else if (device_running |
              hundredth_of_second_passed)
       
       //синхронный сброс
       if (hundredth_of_second_passed)
              pulse_counter <= 0;
       
       //"увеличение счётчика на единицу"
       else pulse_counter <= pulse_counter + 1;
end;
