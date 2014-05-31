with Measures;
with HRM;
with ImpulseGenerator;
with Heart;
with Icd;

--# inherit Measures,
--#         HRM,
--#         ImpulseGenerator,
--#         Heart,
--#         Icd;  

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
         Shock: ImpulseGenerator.GeneratorType;
         Hrt : Heart.HeartType;
         Comp: Icd.IcdType; 
         IsOn : Boolean;
      end record;

   procedure Tick(Sys : in out ClosedLoopType);
   --# derives Sys from Sys;

   procedure Off(Sys : in out ClosedLoopType);
   --# derives Sys from Sys;
   --#      post Sys.Comp.IsOn = False and
   --#           Sys.Monitor.isOn = False and
   --#           Sys.Shock.isOn = False;

   procedure On(Sys : in out ClosedLoopType);
   --# derives Sys from Sys;
   --#      post Sys.Comp.IsOn = True and
   --#           Sys.Monitor.isOn = True and
   --#           Sys.Shock.isOn = True;

end ClosedLoop;
