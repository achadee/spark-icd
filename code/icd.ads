with Measures;
with HRM;
with ImpulseGenerator;

--# inherit Measures,
--#         RandomNumber,
--#         HRM,
--#         ImpulseGenerator;      
package ICD is
   
   ProjectedRate : constant Float := 15.0;
   MaxShocks : constant Integer := 10;

   -- The record type for a heart rate monitor
   type ICDType is
      record
	 -- The measure heart rate for the heart
	   Rate : Measures.BPM;
      InProcess : Boolean;
      IsOn : Boolean;

      IsFib : Boolean;
      IsTar : Boolean;

      -- ICD settings
      UpperBound : Measures.BPM;
      Count : Integer;
      Next : Integer;

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

   procedure Init(Computer : in out ICDType);
   --# derives Computer from Computer;
   --#      post Computer.Rate = Measures.BPM'First;

   procedure Detect_Fibrillation(Computer : in out ICDType);
   --# derives Computer from Computer;

   procedure Detect_Tarchycardia(Computer : in out ICDType);
   --# derives Computer from Computer;

   procedure Set_Next_Impulse(Computer : in out ICDType);
   --# derives Computer from Computer;

end ICD;
