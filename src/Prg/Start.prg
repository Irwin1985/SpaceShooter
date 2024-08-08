USING System.Windows.Forms
USING System.Drawing

[STAThreadAttribute];
FUNCTION Start( asCmdLine AS STRING[] ) AS INT
	
	LOCAL nExitCode := 0 AS INT
	LOCAL oForm AS BasicForm
	
	Application.EnableVisualStyles()
	Application.DoEvents()
	
	oForm := BasicForm{}
	Application.Run(oForm)

RETURN nExitCode

