using System;
using System.Collections.Generic;
using System.Collections.ObjectModel;
using System.Globalization;
using System.IO;
using System.Speech.Recognition;
using System.Speech.Recognition.SrgsGrammar;
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
                Logger.Write($"Recognized Audio: {eventArgs.Result.Text}");
				ReadOnlyCollection<RecognizedWordUnit> recognizedWords = eventArgs.Result.Words;
				
				int count = 0;
				List<string> wordsList = new List<string>(recognizedWords.Count);
				foreach(RecognizedWordUnit word in recognizedWords)
				{
                    wordsList.Add(word.Text.ToLower());
                    Logger.Write($"Recognized word number: {++count} is {word.Text}");	
				}

				string completeWordList = String.Join(",",wordsList);
				ArmaExtension.inputOutputHandler.InvokeCallBack(SpeechRecognized,$"[{completeWordList}]");
            }

			public static void LoadedGrammarEvent(object sender,LoadGrammarCompletedEventArgs eventArgs)
			{
				string name = eventArgs.Grammar.Name;
				if (name == null)
				{
					name = "null name";
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
            // AddGrammarFromXmlString(callForFireGrammarXml);
            AddGrammarFromXmlString("cities",cityGrammarXml);
        }

        internal void AddGrammarFromXmlString(string name, string xml)
        {
			try
			{
				Grammar grammar = GetGrammar(xml);
				grammar.Name = name;

				grammarDictionary[name] = grammar; // TODO get ID for grammar
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
			// TODO: see about parsing xml in srgs doc first so that variables can be added/modified later by scripters
            using (var stream = GenerateStreamFromString(xml))
            {
                Grammar grammar = new Grammar(stream);
                return grammar;
            }
        }

        const string callForFireGrammarXml = @"<grammar version=""1.0"" xml:lang=""en-US"" root=""supportCall""
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
		const string cityGrammarXml = @"
			<grammar version=""1.0"" xml:lang=""en-US"" mode=""voice"" root=""location""
			 xmlns=""http://www.w3.org/2001/06/grammar"" tag-format=""semantics/1.0"">

			  <rule id=""location""> 
				<item> Fly me to </item>
				<ruleref uri=""#city""/> 
			  </rule>

			  <rule id=""city"">
				<one-of>
				  <item> Boston </item>
				  <item> Madrid </item>
				</one-of>
			  </rule>

			</grammar>
		";
    }
}
