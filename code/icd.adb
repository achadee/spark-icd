with Measures;
with HRM;
with ImpulseGenerator;

package body ICD is

   NoShock : constant Measures.Joules := 0;

   procedure Off(Computer: in out ICDType) is
   begin
      Computer.IsOn := False;
   end Off;

   procedure On(Computer: in out ICDType) is
   begin
      Computer.IsOn := False;
   end On;

   procedure Tick(Computer : in out ICDType; HeartRateMonitor : in HRM.HRMType) is
   begin
      if Computer.IsOn then
      --ICD.addRateToHistory(Computer);
    -- read the heart rate from the HRM
       HRM.GetRate(HeartRateMonitor, Computer.Rate);
      else
    -- If the Computer is not on, return 0 for both values
       Computer.Rate := Measures.BPM'First;
      end if;
   end Tick;

   procedure Detect_Tarchycardia(Computer : in out ICDType) is
   begin
       -- if the icd is on and the rate is above the upperbound
       -- and a Tarchycardia has not been detected
       if Computer.IsOn and Computer.Rate > Computer.UpperBound 
       and Computer.IsTar = False then
          -- something bad is about to happen!
          -- so start a treatment
          Computer.IsTar := True;
       end if;
   end Detect_Tarchycardia;

   procedure Set_Next(Computer : in out ICDType) is
   begin
      if Computer.IsTar and Computer.Count < MaxShocks then
         Computer.Next := Computer.Rate + Integer(Float'Floor (600.0 / (Float(Computer.UpperBound) + ProjectedRate)));
      end if;
   end Set_Next;

   procedure Set_Impulse(Computer : in ICDType; Shock: in out ImpulseGenerator.GeneratorType) is
   begin
      if Computer.isFib and Shock.IsOn then
         ImpulseGenerator.SetImpulse(Shock, FibShock);
      elsif Computer.IsTar and Computer.count < MaxShocks 
            and Computer.Rate = Computer.Next and Shock.IsOn then
         ImpulseGenerator.SetImpulse(Shock, TarShock);
      end if;
   end Set_Impulse;

   procedure Init(Computer : in out ICDType) is
   begin
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
      Computer.isFib := False;
      Computer.history_avarage := 0;
      for I in Index loop
      Computer.history_avarage := Computer.history_avarage + currentHistory (I);
      end loop;
      Computer.history_avarage := Computer.history_avarage / currentHistory'length;
      ---end calculating the average-----------
      ---Calculate Variance--------------------
      for I in Index loop
      temp := Computer.history_avarage - currentHistory (I);
      Computer.history_variance := temp * temp + Computer.history_variance;
      end loop;
      Computer.history_variance := Computer.history_variance / currentHistory'length;
      ---End Calculating the variance----------

    If Computer.history_variance > 20 then
      Computer.isFib := true;
    end if;

    if currentHistory (1) = -1 or 
      Computer.ticksToReEnableDetectionAgain > 0 then

      Computer.ticksToReEnableDetectionAgain := 
        Computer.ticksToReEnableDetectionAgain - 1;
      Computer.isFib := false;
    end if;

   end Detect_Fibrillation;

end ICD;
