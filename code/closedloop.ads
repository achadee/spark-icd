with Measures;
with HRM;
with ImpulseGenerator;
with Heart;

--# inherit Measures,
--#         HRM,
--#         ImpulseGenerator,
--#         Heart;  

-- This package defines a very simple and crude simulation of a heart.
--  The default behaviour is for the heart to speed up, unless it
--  receives a small shock, in which case it will slow down, or a
--  large shock, in which case it will cease working
package ClosedLoop is

   -- A type representing a heart
   type ClosedLoopType is
      record
	 -- The heart rate for the patient
   Monitor: HRM.HRMType;
	Hrt : Heart.HeartType;
   IsOn : Boolean;
      end record;

   procedure Tick(Sys : in out ClosedLoopType);
   --# derives Sys from Sys;

end ClosedLoop;
