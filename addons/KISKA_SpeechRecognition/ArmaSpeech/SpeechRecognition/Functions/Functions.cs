using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;

namespace SpeechRecognition.Functions
{
    internal static partial class Functions
    {
        public static void CallFunction(ExtensionCall input)
        {
            switch (input.functionToRun)
            {
                case "PTTDOWN":
                {
                    PushToTalkPressed();
                    break;
                }
                case "PTTUP":
                {
                    PushToTalkReleased();
                    break;
                }
                default:
                {
                    HandleDefault(input);
                    break;
                }
            }
        }

        private static void HandleDefault(ExtensionCall input)
        {
            input.outputBuilder.Append("ERROR-:[Could not find function to run]");
        }
    }
}
