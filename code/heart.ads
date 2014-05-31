with Measures;
with RandomNumber;

-- This package defines a very simple and crude simulation of a heart.
--  The default behaviour is for the heart to speed up, unless it
--  receives a small shock, in which case it will slow down, or a
--  large shock, in which case it will cease working
--# inherit Measures,
--#         RandomNumber;
package Heart
  --# own DefaultChange : Measures.BPM;
  --# initializes DefaultChange;
is

   -- A type representing a heart
   type HeartType is
      record
	 -- The heart rate for the patient
	 Rate : Measures.BPM;
	 
	 -- The impulse to be administered in the next tick
	 Impulse : Measures.Joules;
	 
      end record;
   
   -- Initialise the heart, setting a heart rate from a normal
   -- probability distribution.
   procedure Init(Hrt : out HeartType);
   --# global out DefaultChange;
   --# derives Hrt, DefaultChange from ;
   --# post Hrt.Impulse = 0 and 
   --#      Measures.BPM'First <= Hrt.Rate and 
   --#      Hrt.Rate <= Measures.BPM'Last and
   --#      DefaultChange = 1;
   
   -- Set the amount of joules to be administered at the next clock tick.
   -- This should only be called by the impulse generator.
   procedure SetImpulse(Hrt : in out HeartType; Joules : in Measures.Joules);
   --# derives Hrt from Hrt, Joules;
   --# post Hrt.Impulse = Joules;
   
   -- Read the amount of joules to be administered at the next clock tick.
   function GetImpulse(Hrt : in HeartType) return Measures.Joules;
   --# return Hrt.Impulse;
   
   -- Access the heart's real BPM.
   -- This should only be called by the HRM.
   procedure GetRate(Hrt : in HeartType;
		     Rate : out Measures.BPM);
   --# derives Rate from Hrt;
   --# post Rate = Hrt.Rate;
   
   -- Tick the clock, providing an impulse to the heart.
   procedure Tick(Hrt : in out HeartType);
   --# global in out DefaultChange;
   --# derives Hrt from Hrt, DefaultChange & 
   --#         DefaultChange from DefaultChange, Hrt;
   
private
   -- The amount to add to the heart rate to simulate rising rate
   DefaultChange : Measures.BPM := 1;
   
end Heart;

