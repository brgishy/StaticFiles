

## AvaloniaLibs
This is holding the compiled lib files for win-x64 for libHarfBuzzSharp.lib and libSkiaSharp.lib.  I found these lib files thanks to ivanjx on this forum (https://github.com/AvaloniaUI/Avalonia/issues/9503).  When compiling Avalonia for NativeAOT you'll still have dll references if you don't provide NativeLibraries.  I'd prefer to have my apps be single file, so I've written a simple bat file to publish my Avalonia projects as NativeAOT using these lib files.  

If you want to do this, you must add the following to your .csproj 

```
  <ItemGroup>
    <DirectPInvoke Include="libHarfBuzzSharp" />
    <NativeLibrary Include="Native\win-x64\libHarfBuzzSharp.lib" Condition="$(RuntimeIdentifier.StartsWith('win-x64'))" />
    <DirectPInvoke Include="libSkiaSharp" />
    <NativeLibrary Include="Native\win-x64\libSkiaSharp.lib" Condition="$(RuntimeIdentifier.StartsWith('win-x64'))" />
  </ItemGroup>
```

Then if you run the following bat file, it will download the libs from this repository, and publish a NativeAOT version of your app.

```
:: Making sure library files exist, and download if they do not
IF NOT EXIST ".\Native\win-x64" MKDIR ".\Native\win-x64"

IF NOT EXIST .\Native\win-x64\libHarfBuzzSharp.lib ECHO Downloading libHarfBuzzSharp.lib (Approx 105 MB)...
IF NOT EXIST .\Native\win-x64\libHarfBuzzSharp.lib powershell -Command "Invoke-WebRequest https://github.com/brgishy/StaticFiles/raw/main/AvaloniaLibs/win-x64/libHarfBuzzSharp.lib?download= -Outfile .\Native\win-x64\libHarfBuzzSharp.lib"

IF NOT EXIST .\Native\win-x64\libSkiaSharp.lib ECHO Downloading libSkiaSharp.lib (Approx 392 MB)...
IF NOT EXIST .\Native\win-x64\libSkiaSharp.lib powershell -Command "Invoke-WebRequest https://github.com/brgishy/StaticFiles/raw/main/AvaloniaLibs/win-x64/libSkiaSharp.lib?download= -Outfile .\Native\win-x64\libSkiaSharp.lib"

:: Performing the Publish
SET CONFIG=Release
SET RUNTIME=win-x64

dotnet publish ^
  -r %RUNTIME% ^
  -c %CONFIG% ^
  -p:PublishAOT=true ^
  -p:TrimmerDefaultAction=link ^
  -p:InvariantGlobalization=true ^
  -p:IlcGenerateStackTraceData=false ^
  -p:IlcOptimizationPreference=Size ^
  -p:DebugType=none ^
  -p:IlcFoldIdenticalMethodBodies=true ^
  -p:IlcTrimMetadata=true  

:: Moving the compiled exe to the root folder
MOVE .\bin\%CONFIG%\net7.0\%RUNTIME%\publish\*.exe ..
```

## SimpleWebServer
This folder contains the exe SWS.exe, which is the NativeAOT compiled output of this project https://github.com/brgishy/SimpleWebServer (if you want to see the source).  It's a very helpful 16 MB file that lets you run a web server from the CWD (Current Working Directory).
I use it for running content locally like my MDWiki or for running Unity WebGL Builds.  If you don't want to copy / paste the SWS.exe file
everywhere you use the [RunSWS.bat](./SimpleWebServer/RunSWS.bat) file which will download it once to your %APPDATA% folder so it can be reused.
