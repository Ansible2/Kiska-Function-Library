namespace SpeechRecognition
{
    internal partial class Functions
    {
        private static class Names
        {
            public const string StartRecording = "kiska_ext_sr_startrecording";
            public const string StopRecording = "kiska_ext_sr_stoprecording";
        }

        public void CallFunction(ExtensionCall input)
        {
            string output = "false";
            switch (input.functionToRun.ToLower())
            {
                case Names.StartRecording:
                {
                    output = StartRecording(input);
                    break;
                }
                case Names.StopRecording:
                {
                    output = StopRecording();
                    break;
                }
                default:
                {
                    HandleDefault(input);
                    return;
                }
            }

            input.outputBuilder.Append(output);
        }

        private void HandleDefault(ExtensionCall input)
        {
            input.outputBuilder.Append($"ERROR-:{input.functionToRun} was not a function to run");
        }
    }
}
