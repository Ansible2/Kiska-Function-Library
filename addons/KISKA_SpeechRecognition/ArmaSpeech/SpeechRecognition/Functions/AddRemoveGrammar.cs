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

            ArmaExtension.speechRecognizer.AddGrammarFromXmlString(input.args[0], input.args[1]);
            return "true";
        }
    }
}
