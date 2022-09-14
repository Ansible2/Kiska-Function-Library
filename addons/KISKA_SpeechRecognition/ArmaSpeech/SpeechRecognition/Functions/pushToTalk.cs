using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;

namespace SpeechRecognition.Functions
{
    internal static partial class Functions
    {
        private static bool pushToTalkIsPressed = false;
        private static void PushToTalkPressed()
        {
            pushToTalkIsPressed = true;
        }
        private static void PushToTalkReleased()
        {
            pushToTalkIsPressed = false;
        }
    }
}
