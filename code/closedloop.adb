with Measures;
with HRM;
with ImpulseGenerator;
with Heart;
with Icd;

-- This package defines a very simple and crude simulation of a heart.
--  The default behaviour is for the heart to speed up, unless it
--  receives a small shock, in which case it will slow down, or a
--  large shock, in which case it will cease working
package body ClosedLoop is
   -- Create objects init objects
   -- I create it in here to hide it from ClosedLoopExample
   -- TODO move to ads as record
   -- Initialise the system, setting a heart rate from a normal
   -- probability distribution.

   procedure On(Sys: in out ClosedLoopType) is
   begin
      Icd.On(Sys.Comp);
      HRM.On(Sys.Monitor,Sys.Hrt);
      ImpulseGenerator.On(Sys.Shock);
      Sys.isOn := True;
   end On;


   procedure Off(Sys: in out ClosedLoopType) is
   begin
      Icd.Off(Sys.Comp);
      HRM.Off(Sys.Monitor);
      ImpulseGenerator.Off(Sys.Shock);
      Sys.isOn := False;
   end Off;

   
   procedure Init(Sys: in out ClosedLoopType) is
   begin
      HRM.Init(Sys.Monitor);
      ImpulseGenerator.Init(Sys.Shock);
      Icd.Init(Sys.Comp);
   end Init;

   -- Tick the system, providing an impulse to the heart.
   procedure Tick(Sys : in out ClosedLoopType) is
   begin
         -- if the computer is on, tick through the entire system
         if Sys.Comp.isOn and Sys.isOn and Sys.Monitor.isOn and Sys.Shock.isOn then
            HRM.Tick(Sys.Monitor,Sys.Hrt);
            ICD.Tick(Sys.Comp, Sys.Monitor, Sys.Shock);
            ImpulseGenerator.Tick(Sys.Shock, Sys.Hrt);
         end if;
   end Tick;

end ClosedLoop;