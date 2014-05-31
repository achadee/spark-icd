with Measures; 
with Heart;

-- This package simulates a simple impulse generator for an ICD. It is
--  provided with an amount to discharge, and provides this amount to
--  a heart in the next 'tick'.
--# inherit Measures,
--#         RandomNumber,
--#         Heart;
package ImpulseGenerator is
   
   -- The generator type
   type GeneratorType is
      record
	 -- The current impulse; to be administered to the heart at
	 --  the next clock tick
	 Impulse : Measures.Joules;  
   
	 -- Indicates whether the generator has been turned on.
	 IsOn : Boolean;
      end record;
   
   -- Create and initialise a new generator.
   procedure Init(Generator : out GeneratorType);
   --# derives Generator from ;
   --# post Generator.IsOn = False and Generator.Impulse = 0;
   
   -- Turn on the generator, but do not administer any impulse yet.
   procedure On(Generator : in out GeneratorType);
   --# derives Generator from Generator;
   --# post Generator.IsOn;
   
   -- Turn off the generator;
   procedure Off(Generator : in out GeneratorType);
   --# derives Generator from Generator;
   --# post not Generator.IsOn;
   
   -- Query the status of the generator (on/off)
   function IsOn(Generator : in GeneratorType) return Boolean;
   --# return Generator.IsOn;
   
   -- Set the impulse to be administered
   procedure SetImpulse(Generator : in out GeneratorType; 
			J : in Measures.Joules);
   --# derives Generator from Generator, J;
   --# post (Generator.IsOn -> Generator.Impulse = J) and
   --#      (not Generator.IsOn -> Generator = Generator~);
   
   -- Tick the clock, providing an impulse to the heart.
   procedure Tick(Generator : in GeneratorType; 
		  Hrt : in out Heart.HeartType);
   --# derives Hrt from Generator, Hrt;
   --# post not Generator.IsOn -> Hrt = Hrt~;
   
end ImpulseGenerator;

