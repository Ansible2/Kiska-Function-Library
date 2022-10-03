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

            string startAndEndQuotesPattern = "(^\"|\"$)";
            string substitution = "";
            Regex regex = new Regex(startAndEndQuotesPattern);
            string xmlString = regex.Replace(input.args[1], substitution);
            
            string doubleQuoteSub = "\"";
            string doubleQuotesPattern = "\"\"";
            regex = new Regex(doubleQuotesPattern);
            xmlString = regex.Replace(xmlString, doubleQuoteSub);

            Logger.Write($"AddGrammar: {input.args[0]}");
            Logger.Write($"AddGrammar: {xmlString}");
            ArmaExtension.speechRecognizer.AddGrammarFromXmlString(input.args[0], xmlString);
            return "true";
        }
    }
}
