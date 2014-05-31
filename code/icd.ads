with Measures;
with HRM;
with ImpulseGenerator;

--# inherit Measures,
--#         RandomNumber,
--#         HRM,
--#         ImpulseGenerator;      
package ICD is
   
   -- The record type for a heart rate monitor
   type ICDType is
      record
	 -- The measure heart rate for the heart
	   Rate : Measures.BPM;
      InProcess : Boolean;
      IsOn : Boolean;

      end record;

   procedure Tick(Computer : in out ICDType; HeartRateMonitor : in HRM.HRMType);
   --# derives Computer from Computer, HeartRateMonitor;
   --#      post not Computer.IsOn -> 
   --#      (Computer.Rate = Measures.BPM'First);

   procedure Off(Computer : in out ICDType);
   --# derives Computer from Computer;
   --#      post Computer.IsOn = False;

   procedure On(Computer : in out ICDType);
   --# derives Computer from Computer;
   --#      post Computer.IsOn = True;

end ICD;
