with Heart;
with RandomNumber; 

package body HRM is
   
   Error : constant Float := 0.02;  -- The error margin of the pump readings
   
   procedure Init(Monitor : out HRMType) is
   begin
      Monitor.IsOn := False;
      Monitor.Rate := Measures.BPM'First;
   end Init;

   procedure On(Monitor : out HRMType; Hrt : in Heart.HeartType) is
   begin
     -- Get an initial reading for the heart
      Monitor.IsOn := True;
      Heart.GetRate(Hrt, Monitor.Rate);
   end On;
      
   procedure Off(Monitor : in out HRMType) is
   begin
      Monitor.IsOn := False;
   end Off;
   
   function IsOn(Monitor : in HRMType) return Boolean is
   begin
      return Monitor.IsOn;
   end IsOn;
   
   procedure GetRate(Monitor : in HRMType;
		     Rate : out Measures.BPM) is
   begin
      if Monitor.IsOn then
	 Rate := Monitor.Rate;
      else
	 Rate := Measures.BPM'First;
      end if;
   end GetRate;
   
   procedure Tick(Monitor : in out HRMType; Hrt : in Heart.HeartType) is
   begin
      if Monitor.IsOn then
	 -- read the heart rate from the heart
	 Heart.GetRate(Hrt, Monitor.Rate);
	 
	 -- Insert some random variation
	 Monitor.Rate := 
	   Measures.LimitBPM(RandomNumber.UniformIntegerWithError(Monitor.Rate, 
								  Error));
      else
	 -- If the monitor is not on, return 0 for both values
	 Monitor.Rate := Measures.BPM'First;
      end if; 
      
   end Tick;
end HRM;
