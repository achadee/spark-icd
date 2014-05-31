with Measures; 
with RandomNumber;

package body Heart is
   
   -- Some boundaries for impulse shocks
   NoShock : constant Measures.Joules := 0;
   SmallShock : constant Measures.Joules := 5;
   
   -- Parameters for generating random heart rate upon initialisation
   HeartRateMu : constant Measures.BPM := 80;
   HeartRateSigma : constant Measures.BPM := 10;
   
   -- Used to simulate volatility of the patient's response to treatment
   Volatility : constant Float := 0.02;
   
   -- A local function to limit Dosage measures
   procedure Init(Hrt : out HeartType) is
   begin
      -- Generate a random systolic pressure
      Hrt.Rate :=
	Measures.LimitBPM(RandomNumber.
			    NormalInteger(HeartRateMu,
					  HeartRateSigma));      
      Hrt.Impulse := 0;
      DefaultChange := 1;
   end Init;
   
   procedure SetImpulse(Hrt : in out HeartType; 
			Joules : in Measures.Joules) is
   begin
      Hrt.Impulse := Joules;
   end SetImpulse;
   
   procedure GetRate(Hrt : in HeartType;
		     Rate : out Measures.BPM) is
   begin
      Rate := Hrt.Rate;
   end GetRate;
   
   function GetImpulse(Hrt : in HeartType) return Measures.Joules is
   begin
      return Hrt.Impulse;
   end GetImpulse;
   
   procedure Tick(Hrt : in out HeartType) is
   begin
      if (Hrt.Impulse = NoShock) then
	 -- No impulse, and the default behaviour of this heart is to increase
	 -- the rate slowly.
	 Hrt.Rate := 
	   Measures.LimitBPM(Hrt.Rate + DefaultChange);
      elsif (Hrt.Impulse < SmallShock) then
	 -- A crude slowing of the heart given a shock
	 Hrt.Rate := Measures.LimitBPM(Hrt.Rate - Hrt.Impulse);
      else -- a large shock
	 Hrt.Rate := 0;
	 DefaultChange := 0;
      end if;
      
      -- Insert some random volatility
      Hrt.Rate := 
	Measures.LimitBPM(RandomNumber.UniformIntegerWithError(Hrt.Rate,
							       Volatility));
      
   end Tick;
   
end Heart;
