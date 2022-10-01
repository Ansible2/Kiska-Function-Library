using System.Text;

namespace SpeechRecognition
{
    internal class InputOutputHandler
    {
        private readonly Functions functions = null;
        /* ----------------------------------------------------------------------------
		    Constructor
	    ---------------------------------------------------------------------------- */
        internal InputOutputHandler()
        {
            functions = new Functions();
        }

        /* ----------------------------------------------------------------------------
		    OnGameStart
	    ---------------------------------------------------------------------------- */
        internal void OnGameStart(ExtensionCall extensionCall)
        {
            extensionCall.outputBuilder.Append("Test-Extension v1.0");
            Logger.Write("Game Start...");
        }

        /* ----------------------------------------------------------------------------
		    OnExtensionCalled
	    ---------------------------------------------------------------------------- */
        internal void OnExtensionCalled(ExtensionCall extensionCall)
        {
            functions.CallFunction(extensionCall);
        }

        /* ----------------------------------------------------------------------------
		    OnExtensionCalledWithArgs
	    ---------------------------------------------------------------------------- */
        internal void OnExtensionCalledWithArgs(ExtensionCall extensionCall)
        {
            functions.CallFunction(extensionCall);
        }

        /* ----------------------------------------------------------------------------
		    InvokeCallBack
	    ---------------------------------------------------------------------------- */
        internal void InvokeCallBack(string functionName, StringBuilder data = null)
        {
            if (data == null)
            {
                InvokeCallBack(functionName,"EMPTY");
                return;
            }

            InvokeCallBack(functionName, data.ToString());
        }
        internal void InvokeCallBack(string functionName, string data)
        {
            if (data == "")
            {
                data = "EMPTY";
            }

            ArmaExtension.callbackFunction("KISKA_SpeechRecognition", functionName, data);
        }
    }
}
