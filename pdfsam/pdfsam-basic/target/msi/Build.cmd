ECHO OFF
PUSHD "C:\\Users\\Sadaf\\git\\pdfsam\\pdfsam-basic\\target/msi"

SET PDFSAM_VERSION=4.0.1

REM Prevent compiling with outdated pdfsam.wixobj file if there is a error in candle.
del /Q pdfsam.wixobj
del /Q featuresTree.wixobj
del /Q verifyWithLanguageDlg.wixobj
del /Q exitDlg.wixobj
del /Q harvestedFiles.wxs
del /Q harvestedFiles.wixobj

REM harvest the files
"%WIX%bin\heat.exe" dir "C:\\Users\\Sadaf\\git\\pdfsam\\pdfsam-basic\\target/assembled" -ag -cg "AllFiles" -ke -sfrag -srd -sreg -dr APPLICATIONFOLDER -out harvestedFiles.wxs
if %ERRORLEVEL% NEQ 0 goto error
ECHO "Files harvested"

REM Build the MSI
"%WIX%bin\candle.exe" pdfsam.wxs featuresTree.wxs verifyWithLanguageDlg.wxs exitDlg.wxs harvestedFiles.wxs -ext WixUIExtension -ext WixUtilExtension -ext WixNetFxExtension -arch x64
if %ERRORLEVEL% NEQ 0 goto error
ECHO "candle run ok"

REM English
IF EXIST pdfsam.wixobj "%WIX%bin\light.exe" pdfsam.wixobj verifyWithLanguageDlg.wixobj featuresTree.wixobj exitDlg.wixobj harvestedFiles.wixobj -b "C:\\Users\\Sadaf\\git\\pdfsam\\pdfsam-basic\\target/assembled" -ext WixUIExtension -ext WixUtilExtension -ext WixNetFxExtension -spdb -out "C:\\Users\\Sadaf\\git\\pdfsam\\pdfsam-basic\\target/pdfsam-%PDFSAM_VERSION%.msi" -loc "culture.wxl" -cultures:en-us
if %ERRORLEVEL% NEQ 0 goto error
ECHO "MSI created"

REM Cleanup
del /Q pdfsam.wixobj
del /Q featuresTree.wixobj
del /Q verifyWithLanguageDlg.wixobj
del /Q exitDlg.wixobj
del /Q harvestedFiles.wixobj

IF EXIST "C:\\Users\\Sadaf\\git\\pdfsam\\pdfsam-basic\\target/pdfsam-%PDFSAM_VERSION%.msi" "signtool.exe" sign /fd sha256 /tr http://sha256timestamp.ws.symantec.com/sha256/timestamp /a /d "PDFsam Basic" "C:\\Users\\Sadaf\\git\\pdfsam\\pdfsam-basic\\target/pdfsam-%PDFSAM_VERSION%.msi"
if %ERRORLEVEL% NEQ 0 goto error
ECHO "MSI signed"
POPD

:error
set ERROR_CODE=%ERRORLEVEL%
exit /B %ERROR_CODE%

