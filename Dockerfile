# escape=`

ARG BASE_TAG=win10_1803

FROM mback2k/windows-sdk:${BASE_TAG}

SHELL ["powershell", "-command"]

RUN Invoke-WebRequest "https://download.visualstudio.microsoft.com/download/pr/12221253/e64d79b40219aea618ce2fe10ebd5f0d/vs_BuildTools.exe" -OutFile "C:\Windows\Temp\vs_buildtools.exe"; `
    Start-Process -FilePath "C:\Windows\Temp\vs_buildtools.exe" -ArgumentList --quiet, --add, Microsoft.VisualStudio.Workload.VCTools, --nocache, --wait -NoNewWindow -PassThru -Wait; `
    Remove-Item @('C:\Windows\Temp\*', 'C:\Users\*\Appdata\Local\Temp\*') -Force -Recurse;

RUN Write-Host 'Updating PATH and INCLUDE ...'; `
    $env:PATH = 'C:\Program Files (x86)\Microsoft Visual Studio\2017\BuildTools\MSBuild\15.0\Bin;' + $env:PATH; `
    $env:INCLUDE = 'C:\Program Files (x86)\Microsoft Visual Studio\2017\BuildTools\VC\Tools\MSVC\14.14.26428\include;' + $env:INCLUDE; `
    [Environment]::SetEnvironmentVariable('PATH', $env:PATH, [EnvironmentVariableTarget]::Machine); `
    [Environment]::SetEnvironmentVariable('INCLUDE', $env:INCLUDE, [EnvironmentVariableTarget]::Machine);

CMD ["powershell"]
