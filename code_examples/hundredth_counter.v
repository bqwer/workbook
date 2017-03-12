//регистр счётчика
reg [3:0] hundredth_counter;

//описание компаратора
wire tenth_of_second_passed = 
       ((hundredths_counter == "4’d9") &
         hundredths_of_second_passed);

//описание счётчика
always @(posedge clk or posedge reset) begin
   if (reset) hundredths_counter <= 0; 
       //асинхронный сброс
   
   //"сигнал разрешения работы счётчика"
   else if (hundredth_of_second_passed) 
       
       //синхронный сброс
       if (tenth_of_second_passed) 
              hundredths_counter <= 0;
       
       //"увеличение счётчика на единицу"
       else hundredths_counter <= 
              hundredths_counter + 1;
end;
