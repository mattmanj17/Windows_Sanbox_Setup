# install visual studio
# BB (matthewd) would like to only install the build tools (vs_buildtools instead of vs_community),
#  but vswhere does not know how to find that :/

# should probably just make offline installers for all the versions I care about...

# https://learn.microsoft.com/en-us/visualstudio/install/use-command-line-parameters-to-install-visual-studio
# https://learn.microsoft.com/en-us/visualstudio/install/workload-and-component-ids
# https://learn.microsoft.com/en-us/visualstudio/install/workload-component-id-vs-community

wget "https://aka.ms/vs/17/release/vs_community.exe" -UseBasicParsing -Outfile vs_community.exe
Start-Process -Wait -PassThru -FilePath vs_community.exe -ArgumentList  `
	"--passive", "--wait", `
	"--includeRecommended", `
	"--add", "Microsoft.VisualStudio.Workload.NativeDesktop"
del vs_community.exe

# https://github.com/ScoopInstaller/Install#readme
# https://github.com/Microsoft/vswhere/wiki/Installing

# use scoop to get vswhere... do not love this dep

irm get.scoop.sh -outfile install.ps1
Set-ExecutionPolicy RemoteSigned -Scope Process -Force
.\install.ps1 -RunAsAdmin
del install.ps1

scoop install vswhere

# also get python, llvm wants it
# BB (matthewd) how to get debug binaries? you can do it in the interactive installer...
# also, really only need this if setting up a machine for an actuall human to use...

scoop install python	

scoop install git

Set-ExecutionPolicy Undefined -Scope Process -Force

# magic to set up our env like a dev shell

# https://github.com/microsoft/vswhere/wiki/Start-Developer-Command-Prompt
# https://stackoverflow.com/a/2124759

$installationPath = vswhere.exe -prerelease -latest -property installationPath
pushd "$installationPath\vc\Auxiliary\build"
cmd /c "vcvars64.bat&set" |
foreach {
  if ($_ -match "=") {
    $v = $_.split("=", 2); set-item -force -path "ENV:\$($v[0])"  -value "$($v[1])" 
  }
}
popd

c:
cd \

regsvr32 "$env:VSINSTALLDIR\DIA SDK\bin\msdia140.dll" /s
regsvr32 "$env:VSINSTALLDIR\DIA SDK\bin\amd64\msdia140.dll" /s

pip install psutil

git clone https://github.com/llvm/llvm-project.git llvm

cmake -S llvm\llvm -B build -Thost=x64
# CMAKE_INSTALL_PREFIX ???

cd build

msbuild .\ALL_BUILD.vcxproj -m:8 -p:Configuration=Release

# make/build/run a hellow world c file

#New-Item hw.c
#Set-Content hw.c "#include<stdio.h>`nint main(void){printf(`"hello world`\n`"); return 0;}"
#cl hw.c
#.\hw.exe

