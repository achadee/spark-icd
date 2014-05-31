with RandomNumber;
with Heart;

package body ImpulseGenerator is
   
   procedure Init(Generator : out GeneratorType) is
   begin
      Generator.IsOn := False;
      Generator.Impulse := Measures.Joules'First;
   end Init;
   
   procedure On(Generator : in out GeneratorType) is
   begin
      Generator.IsOn := True;
   end On;
      
   procedure Off(Generator : in out GeneratorType) is
   begin
      Generator.IsOn := False;
   end Off;
   
   function IsOn(Generator : in GeneratorType) return Boolean is
   begin
      return Generator.IsOn;
   end IsOn;
   
   procedure SetImpulse(Generator : in out GeneratorType; 
			J : in Measures.Joules) is
   begin
      -- Only set the impulse if the machine is on
      if Generator.IsOn then
	 Generator.Impulse := J;
      end if;
   end SetImpulse;
   
   procedure Tick(Generator : in GeneratorType; 
		  Hrt : in out Heart.HeartType) is
      HrtVariable : Heart.HeartType;
   begin
      -- Administer the impulse if the generator is on
      if Generator.IsOn then
	 -- For an 'out' variable, we must create a new variable for
	 --  the call, and the copy the output value from
	 --  Heart.SetImpulse back to Ptnt
	 HrtVariable := Hrt;
	 Heart.SetImpulse(HrtVariable, Generator.Impulse);
	 Hrt := HrtVariable;
      end if;
   end Tick;
   
end ImpulseGenerator;
