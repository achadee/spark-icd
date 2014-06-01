with Measures;
with HRM;
with ImpulseGenerator;

--# inherit Measures,
--#         RandomNumber,
--#         HRM,
--#         ImpulseGenerator;      
package ICD is

   type ICDStates is (normal, fib, tar);

   ProjectedRate : constant Integer := 15;
   MaxShocks : constant Integer := 10;

   TarShock : constant Integer := 2;
   FibShock : constant Integer := 30;


   -- The record type for a heart rate monitor
   type ICDType is
      record
	 -- The measure heart rate for the heart
	   Rate : Measures.BPM;
      InProcess : Boolean;
      IsOn : Boolean;

      
      state : ICDStates;

      -- ICD settings
      UpperBound : Measures.BPM;
      Count : Integer; -- impulse count
      Next : Integer;
      TickCount : Integer; 

      ticksToReEnableDetectionAgain : integer;

      heartRateHistory1 : Measures.BPM;
      heartRateHistory2 : Measures.BPM;
      heartRateHistory3 : Measures.BPM;
      heartRateHistory4 : Measures.BPM;
      heartRateHistory5 : Measures.BPM;
      heartRateHistory6 : Measures.BPM;

      history_avarage : Integer;
      history_variance : Integer;
      end record;

   procedure Init(Computer : out ICDType);
   --# derives Computer from ;
   --#      post Computer.InProcess = False
   --#     and Computer.IsOn = False
   --#     and Computer.Next = 600 / (Computer.UpperBound + ProjectedRate)       
   --#     and Computer.history_avarage = 0
   --#     and Computer.history_variance = 0
   --#     and Computer.state = normal
   --#     and Computer.UpperBound = 130
   --#     and Computer.TickCount = 0
   --#     and Computer.Count = 0
   --#     and Computer.Rate = Measures.BPM'First
   --#     and Computer.heartRateHistory1 = Measures.BPM'First
   --#     and Computer.heartRateHistory2 = Measures.BPM'First
   --#     and Computer.heartRateHistory3 = Measures.BPM'First
   --#     and Computer.heartRateHistory4 = Measures.BPM'First
   --#     and Computer.heartRateHistory5 = Measures.BPM'First
   --#     and Computer.heartRateHistory6 = Measures.BPM'First
   --#     and Computer.ticksToReEnableDetectionAgain = 6;
   
   procedure Tick(Computer : in out ICDType; HeartRateMonitor : in HRM.HRMType; Shock : in out ImpulseGenerator.GeneratorType);
   --# derives Computer from Computer, HeartRateMonitor, Shock & Shock from Computer, Shock, HeartRateMonitor;
   --#      post not Computer.IsOn -> 
   --#      (Computer.Rate = Measures.BPM'First);

   procedure On(Computer : in out ICDType);
   --# derives Computer from Computer;
   --#      post Computer.IsOn = True;

   procedure Off(Computer : in out ICDType);
   --# derives Computer from Computer;
   --#      post Computer.IsOn = False;

   procedure addRateToHistory(Computer : in out ICDType);
   --# derives Computer from Computer;
   --# post Computer.heartRateHistory1 = Computer~.heartRateHistory2
   --#   and Computer.heartRateHistory2 = Computer~.heartRateHistory3
   --#   and Computer.heartRateHistory3 = Computer~.heartRateHistory4
   --#   and Computer.heartRateHistory4 = Computer~.heartRateHistory5
   --#   and Computer.heartRateHistory5 = Computer~.heartRateHistory6
   --#   and Computer.heartRateHistory6 = Computer.rate;

   procedure CalculateAvarage(Computer : in out ICDType);
   --# derives Computer from Computer;
   --# post Computer.history_avarage = (Computer.heartRateHistory1+Computer.heartRateHistory2+Computer.heartRateHistory3+Computer.heartRateHistory4+Computer.heartRateHistory5+Computer.heartRateHistory6)/6;
   
   function power(num : in Integer) return Integer;
   --# pre num'size > 0;
   --# return num*num;

   function secureAdd(num1 : in Integer; num2 : in Integer) return Integer;
   --# pre num1'size > 0 and num2'size > 0;
   --# return num1+num2;

   procedure CalculateVariance(Computer : in out ICDType);
   --# derives Computer from Computer;

   procedure Detect_Fibrillation(Computer : in out ICDType);
   --# derives Computer from Computer;
   --# pre Computer.IsOn = True;
   --# post (Computer.state = fib <-> (Computer~.state /= fib and Computer.heartRateHistory1 /= -1 and Computer.ticksToReEnableDetectionAgain = 0 and Computer.history_variance > 100));


   procedure Detect_Tarchycardia(Computer : in out ICDType);
   --# derives Computer from Computer;


   procedure Set_Impulse(Computer : in out ICDType; Shock: in out ImpulseGenerator.GeneratorType);
   --# derives Computer from Computer, Shock & Shock from Computer, Shock;

   
end ICD;
