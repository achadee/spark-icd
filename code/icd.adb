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
    -- read the heart rate from the HRM
       HRM.GetRate(HeartRateMonitor, Computer.Rate);
      else
    -- If the Computer is not on, return 0 for both values
       Computer.Rate := Measures.BPM'First;
      end if;
   end Tick;

   procedure Detect_Fibrillation(Computer : in out ICDType) is
   begin
       Computer.isFib := True;
   end Detect_Fibrillation;

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

   procedure Set_Next_Impulse(Computer : in out ICDType) is
   begin
      if Computer.IsTar and Computer.Count < MaxShocks then
         Computer.Next := Computer.Rate + Integer(Float'Floor (600.0 / (Float(Computer.UpperBound) + ProjectedRate)));
      end if;
   end Set_Next_Impulse;

   procedure Init(Computer : in out ICDType) is
   begin
        Computer.Rate := Measures.BPM'First;
   end Init;
end ICD;
