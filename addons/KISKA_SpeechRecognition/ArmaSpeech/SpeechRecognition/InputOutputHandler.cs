namespace SpeechRecognition
{
    internal class InputOutputHandler
    {
        public static void OnGameStart(ExtensionCall extensionCall)
        {
            extensionCall.outputBuilder.Append("Test-Extension v1.0");
        }

        public static void OnExtensionCalled(ExtensionCall extensionCall)
        {
            extensionCall.callbackFunction.Invoke("SpeechArgCallback", "someFunction", "data");
            extensionCall.outputBuilder.Append(extensionCall.functionToRun);
        }

        public static void OnExtensionCalledWithArgs(ExtensionCall extensionCall)
        {
            extensionCall.callbackFunction.Invoke("SpeechArgCallback", "someFunction", "data");
            foreach (var arg in extensionCall.args)
            {
                extensionCall.outputBuilder.Append(arg);
            }
        }

        public static void
    }
}
