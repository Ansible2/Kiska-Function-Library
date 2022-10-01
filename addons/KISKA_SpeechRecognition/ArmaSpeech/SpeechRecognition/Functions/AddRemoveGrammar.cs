using System.Text.RegularExpressions;

namespace SpeechRecognition
{
    internal partial class Functions
    {
        private string AddGrammar(ExtensionCall input)
        {
            if (
                input == null ||
                input.argCount < 2
            )
            {
                return "false";
            }

            Logger.Write($"AddGrammar: {input.args[0]}");
            Logger.Write($"AddGrammar: {input.args[1]}");
            ArmaExtension.speechRecognizer.AddGrammarFromXmlString(input.args[0], input.args[1]);
            return "true";
        }
    }
}
