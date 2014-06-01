with Measures;
with HRM;
with ImpulseGenerator;
with Ada.Text_IO;

package body ICD is

   NoShock : constant Measures.Joules := 0;

   procedure Off(Computer: in out ICDType) is
   begin
      Computer.IsOn := False;
   end Off;

   procedure On(Computer: in out ICDType) is
   begin
      Computer.IsOn := True;
   end On;

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
          Set_Next(Computer);
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

   procedure Set_Next(Computer : in out ICDType) is
   begin
      if Computer.state = tar and Computer.Count > 0 and Computer.InProcess then
         Computer.Next := Integer(Float'Floor (600.0 / (Float(Computer.UpperBound) + ProjectedRate)));
      end if;
   end Set_Next;

   procedure Set_Impulse(Computer : in out ICDType; Shock: in out ImpulseGenerator.GeneratorType) is
   begin
      -- self contained set impulse
      --Ada.Text_IO.Put_Line(Integer'Image(Computer.TickCount));
      if Computer.state = fib and Shock.IsOn then
         --Ada.Text_IO.Put_Line("BIG SHOCK");
         ImpulseGenerator.SetImpulse(Shock, FibShock);
      elsif Computer.state = tar and Computer.InProcess and Computer.count > 0 
            and Computer.TickCount = 0 and Shock.IsOn then
         Ada.Text_IO.Put_Line("SHOCK");
         ImpulseGenerator.SetImpulse(Shock, TarShock);
         Computer.count := Computer.count - 1;
         Computer.TickCount := Computer.Next;

      elsif Computer.state = normal then
         ImpulseGenerator.SetImpulse(Shock, 0);
      end if;
   end Set_Impulse;

   procedure Init(Computer : in out ICDType) is
   begin
        --Computer.IsTar := False;
        --COmputer.IsFib := False;

        Computer.state := normal;

        Computer.UpperBound := 130;
        Computer.TickCount := 0;
        Computer.Count := 0;

        Computer.Rate := Measures.BPM'First;
        for I in Index loop
          Computer.heartRateHistory(I) := -1;
        end loop;
        Computer.ticksToReEnableDetectionAgain := Computer.heartRateHistory'length;
   end Init;

   procedure addRateToHistory(Computer : in out ICDType) is
      lastIndex : constant Integer := Computer.heartRateHistory'last;
   begin
      for I in Integer range 1 .. lastIndex - 1 loop
        Computer.heartRateHistory(I) := Computer.heartRateHistory (I+1);
      end loop;
      --Put the new value
      Computer.heartRateHistory (lastIndex) := Computer.rate;
   end addRateToHistory;

   procedure Detect_Fibrillation(Computer : in out ICDType) is
   currentHistory : History;
   temp : Integer;
   begin

      ---Calculate the avarage-----------------
      currentHistory := Computer.heartRateHistory;
      Computer.history_avarage := 0;
      for I in Index loop
      Computer.history_avarage := Computer.history_avarage + currentHistory (I);
      end loop;
      Computer.history_avarage := Computer.history_avarage / currentHistory'length;
      ---end calculating the average-----------
      ---Calculate Variance--------------------
      Computer.history_variance := 0;
      for I in Index loop
      temp := Computer.history_avarage - Computer.heartRateHistory(I);
      Computer.history_variance := temp * temp + Computer.history_variance;
      end loop;
      Computer.history_variance := Computer.history_variance / currentHistory'length;
      ---End Calculating the variance----------
      if Computer.state = fib then
        --Ada.Text_IO.Put_Line("fib is true");
        Computer.state := normal;
        Computer.ticksToReEnableDetectionAgain := 7;
      else
       if currentHistory (1) = -1 or 
            Computer.ticksToReEnableDetectionAgain > 0 then
            --Ada.Text_IO.Put_Line("fib nodetect");
            Computer.ticksToReEnableDetectionAgain := 
            Computer.ticksToReEnableDetectionAgain - 1;
       else
            If Computer.history_variance > 3000 then
              --Ada.Text_IO.Put_Line(".");
              Computer.state := fib;
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
