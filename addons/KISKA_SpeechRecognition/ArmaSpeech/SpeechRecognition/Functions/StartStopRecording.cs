namespace SpeechRecognition
{
    internal partial class Functions
    {
        private bool recording = false;
        private void StartRecording(ExtensionCall input)
        {
            ArmaExtension.speechRecognizer.StartRecording();

            ArmaExtension.inputOutputHandler.InvokeCallBack("kiska_ext_sr_startrecording"); // TODO: figure out return startegy
            recording = true;
        }
        private void StopRecording()
        {
            ArmaExtension.speechRecognizer.StopRecording();
            recording = false;
        }
    }
}
