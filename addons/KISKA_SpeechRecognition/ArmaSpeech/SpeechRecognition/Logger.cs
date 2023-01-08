using System;
using System.IO;
using System.Reflection;

namespace SpeechRecognition
{
    internal static class Logger
    {
        private static string m_exePath = string.Empty;
        private static readonly string fileName = "KISKA_SpeechRecognitionLog.txt";
        public static void Write(string logMessage)
        {
            m_exePath = Path.GetDirectoryName(Assembly.GetExecutingAssembly().Location);
            try
            {
                using (StreamWriter w = File.AppendText(m_exePath + "\\" + fileName))
                {
                    Log(logMessage, w);
                }
            }
            catch (Exception ex)
            {
            }
        }

        private static void Log(string logMessage, TextWriter txtWriter)
        {
            try
            {
                txtWriter.WriteLine("\r\n{0} {1}: {2}", 
                    DateTime.Now.ToLongTimeString(),
                    DateTime.Now.ToLongDateString(), 
                    logMessage
                );
            }
            catch (Exception ex)
            {

            }
        }
    }
}
