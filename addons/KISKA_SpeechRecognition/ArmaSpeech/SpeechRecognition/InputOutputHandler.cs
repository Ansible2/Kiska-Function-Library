namespace SpeechRecognition
{
    internal class InputOutputHandler
    {
        public static void OnGameStart(Input input)
        {
            input.outputBuilder.Append("Test-Extension v1.0");
        }

        public static void OnExtensionCalled(Input input)
        {
            input.callbackFunction.Invoke("SpeechArgCallback", "someFunction", "data");
            input.outputBuilder.Append(input.functionToRun);
        }

        public static void OnExtensionCalledWithArgs(Input input)
        {
            input.callbackFunction.Invoke("SpeechArgCallback", "someFunction", "data");
            foreach (var arg in input.args)
            {
                input.outputBuilder.Append(arg);
            }
        }

        public static void
    }
}
