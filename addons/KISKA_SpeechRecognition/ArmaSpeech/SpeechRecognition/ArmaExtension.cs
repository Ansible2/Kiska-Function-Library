﻿using System;
using System.Collections.Generic;
using System.Linq;
using System.Runtime.InteropServices;
using System.Text;
using RGiesecke.DllExport;


// TODO: As a user, I want to be able to say words into my microphone
// and have the extension tell arma what I said with an array of words

// trigger voice recording
// end voice recording

// show player what they said in callback

namespace SpeechRecognition
{
    public class ArmaExtension
    {
        public static ExtensionCallback callbackFunction;
        internal static InputOutputHandler inputOutputHandler;
        internal static SpeechRecognizer speechRecognizer;
        private static bool initComplete = false;
        public delegate int ExtensionCallback([MarshalAs(UnmanagedType.LPStr)] string name, [MarshalAs(UnmanagedType.LPStr)] string function, [MarshalAs(UnmanagedType.LPStr)] string data);

#if WIN64
		[DllExport("RVExtensionRegisterCallback", CallingConvention = CallingConvention.Winapi)]
#else
        [DllExport("_RVExtensionRegisterCallback@4", CallingConvention = CallingConvention.Winapi)]
#endif
        public static void RVExtensionRegisterCallback([MarshalAs(UnmanagedType.FunctionPtr)] ExtensionCallback callbackFunction)
        {
            ArmaExtension.callbackFunction = callbackFunction;
        }


        /// <summary>
        /// Gets called when arma starts up and loads all extension.
        /// It's perfect to load in static objects in a seperate thread so that the extension doesn't needs any seperate initalization
        /// </summary>
        /// <param name="output">The string builder object that contains the result of the function</param>
        /// <param name="outputSize">The maximum size of bytes that can be returned</param>
#if WIN64
        [DllExport("RVExtensionVersion", CallingConvention = CallingConvention.Winapi)]
#else
        [DllExport("_RVExtensionVersion@8", CallingConvention = CallingConvention.Winapi)]
#endif
        public static void RvExtensionVersion(StringBuilder output, int outputSize)
        {
            // TODO: this does not seem to actually be running on game start, by initial "callExtension" command
            if (initComplete) return;

            inputOutputHandler = new InputOutputHandler();
            ExtensionCall extensionCall = new ExtensionCall(output, outputSize);
            speechRecognizer = new SpeechRecognizer();
            inputOutputHandler.OnGameStart(extensionCall);
            initComplete = true;
        }


        /// <summary>
        /// The entry point for the default callExtension command.
        /// </summary>
        /// <param name="output">The string builder object that contains the result of the function</param>
        /// <param name="outputSize">The maximum size of bytes that can be returned</param>
        /// <param name="function">The string argument that is used along with callExtension</param>
#if WIN64
        [DllExport("RVExtension", CallingConvention = CallingConvention.Winapi)]
#else
        [DllExport("_RVExtension@12", CallingConvention = CallingConvention.Winapi)]
#endif
        public static void RvExtension(StringBuilder output, int outputSize,
            [MarshalAs(UnmanagedType.LPStr)] string function)
        {
            ExtensionCall extensionCall = new ExtensionCall(output, outputSize, function);
            inputOutputHandler.OnExtensionCalled(extensionCall);
        }


        /// <summary>
        /// The entry point for the callExtensionArgs command.
        /// </summary>
        /// <param name="output">The string builder object that contains the result of the function</param>
        /// <param name="outputSize">The maximum size of bytes that can be returned</param>
        /// <param name="function">The string argument that is used along with callExtension</param>
        /// <param name="args">The args passed to callExtension as a string array</param>
        /// <param name="argsCount">The size of the string array args</param>
        /// <returns>The result code</returns>
#if WIN64
        [DllExport("RVExtensionArgs", CallingConvention = CallingConvention.Winapi)]
#else
        [DllExport("_RVExtensionArgs@20", CallingConvention = CallingConvention.Winapi)]
#endif
        public static int RvExtensionArgs(
            StringBuilder output, 
            int outputSize,
            [MarshalAs(UnmanagedType.LPStr)] string function,
            [MarshalAs(UnmanagedType.LPArray, ArraySubType = UnmanagedType.LPStr, SizeParamIndex = 4)] string[] args, 
            int argCount
        )
        {
            ExtensionCall extensionCall = new ExtensionCall(output, outputSize, function, args, argCount);
            inputOutputHandler.OnExtensionCalledWithArgs(extensionCall);
            return 0;
        }
    }
}
