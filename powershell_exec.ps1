$code = @"
using System;
using System.Collections.Generic;
using System.IO;
using System.Linq;
using System.Net;
using System.Text;
using System.Threading.Tasks;
using Microsoft.Win32;


namespace PersistenceFinder
{
	public class Program
	{

		// CHANGE AS NEEDED
		const bool INCLUDE_KNOWN_DLLS = true;


		private static Dictionary<string, object> GetRegistrySubKeys(RegistryKey regKey, string subKey)
		{
			var valuesBynames = new Dictionary<string, object>();
			using (RegistryKey rootKey = regKey.OpenSubKey(subKey))
			{
				if (rootKey != null)
				{
					string[] valueNames = rootKey.GetValueNames();
					foreach (string currSubKey in valueNames)
					{
						object value = rootKey.GetValue(currSubKey);
						valuesBynames.Add(currSubKey, value);
					}
					rootKey.Close();
				}

			}
			return valuesBynames;
		}

		static void EnumerateKeys(Dictionary<Dictionary<string, object>, string> dicts)
		{
			foreach (var dict in dicts)
			{
				if (dict.Key.Count != 0)
				{
					Console.WriteLine("------------------------------");
					Console.WriteLine("Key: " + dict.Value);
					Console.WriteLine("------------------------------");
				}


				foreach (var item in dict.Key)
				{
					if (dict.Value == @"HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Winlogon\Notify\" || dict.Value == @"HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Winlogon\")
					{
						if (item.Key.Equals("Shell"))
						{
							Console.WriteLine("Key: " + item.Key + "\r\nValue: " + item.Value + "\r\n");
						}
						continue;
					}

					if (dict.Value == @"HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Explorer\User Shell Folders\")
					{
						if (item.Key.Equals("Startup"))
						{
							Console.WriteLine("Key: " + item.Key + "\r\nValue: " + item.Value + "\r\n");

							// Lets enumerate all of the startup items, wherever the Startup folder is set
							try
							{
								DirectoryInfo d = new DirectoryInfo((string)item.Value);
								FileInfo[] Files = d.GetFiles("*.*");
								string fullPath = "";
								foreach (FileInfo file in Files)
								{
									fullPath = (string)item.Value + "\\" + file.Name;
									if (file.Name != "desktop.ini")
									{
										Console.WriteLine(fullPath);
									}
								}
							}
							catch (Exception)
							{
								// do nothing
							}

						}
						continue;
					}

					Console.WriteLine("Key: " + item.Key + "\r\nValue: " + item.Value + "\r\n");
				}

			}
		}

		public static void Main()
		{
			string HostName = Dns.GetHostName();
			string csPath = @"C:\CS\";
			System.IO.Directory.CreateDirectory(csPath);
			using (StreamWriter writer = new StreamWriter(csPath + HostName + "_Persistence_scan.txt"))
			{
				Console.SetOut(writer);
				string[] keysArray = { @"HKEY_CURRENT_USER\SOFTWARE\Microsoft\Windows\CurrentVersion\Run\", @"HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\RunOnce\", @"HKEY_LOCAL_MACHINE\Software\Microsoft\Windows\CurrentVersion\Run\", @"HKEY_LOCAL_MACHINE\Software\Microsoft\Windows\CurrentVersion\RunOnce\", @"HKEY_LOCAL_MACHINE\Software\Microsoft\Windows\CurrentVersion\Policies\Explorer\Run\", @"HKEY_LOCAL_MACHINE\CurrentControlSet\Control\hivelist\", @"HKEY_LOCAL_MACHINE\SYSTEM\ControlSet002\Control\Session\", @"HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Winlogon\", @"HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Winlogon\Notify\", @"HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Explorer\User Shell Folders\", @"HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\services\", @"HKEY_LOCAL_MACHINE\Software\Microsoft\Windows\CurrentVersion\RunServicesOnce\", @"HKEY_LOCAL_MACHINE\Software\Microsoft\Windows\CurrentVersion\RunServices\", @"HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Browser Helper Objects\", @"HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Windows\AppInit_DLLs\" };
				List<string> keys = new List<string>(keysArray);
				Dictionary<Dictionary<string, object>, string> dicts = new Dictionary<Dictionary<string, object>, string>();


				try
				{
					if (INCLUDE_KNOWN_DLLS)
					{
						keys.Add(@"HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Control\Session Manager\KnownDLLs\");
					}

					foreach (var key in keys)
					{
						RegistryKey regKeyType;
						string rootHive = "";
						if (key.StartsWith("HKEY_CURRENT_USER"))
						{
							regKeyType = Registry.CurrentUser;
							rootHive = "HKEY_CURRENT_USER";
						}
						else if (key.StartsWith("HKEY_LOCAL_MACHINE"))
						{
							regKeyType = Registry.LocalMachine;
							rootHive = "HKEY_LOCAL_MACHINE";
						}
						else
						{
							throw new Exception("Root hive not found");
						}

						Dictionary<string, object> keyDict = GetRegistrySubKeys(regKeyType, key.Substring(rootHive.Length + 1, key.Length - rootHive.Length - 1));
						dicts.Add(keyDict, key);
					}

					EnumerateKeys(dicts);



				}
				catch (Exception ex)
				{
					Console.WriteLine("Problemo:" + ex.ToString());
				}

				//Console.ReadLine();
			}
		}
	}
}
"@
 
Add-Type -TypeDefinition $code -Language CSharp	
iex "[PersistenceFinder.Program]::Main()"