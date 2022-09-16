using System;
using System.Collections.Generic;
using System.Globalization;
using System.IO;
using System.Speech.Recognition;
using System.Text;

namespace SpeechRecognition
{
    internal class SpeechRecognizer
    {
        private readonly Dictionary<string,Grammar> grammarDictionary;

        private readonly SpeechRecognitionEngine speechRecognitionEngine = null;
        public SpeechRecognizer() {
            grammarDictionary = new Dictionary<string,Grammar>();

            CultureInfo culture = new CultureInfo(CultureInfo.CurrentCulture.Name); // en-US for .Name for example
            speechRecognitionEngine = new SpeechRecognitionEngine(culture);

			// TODO: Remove with implement of custom grammars
			AddGrammarFromXmlString(testGrammarXml2);
        }

        internal void AddGrammarFromXmlString(string xml)
        {
            Grammar grammar = GetGrammar(xml);
            grammarDictionary["testGrammar"] = grammar; // TODO get ID for grammar
            speechRecognitionEngine.LoadGrammarAsync(grammar);
        }

        // Handle the SpeechRecognized event.  
        static void SpeechRecognizedEvent(object sender, SpeechRecognizedEventArgs eventArgs)
        {
			// eventArgs.Result.Words.
			// eventArgs.Result.Grammar
			// TODO: implement
			// TODO: add the ability to attach custom event id to an output?
			// Console.WriteLine("Recognized text: " + e.Result.Text);
			ArmaExtension.inputOutputHandler.InvokeCallBack("KISKA_ext_sr_speechRecognizedEvent", eventArgs.Result.Text);
        }

        internal void StartRecording()
        {
            // TODO implement start recording
            

			// Configure input to the speech recognizer.  
            speechRecognitionEngine.SetInputToDefaultAudioDevice();

            // Add a handler for the speech recognized event.  
            speechRecognitionEngine.SpeechRecognized +=
              new EventHandler<SpeechRecognizedEventArgs>(SpeechRecognizedEvent);
			
            // Start asynchronous, continuous speech recognition.  
            speechRecognitionEngine.RecognizeAsync(RecognizeMode.Single);
        }

        internal void StopRecording()
        {
            // TODO implement stop recording
			speechRecognitionEngine.RecognizeAsyncCancel();
        }

        private static MemoryStream GenerateStreamFromString(string xml)
        {
            return new MemoryStream(Encoding.UTF8.GetBytes(xml ?? ""));
        }

        private Grammar GetGrammar(string xml)
        {
            using (var stream = GenerateStreamFromString(xml))
            {
                Grammar grammar = new Grammar(stream);
                return grammar;
            }
        }

        const string testGrammarXml = @"<grammar version=""1.0"" xml:lang=""en-US"" root=""supportCall""
 xmlns=""http://www.w3.org/2001/06/grammar"">

	<!--<rule id=""callForFire"">
		<ruleref uri=""#playAction"" />
		<item> the </item>
		<ruleref uri=""#fileWords"" />
	</rule>-->
	<rule id=""supportCall"">
		<one-of>
			<item>
				<ruleref uri=""#callForFire"" />
			</item>
		</one-of>
	</rule>

	<rule id=""callForFire"">
		<ruleref uri=""#supportId"" />
		<ruleref uri=""#preceedCallSign"" />
		<ruleref uri=""#observerId"" />
		<ruleref uri=""#mission"" />
		<ruleref uri=""#gridCoordinates"" />
	</rule>
	
	<rule id=""supportId"">
		<one-of>
			<item> raider 95 </item>
		</one-of>
	</rule>
	
	<rule id=""preceedCallSign"">
		<one-of>
			<item> this is </item>
			<item> </item>
		</one-of>
	</rule>
	
	<rule id=""observerId"">
		<one-of>
			<item> granit 25 </item>
		</one-of>
	</rule>

	<rule id=""gridCoordinates"">
		grid 
		<item repeat=""6-8"">
			<ruleref uri=""#number""/>
		</item>
	</rule>
	
	<rule id=""number"">
		<one-of>
			<item>0</item>
			<item>1</item>
			<item>2</item>
			<item>3</item>
			<item>4</item>
			<item>5</item>
			<item>6</item>
			<item>7</item>
			<item>8</item>
			<item>9</item>
		</one-of>
	</rule>

	<rule id=""mission"">
		<one-of>
			<item> fire for effect </item>
			<item> adjust fire </item>
		</one-of>
	</rule>

</grammar>";
		const string testGrammarXml2 = "<!-- Grammar file \"cityList.grxml\" -->\r\n<?xml version=\"1.0\" encoding=\"utf-8\"?>\r\n<grammar version=\"1.0\" xml:lang=\"en-US\" mode=\"voice\" root=\"location\"\r\n xmlns=\"http://www.w3.org/2001/06/grammar\" tag-format=\"semantics/1.0\">\r\n\r\n  <rule id=\"location\"> \r\n    <item> Fly me to <\\item>\r\n    <ruleref uri=\"#city\"/> \r\n  </rule>\r\n\r\n  <rule id=\"city\">\r\n    <one-of>\r\n      <item> Boston </item>\r\n      <item> Madrid </item>\r\n    </one-of>\r\n  </rule>\r\n\r\n</grammar>";
    }
}
