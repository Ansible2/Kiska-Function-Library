class CfgPatches
{
	class Kiska_SpeechRecognition
	{
		units[]={};
		weapons[]={};
		requiredVersion=0.1;
		requiredAddons[]={
			"cba_main",
			"KISKA_Functions"
		};
	};
};

class CfgFunctions
{
	class KISKA
	{
		class SpeechRecognition
		{
			file="KISKA_SpeechRecognition\SQF Functions";
			class SR_callExtension
			{};
			class SR_startRecording 
			{};
		};
	};
};
