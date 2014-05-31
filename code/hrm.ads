with Measures;
with Heart;

-- This package simulates a heart rate monitor. It is provided with a
--  HeartType record, and must read the heart rate from this. Some
--  random error is introduced into the readings..
--# inherit Measures,
--#         RandomNumber,
--#         Heart;
package HRM is
   
   -- The record type for a heart rate monitor
   type HRMType is
      record
	 -- The measure heart rate for the heart
	 Rate : Measures.BPM;
	 
	 IsOn : Boolean;  -- Indicates whether the HRM is on.
      end record;
   
   -- Create and initialise a HRM.
   procedure Init(Monitor : out HRMType);
   --# derives Monitor from ;
   --# post Monitor.IsOn = False and 
   --#      Monitor.Rate = Measures.BPM'First;
   
   -- Turn on the HRM and get a first reading from the heart.
   procedure On(Monitor : out HRMType; Hrt : in Heart.HeartType);
   --# derives Monitor from Hrt;
   --# post Monitor.IsOn;
      
   -- Turn off the HRM.
   procedure Off(Monitor : in out HRMType);
   --# derives Monitor from Monitor;
   --# post not Monitor.IsOn;
   
   -- Get the status of the HRM (on/off)
   function IsOn(Monitor : in HRMType) return Boolean;
   --# return Monitor.IsOn;
   
   -- Access the *measured* heart rate
   procedure GetRate(Monitor : in HRMType;
		     Rate : out Measures.BPM);
   --# derives Rate from Monitor;
   --# post (Monitor.IsOn -> Rate = Monitor.Rate)
   --#      and
   --#      (not Monitor.IsOn -> Rate = Measures.BPM'First);
      
   -- Tick the clock, reading the heart rate from the heart
   procedure Tick(Monitor : in out HRMType; Hrt : in Heart.HeartType);
   --# derives Monitor from Monitor, Hrt;
   --# post not Monitor.IsOn -> 
   --#      (Monitor.Rate = Measures.BPM'First);
   
end HRM;
