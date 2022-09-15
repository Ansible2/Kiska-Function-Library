using System.Text;

namespace SpeechRecognition
{
    internal class ExtensionCall
    {
        public readonly StringBuilder outputBuilder = null;
        public readonly int outputSizeLimit = 0;
        public readonly string functionToRun = "";
        public readonly int argCount = 0;
        public readonly string[] args = null;

        public ExtensionCall(StringBuilder outputBuilder, int outputSizeLimit)
        {
            this.outputBuilder = outputBuilder;
            this.outputSizeLimit = outputSizeLimit;
        }

        public ExtensionCall(
            StringBuilder outputBuilder, 
            int outputSizeLimit, 
            string functionToRun
        )
        {
            this.outputBuilder = outputBuilder;
            this.outputSizeLimit = outputSizeLimit;
            this.functionToRun = functionToRun;
        }

        public ExtensionCall(
            StringBuilder outputBuilder,
            int outputSizeLimit,
            string functionToRun, 
            string[] args,
            int argCount
        )
        {
            this.outputBuilder = outputBuilder;
            this.outputSizeLimit = outputSizeLimit;
            this.functionToRun = functionToRun;
            this.args = args;
            this.argCount = argCount;
        }
    }
}
