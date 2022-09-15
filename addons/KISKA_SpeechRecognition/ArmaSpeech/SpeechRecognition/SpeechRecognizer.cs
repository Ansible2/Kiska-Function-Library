using System;
using System.Collections.Generic;
using System.Globalization;
using System.IO;
using System.Linq;
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
        }

        internal void AddGrammarFromXmlString(string xml)
        {
            Grammar grammar = GetGrammar(xml);
            grammarDictionary[""] = grammar; // TODO get ID for grammar
            speechRecognitionEngine.LoadGrammar(grammar);
        }

        internal void StartRecording()
        {
            // TODO implement start recording
        }

        internal void StopRecording()
        {
            // TODO implement stop recording
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
    }
}
