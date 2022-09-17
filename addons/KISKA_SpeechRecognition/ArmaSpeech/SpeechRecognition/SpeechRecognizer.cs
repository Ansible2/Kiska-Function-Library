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
		private static class Events
		{
			public const string StartedRecording = "KISKA_ext_sr_events_startedrecording";
			public const string StoppedRecording = "KISKA_ext_sr_events_stoppedrecording";
			public const string SpeechRecognized = "KISKA_ext_sr_events_speechrecognized";
			public const string LoadedGrammar = "KISKA_ext_sr_events_loadedgrammar";

            // Handle the SpeechRecognized event.  
            public static void SpeechRecognizedEvent(object sender, SpeechRecognizedEventArgs eventArgs)
            {
                // eventArgs.Result.Words.
                // eventArgs.Result.Grammar
                // TODO: implement
                // TODO: add the ability to attach custom event id to an output?
                Logger.Write($"Recognized Audio: {eventArgs.Result.Text}");
                ArmaExtension.inputOutputHandler.InvokeCallBack(SpeechRecognized, eventArgs.Result.Text);
            }

			public static void LoadedGrammarEvent(object sender,LoadGrammarCompletedEventArgs eventArgs)
			{
				string name = eventArgs.Grammar.Name;
				if (name == null)
				{
					name = "null";
				}
                Logger.Write($"Loaded grammar: {name}");
				ArmaExtension.inputOutputHandler.InvokeCallBack(LoadedGrammar, name);
			}
        }


        private readonly Dictionary<string,Grammar> grammarDictionary;
        private readonly SpeechRecognitionEngine speechRecognitionEngine = null;
        public SpeechRecognizer() {
            grammarDictionary = new Dictionary<string,Grammar>();

            CultureInfo culture = new CultureInfo(CultureInfo.CurrentCulture.Name); // en-US for .Name for example
            speechRecognitionEngine = new SpeechRecognitionEngine(culture);

            // Add a handler for the speech recognized event.  
            speechRecognitionEngine.SpeechRecognized +=
              new EventHandler<SpeechRecognizedEventArgs>(Events.SpeechRecognizedEvent);

			speechRecognitionEngine.LoadGrammarCompleted += 
				new EventHandler<LoadGrammarCompletedEventArgs>(Events.LoadedGrammarEvent);

            // TODO: Remove with implement of custom grammars
            AddGrammarFromXmlString(testGrammarXml);
        }

        internal void AddGrammarFromXmlString(string xml)
        {
			try
			{
				Grammar grammar = GetGrammar(xml);
				grammarDictionary["testGrammar"] = grammar; // TODO get ID for grammar
				speechRecognitionEngine.LoadGrammarAsync(grammar);
			} 
			catch (ArgumentNullException ex)	
			{
                Logger.Write("ArgumentNullException"); // TODO: Better message
            }
            catch (InvalidOperationException ex)
            {
                Logger.Write("InvalidOperationException"); // TODO: Better Message
            }
            catch (OperationCanceledException)
			{
                Logger.Write("OperationCanceledException"); // TODO: Better message
            }
        }


        internal void StartRecording()
        {
            // TODO implement start recording

			// Configure input to the speech recognizer.  
            speechRecognitionEngine.SetInputToDefaultAudioDevice();
			
            // Start asynchronous, continuous speech recognition.  
            speechRecognitionEngine.RecognizeAsync(RecognizeMode.Single);
            Logger.Write("Started recording");
            ArmaExtension.inputOutputHandler.InvokeCallBack(Events.StartedRecording);
        }

        internal void StopRecording()
        {

            // TODO implement stop recording
            Logger.Write("Manually Ended recording");
			speechRecognitionEngine.RecognizeAsyncCancel();
            ArmaExtension.inputOutputHandler.InvokeCallBack(Events.StoppedRecording);
        }

        private static MemoryStream GenerateStreamFromString(string xml)
        {
            return new MemoryStream(Encoding.UTF8.GetBytes(xml ?? ""));
        }

        private Grammar GetGrammar(string xml)
        {
            using (var stream = GenerateStreamFromString(xml))
            {
                Grammar grammar = new Grammar(stream,"Test Grammar");
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
		const string testGrammarXml2 = @"<!-- Grammar file ""cityList.grxml"" -->\r\n<?xml version=""1.0"" encoding=""utf-8""?>\r\n<grammar version=""1.0"" xml:lang=""en-US"" mode=""voice"" root=""location""\r\n xmlns=""http://www.w3.org/2001/06/grammar"" tag-format=""semantics/1.0"">\r\n\r\n  <rule id=""location""> \r\n    <item> Fly me to <\\item>\r\n    <ruleref uri=""#city""/> \r\n  </rule>\r\n\r\n  <rule id=""city"">\r\n    <one-of>\r\n      <item> Boston </item>\r\n      <item> Madrid </item>\r\n    </one-of>\r\n  </rule>\r\n\r\n</grammar>";
    }
}
