Set oWS = WScript.CreateObject(WScript.Shell) 
sLinkFile = C:\Users\Gaurav Calidig\Desktop\MyApp.lnk 
Set oLink = oWS.CreateShortcut(sLinkFile) 
oLink.TargetPath = C:\MyApp\MyApp.bat 
oLink.WorkingDirectory = C:\MyApp 
oLink.Description = "My Application" 
oLink.IconLocation = C:\MyApp\MyApp48.bmp 
oLink.Save 
