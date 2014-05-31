with Ada.Text_IO; use Ada.Text_IO;
with Ada.Integer_Text_IO; use Ada.Integer_Text_IO;

with Measures; use Measures;
with Heart;
with HRM;
with ImpulseGenerator;

-- This procedure demonstrates a simple composition of a heart rate
--  monitor (HRM), heart, and impulse generator.
procedure ManualOperationExample is
   Hrt : Heart.HeartType;                -- The simulated heart
   Monitor : HRM.HRMType;                -- The simulated heart rate monitor
   Generator : ImpulseGenerator.GeneratorType; -- The simulated generator
   HeartRate : BPM;
begin
   -- Initialise the patient and turn the machines on
   Heart.Init(Hrt);
   HRM.Init(Monitor);
   ImpulseGenerator.Init(Generator);
   
   HRM.On(Monitor, Hrt);
   ImpulseGenerator.On(Generator);
   
   -- Set the new impulse to 0
   ImpulseGenerator.SetImpulse(Generator, 0); 

   -- Loop 100 times with no impulse
   for I in Integer range 0..100 loop
      
      -- Read and print the current heart rate
      HRM.GetRate(Monitor, HeartRate);
      Put("Heart rate  = ");
      Put(Item => HeartRate);
      New_Line;
            
      -- Tick all components
      ImpulseGenerator.Tick(Generator, Hrt);
      HRM.Tick(Monitor, Hrt);
      Heart.Tick(Hrt);
      delay 0.1;
   end loop;
   
   -- Turn off the monitor: should return -1.0 for the next readings
   HRM.Off(Monitor);
   
   HRM.GetRate(Monitor, HeartRate);
   ImpulseGenerator.Tick(Generator, Hrt);
   HRM.Tick(Monitor, Hrt);
   Heart.Tick(Hrt);
   
   Put("Heart rate should be -1 = ");
   Put(Item => HeartRate);
   New_Line;
   
   -- Turn the machine back on
   HRM.On(Monitor, Hrt);
   
   -- Ramp up the impulse 
   ImpulseGenerator.SetImpulse(Generator, 4);
   for I in Integer range 0..100 loop
      HRM.GetRate(Monitor, HeartRate);
      
      Put("After turn on = ");
      Put(Item => HeartRate);
      New_Line;     
      
      ImpulseGenerator.Tick(Generator, Hrt);
      HRM.Tick(Monitor, Hrt);
      Heart.Tick(Hrt);
      delay 0.1;
   end loop; 
end ManualOperationExample;
