using System.Text.RegularExpressions;

namespace SpeechRecognition
{
    internal partial class FunctionService
    {
        private string AddGrammar(ExtensionCall extensionCall)
        {
            if (
                extensionCall == null ||
                extensionCall.argCount < 2
            )
            {
                return "false";
            }

            // the strings sent from arma are improperly formatted for use externally
            // several quotation marks must be removed
            string startAndEndQuotesPattern = "(^\"|\"$)";
            string substitution = "";
            Regex regex = new Regex(startAndEndQuotesPattern);
            string xmlString = regex.Replace(extensionCall.args[1], substitution);
            
            string doubleQuoteSub = "\"";
            string doubleQuotesPattern = "\"\"";
            regex = new Regex(doubleQuotesPattern);
            xmlString = regex.Replace(xmlString, doubleQuoteSub);

            string grammarName = extensionCall.args[0];
            Logger.Write($"AddGrammar: Grammar name is {grammarName}");
            Logger.Write($"AddGrammar: xml is:\n\n {xmlString}");
            // TODO: get a better return here (for example if the grammar already exists)
            ArmaExtension.speechRecognizer.AddGrammarFromXmlString(grammarName, xmlString);
            return "true";
        }
    }
}
