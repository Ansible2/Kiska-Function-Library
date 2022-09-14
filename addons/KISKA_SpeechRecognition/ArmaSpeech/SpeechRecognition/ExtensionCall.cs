using System.Text;
using static SpeechRecognition.ArmaExtension;

namespace SpeechRecognition
{
    internal class ExtensionCall
    {
        public readonly StringBuilder outputBuilder = null;
        public readonly int outputSizeLimit = 0;
        public readonly string functionToRun = "";
        public readonly ExtensionCallback callbackFunction = null;
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
            string functionToRun, 
            ExtensionCallback callbackFunction
        )
        {
            this.outputBuilder = outputBuilder;
            this.outputSizeLimit = outputSizeLimit;
            this.functionToRun = functionToRun;
            this.callbackFunction = callbackFunction;
        }

        public ExtensionCall(
            StringBuilder outputBuilder,
            int outputSizeLimit,
            string functionToRun, 
            ExtensionCallback callbackFunction,
            string[] args,
            int argCount
        )
        {
            this.outputBuilder = outputBuilder;
            this.outputSizeLimit = outputSizeLimit;
            this.functionToRun = functionToRun;
            this.callbackFunction = callbackFunction;
            this.args = args;
            this.argCount = argCount;
        }
    }
}
