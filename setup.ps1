# install visual studio
# BB (matthewd) would like to only install the build tools (vs_buildtools instead of vs_community),
#  but vswhere does not know how to find that :/

# should probably just make offline installers for all the versions I care about...

# https://learn.microsoft.com/en-us/visualstudio/install/use-command-line-parameters-to-install-visual-studio
# https://learn.microsoft.com/en-us/visualstudio/install/workload-and-component-ids
# https://learn.microsoft.com/en-us/visualstudio/install/workload-component-id-vs-community

wget "https://aka.ms/vs/17/release/vs_community.exe" -UseBasicParsing -Outfile vs_community.exe
Start-Process -FilePath vs_community.exe -ArgumentList "--includeRecommended", "--add", "Microsoft.VisualStudio.Workload.NativeDesktop", "--passive", "--wait" -Wait -PassThru
del vs_community.exe

# use scoop to get vswhere... do not love this dep

irm get.scoop.sh -outfile install.ps1
Set-ExecutionPolicy RemoteSigned -Scope Process -Force
.\install.ps1 -RunAsAdmin
del install.ps1
scoop install vswhere
Set-ExecutionPolicy Undefined -Scope Process -Force

# magic copied from vswhere github to set up our env like a dev shell

$installationPath = vswhere.exe -prerelease -latest -property installationPath
if ($installationPath -and (test-path "$installationPath\Common7\Tools\vsdevcmd.bat")) {
  & "${env:COMSPEC}" /s /c "`"$installationPath\Common7\Tools\vsdevcmd.bat`" -no_logo && set" | foreach-object {
    $name, $value = $_ -split '=', 2
    set-content env:\"$name" $value
  }
}

# make/build/run a hellow world c file

New-Item hw.c
Set-Content hw.c "#include<stdio.h>`nint main(void){printf(`"hello world`\n`"); return 0;}"
cl hw.c
.\hw.exe

