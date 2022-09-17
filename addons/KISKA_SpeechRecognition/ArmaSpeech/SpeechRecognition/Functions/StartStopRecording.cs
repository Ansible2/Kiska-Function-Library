namespace SpeechRecognition
{
    internal partial class Functions
    {
        private bool recording = false;
        private string StartRecording(ExtensionCall input)
        {
            ArmaExtension.speechRecognizer.StartRecording();
            recording = true;

            return "true";
        }
        private string StopRecording()
        {
            ArmaExtension.speechRecognizer.StopRecording();
            recording = false;

            return "false";
        }
    }
}
