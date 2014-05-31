with Measures;
with HRM;
with ImpulseGenerator;

package body ICD is

   NoShock : constant Measures.Joules := 0;

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
end ICD;
