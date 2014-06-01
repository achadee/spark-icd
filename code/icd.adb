with Measures;
with HRM;
with ImpulseGenerator;
--with Ada.Text_IO;

package body ICD is

   NoShock : constant Measures.Joules := 0;

   procedure Init(Computer : out ICDType) is
   begin
        Computer.InProcess := False;
        Computer.IsOn := False;

        Computer.UpperBound := 130;
        Computer.Next := 600 / (Computer.UpperBound + ProjectedRate);
        
        Computer.history_avarage := 0;
        Computer.history_variance := 0;

        Computer.state := normal;

        
        Computer.TickCount := 0;
        Computer.Count := 0;

        Computer.Rate := Measures.BPM'First;
        Computer.heartRateHistory1 := Measures.BPM'First;
        Computer.heartRateHistory2 := Measures.BPM'First;
        Computer.heartRateHistory3 := Measures.BPM'First;
        Computer.heartRateHistory4 := Measures.BPM'First;
        Computer.heartRateHistory5 := Measures.BPM'First;
        Computer.heartRateHistory6 := Measures.BPM'First;
        Computer.ticksToReEnableDetectionAgain := 6;
   end Init;

   procedure On(Computer: in out ICDType) is
   begin
      Computer.IsOn := True;
   end On;

   procedure Off(Computer: in out ICDType) is
   begin
      Computer.IsOn := False;
   end Off;

   procedure addRateToHistory(Computer : in out ICDType) is
   begin
          Computer.heartRateHistory1 := Computer.heartRateHistory2;
          Computer.heartRateHistory2 := Computer.heartRateHistory3;
          Computer.heartRateHistory3 := Computer.heartRateHistory4;
          Computer.heartRateHistory4 := Computer.heartRateHistory5;
          Computer.heartRateHistory5 := Computer.heartRateHistory6;
          Computer.heartRateHistory6 := Computer.rate;
   end addRateToHistory;
   
   procedure Detect_Tarchycardia(Computer : in out ICDType) is
   begin
       -- if the icd is on and the rate is above the upperbound
       -- and a Tarchycardia has not been detected
       -- start a treatment
       if Computer.IsOn and Computer.Rate > Computer.UpperBound 
       and Computer.state = normal then
          Computer.state := tar;
          Computer.Count := MaxShocks;
          Computer.InProcess := True;
          Computer.TickCount := Computer.Next;
       end if;

       -- if the computer is inprocess and the tarch is detected
       -- and the count still has some shocks remaining
       -- keep the process running, else kill it
       if Computer.InProcess and Computer.state = tar and Computer.Count > 0 then
          -- continue process
          Computer.InProcess := True;
          Computer.state := tar;
       else
          Computer.state := normal;
          Computer.InProcess := False;
       end if;
   end Detect_Tarchycardia;

   

   procedure Set_Impulse(Computer : in out ICDType; Shock: in out ImpulseGenerator.GeneratorType) is
   begin
      -- self contained set impulse
      --Ada.Text_IO.Put_Line(Integer'Image(Computer.TickCount));
      if Computer.state = fib and Shock.IsOn then
         --Ada.Text_IO.Put_Line("BIG SHOCK");
         ImpulseGenerator.SetImpulse(Shock, FibShock);
      elsif Computer.state = tar and Computer.InProcess and Computer.count > 0 
            and Computer.TickCount = 0 and Shock.IsOn then
         --Ada.Text_IO.Put_Line("SHOCK");
         ImpulseGenerator.SetImpulse(Shock, TarShock);
         Computer.count := Computer.count - 1;
         Computer.TickCount := Computer.Next;

      elsif Computer.state = normal then
         ImpulseGenerator.SetImpulse(Shock, 0);
      end if;
   end Set_Impulse;

   procedure CalculateAvarage(Computer : in out ICDType) is
   begin

      Computer.history_avarage := (((((Computer.heartRateHistory1 +
                                  Computer.heartRateHistory2) +
                                  Computer.heartRateHistory3) +
                                  Computer.heartRateHistory4) +
                                  Computer.heartRateHistory5) +
                                  Computer.heartRateHistory6)/ 6;

   end CalculateAvarage;

   function power(num : in Integer) return Integer is
   result : Integer;
   begin
      result := Integer'Last;
      if num * num < Integer'Last and num * num > Integer'First then
        result := num * num;
      end if;
      return result;
   end power;

   function secureAdd(num1 : in Integer; num2 : in Integer) return Integer is
   result : Integer;
   begin
      result := Integer'Last;
      if num1 + num2 <= Integer'Last and num1 + num2 >= Integer'First then
        result := num1 + num2;
      end if;
      return result;
    end secureAdd;

   procedure CalculateVariance(Computer : in out ICDType) is
   begin

      ---Calculate Variance--------------------

      Computer.history_variance := 0;
      if (Computer.history_avarage - Computer.heartRateHistory1) <= Integer'Last and
      (Computer.history_avarage - Computer.heartRateHistory1) >= Integer'First and
      (Computer.history_avarage - Computer.heartRateHistory2) <= Integer'Last and
      (Computer.history_avarage - Computer.heartRateHistory2) >= Integer'First and
      (Computer.history_avarage - Computer.heartRateHistory3) <= Integer'Last and
      (Computer.history_avarage - Computer.heartRateHistory3) >= Integer'First and
      (Computer.history_avarage - Computer.heartRateHistory4) <= Integer'Last and
      (Computer.history_avarage - Computer.heartRateHistory4) >= Integer'First and
      (Computer.history_avarage - Computer.heartRateHistory5) <= Integer'Last and
      (Computer.history_avarage - Computer.heartRateHistory5) >= Integer'First and
      (Computer.history_avarage - Computer.heartRateHistory6) <= Integer'Last and
      (Computer.history_avarage - Computer.heartRateHistory6) >= Integer'First then

      Computer.history_variance := (secureAdd(secureAdd(secureAdd(secureAdd(secureAdd(power(Computer.history_avarage - Computer.heartRateHistory1), 
      power(Computer.history_avarage - Computer.heartRateHistory2)), 
      power(Computer.history_avarage - Computer.heartRateHistory3)), 
      power(Computer.history_avarage - Computer.heartRateHistory4)), 
      power(Computer.history_avarage - Computer.heartRateHistory5)), 
      power(Computer.history_avarage - Computer.heartRateHistory6))) / 6;
      end if;
      ---End Calculating the variance----------
   end CalculateVariance;


   procedure Detect_Fibrillation(Computer : in out ICDType) is
   begin

    if Computer.ticksToReEnableDetectionAgain > Integer'First
      if Computer.state = fib then
        --Ada.Text_IO.Put_Line("fib is true");
        Computer.state := normal;
        Computer.ticksToReEnableDetectionAgain := 7;
      else
       if Computer.heartRateHistory1 = -1 or 
            Computer.ticksToReEnableDetectionAgain > 0 then
            --Ada.Text_IO.Put_Line("fib nodetect");
            Computer.ticksToReEnableDetectionAgain := 
            Computer.ticksToReEnableDetectionAgain - 1;
       else
            If Computer.history_variance > 100 then
              --Ada.Text_IO.Put_Line(".");
              Computer.state := fib;
           end if;
       end if; 
    end if;
    end if;
   end Detect_Fibrillation;

   procedure Tick(Computer : in out ICDType; HeartRateMonitor : in HRM.HRMType; Shock : in out ImpulseGenerator.GeneratorType) is
   begin

      if Computer.IsOn then
            
        --Ada.Text_IO.Put_Line("Computer is on");
        -- read the heart rate from the HRM
        HRM.GetRate(HeartRateMonitor, Computer.Rate);
        addRateToHistory(Computer);
        CalculateAvarage(Computer);
        CalculateVariance(Computer);
        Detect_Fibrillation(Computer);
        Detect_Tarchycardia(Computer);
        Set_Impulse(Computer, Shock);
        if Computer.InProcess and Computer.state = tar then
          Computer.TickCount := Computer.TickCount - 1;
        end if;
      else
        --Ada.Text_IO.Put_Line("Computer is off");
      -- If the Computer is not on, return 0 for both values
        Computer.Rate := Measures.BPM'First;
      end if;
   end Tick;

end ICD;
