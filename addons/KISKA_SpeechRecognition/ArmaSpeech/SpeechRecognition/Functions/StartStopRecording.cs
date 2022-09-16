namespace SpeechRecognition
{
    internal partial class Functions
    {
        private bool recording = false;
        private void StartRecording(ExtensionCall input)
        {
            ArmaExtension.speechRecognizer.StartRecording();
            recording = true;
        }
        private void StopRecording()
        {
            ArmaExtension.speechRecognizer.StopRecording();
            recording = false;
        }
    }
}
