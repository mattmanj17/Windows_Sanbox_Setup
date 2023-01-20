# Windows_Vm_Setup
fiddling with powershell to set up a build machine from scratch within the Windows sandbox

paste these lines into power shell to download and run setup.ps1

```PowerShell
wget https://raw.githubusercontent.com/mattmanj17/Windows_Vm_Setup/main/setup.ps1 -UseBasicParsing -Outfile setup.ps1
Set-ExecutionPolicy RemoteSigned -Scope Process -Force
.\setup.ps1 
Set-ExecutionPolicy Undefined -Scope Process -Force
```

frikin Set-ExecutionPolicy prevnting this from being a two liner

also wish the wget line could be crisper...
