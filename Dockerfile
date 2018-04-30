# escape=`

ARG BASE_TAG=win10_1709

FROM mback2k/windows-sdk:${BASE_TAG}

SHELL ["powershell", "-command"]

RUN Invoke-WebRequest "https://download.visualstudio.microsoft.com/download/pr/100232712/e64d79b40219aea618ce2fe10ebd5f0d/vs_BuildTools.exe" -OutFile "C:\Windows\Temp\vs_buildtools.exe"; `
    Start-Process -FilePath "C:\Windows\Temp\vs_buildtools.exe" -ArgumentList --quiet, --add, Microsoft.VisualStudio.Workload.VCTools, --nocache, --wait -NoNewWindow -PassThru -Wait; `
    Remove-Item @('C:\Windows\Temp\*', 'C:\Users\*\Appdata\Local\Temp\*') -Force -Recurse;

RUN Write-Host 'Updating INCLUDE ...'; `
    $env:INCLUDE = 'C:\Program Files (x86)\Microsoft Visual Studio 14.0\VC\include;' + $env:INCLUDE; `
    [Environment]::SetEnvironmentVariable('INCLUDE', $env:INCLUDE, [EnvironmentVariableTarget]::Machine);

CMD ["powershell"]
