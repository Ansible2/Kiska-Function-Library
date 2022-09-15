namespace SpeechRecognition
{
    internal partial class Functions
    {
        public void CallFunction(ExtensionCall input)
        {
            switch (input.functionToRun.ToLower())
            {
                case "kiska_ext_sr_startrecording":
                {
                    StartRecording(input);
                    break;
                }
                case "kiska_ext_sr_stoprecording":
                {
                    StopRecording();
                    break;
                }
                default:
                {
                    HandleDefault(input);
                    break;
                }
            }
        }

        private void HandleDefault(ExtensionCall input)
        {
            input.outputBuilder.Append($"ERROR-:{input.functionToRun} was not a function to run");
        }
    }
}
