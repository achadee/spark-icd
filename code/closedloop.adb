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

   procedure Off(Sys: in out ClosedLoopType) is
   begin
      Icd.Off(Sys.Comp);
      HRM.Off(Sys.Monitor);
      ImpulseGenerator.Off(Sys.Shock);
   end Off;

   procedure On(Sys: in out ClosedLoopType) is
   begin
      Icd.On(Sys.Comp);
      HRM.On(Sys.Monitor,Sys.Hrt);
      ImpulseGenerator.On(Sys.Shock);
   end On;

   -- Tick the system, providing an impulse to the heart.
   procedure Tick(Sys : in out ClosedLoopType) is
   begin
      for I in Integer range 0..100 loop
         if Sys.Monitor.IsOn then
            HRM.Tick(Sys.Monitor,Sys.Hrt);
         end if;
      end loop;
   end Tick;

end ClosedLoop;