# escape=`

ARG BASE_TAG=1803

FROM mback2k/windows-base:${BASE_TAG}

RUN Invoke-WebRequest "https://aka.ms/vs/15/release/vs_buildtools.exe" -OutFile "C:\Windows\Temp\vs_buildtools.exe"; `
    Start-Process -FilePath "C:\Windows\Temp\vs_buildtools.exe" -ArgumentList --quiet, `
                  --add, Microsoft.VisualStudio.Workload.VCTools, `
                  --nocache, --norestart, --wait -NoNewWindow -PassThru -Wait; `
    Remove-Item @('C:\Windows\Temp\*', 'C:\Users\*\Appdata\Local\Temp\*') -Force -Recurse; `
    Write-Host 'Checking PATH and INCLUDE ...'; `
    Get-Item -Path 'C:\Program Files (x86)\Microsoft Visual Studio\2017\BuildTools\MSBuild\15.0\Bin'; `
    Get-Item -Path 'C:\Program Files (x86)\Microsoft Visual Studio\2017\BuildTools\VC\Tools\MSVC\14.*\include';

RUN Write-Host 'Updating PATH and INCLUDE ...'; `
    $add_PATH = Get-Item -Path 'C:\Program Files (x86)\Microsoft Visual Studio\2017\BuildTools\MSBuild\15.0\Bin'; `
    $add_INCLUDE = Get-Item -Path 'C:\Program Files (x86)\Microsoft Visual Studio\2017\BuildTools\VC\Tools\MSVC\14.*\include'; `
    $env:PATH = $add_PATH.FullName + ';' + $env:PATH; `
    $env:INCLUDE = $add_INCLUDE.FullName + ';' + $env:INCLUDE; `
    [Environment]::SetEnvironmentVariable('PATH', $env:PATH, [EnvironmentVariableTarget]::Machine); `
    [Environment]::SetEnvironmentVariable('INCLUDE', $env:INCLUDE, [EnvironmentVariableTarget]::Machine);
