using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using static SpeechRecognition.ArmaExtension;

namespace SpeechRecognition
{
    internal class InputOutputHandler
    {
        public static void onGameStart(
            StringBuilder outputBuilder, 
            int outputSizeLimit, 
            ExtensionCallback callbackFunction = null
        )
        {
            outputBuilder.Append("Test-Extension v1.0");
        }

        public static void onExtensionCalled(
            StringBuilder outputBuilder,
            int outputSizeLimit, 
            string functionToRun, 
            ExtensionCallback callbackFunction
        )
        {
            callbackFunction.Invoke("SpeechArgCallback", "someFunction", "data");
            outputBuilder.Append(functionToRun);
        }
        public static void onExtensionCalledWithArgs(
            StringBuilder outputBuilder, 
            int outputSizeLimit, 
            string functionToRun, 
            string[] args,
            int argCount,
            ExtensionCallback callbackFunction
        )
        {
            callbackFunction.Invoke("SpeechArgCallback", "someFunction", "data");
            foreach (var arg in args)
            {
                outputBuilder.Append(arg);
            }
        }
    }
}
