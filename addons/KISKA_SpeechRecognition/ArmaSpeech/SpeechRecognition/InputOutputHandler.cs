using System.Text;
using static SpeechRecognition.ArmaExtension;

namespace SpeechRecognition
{
    internal class InputOutputHandler
    {
        private readonly ExtensionCallback callbackFunction = null;
        private readonly Functions functions = null;
        /* ----------------------------------------------------------------------------
		    Constructor
	    ---------------------------------------------------------------------------- */
        internal InputOutputHandler(ExtensionCallback callbackFunction)
        {
            this.callbackFunction = callbackFunction;
            functions = new Functions();
        }

        /* ----------------------------------------------------------------------------
		    OnGameStart
	    ---------------------------------------------------------------------------- */
        internal void OnGameStart(ExtensionCall extensionCall)
        {
            extensionCall.outputBuilder.Append("Test-Extension v1.0");
        }

        /* ----------------------------------------------------------------------------
		    OnExtensionCalled
	    ---------------------------------------------------------------------------- */
        internal void OnExtensionCalled(ExtensionCall extensionCall)
        {
            functions.CallFunction(extensionCall);

            //InvokeCallBack("someFunction", "data");
            extensionCall.outputBuilder.Append(extensionCall.functionToRun);
        }

        /* ----------------------------------------------------------------------------
		    OnExtensionCalledWithArgs
	    ---------------------------------------------------------------------------- */
        internal void OnExtensionCalledWithArgs(ExtensionCall extensionCall)
        {
            functions.CallFunction(extensionCall);
            
            //InvokeCallBack("someFunction", "data");
            foreach (var arg in extensionCall.args)
            {
                extensionCall.outputBuilder.Append(arg);
            }
        }

        /* ----------------------------------------------------------------------------
		    InvokeCallBack
	    ---------------------------------------------------------------------------- */
        internal void InvokeCallBack(string functionName, StringBuilder data = null)
        {
            if (data == null)
            {
                InvokeCallBack(functionName,"");
            }

            InvokeCallBack(functionName, data.ToString());
        }
        internal void InvokeCallBack(string functionName, string data)
        {
            callbackFunction("KISKA_SpeechRecognition", functionName, data);
        }
    }
}
