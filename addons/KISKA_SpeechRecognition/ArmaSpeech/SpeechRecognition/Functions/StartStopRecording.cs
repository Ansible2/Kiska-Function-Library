namespace SpeechRecognition
{
    internal partial class Functions
    {
        private bool recording = false;
        private string StartRecording(ExtensionCall input)
        {
            if (recording) { return "false"; }

            ArmaExtension.speechRecognizer.StartRecording();
            recording = true;

            return "true";
        }
        private string StopRecording()
        {
            if (!recording) { return "false"; }

            ArmaExtension.speechRecognizer.StopRecording();
            recording = false;

            return "false";
        }
    }
}
