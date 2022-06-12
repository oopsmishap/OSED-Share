# OSED Share

A collection of things to put into your OSED share folder, these are based on [epi052's OSED scripts](https://github.com/epi052/osed-scripts)

###`init.ps1`

This is the main script to run, it will pull everything over to the OSED VM.

It will also drop epi's WinDbg scripts into WinDbg's root to allow you to run them from a Python3 version (windbg-default.ps1).

To run open `PowerShell` as admin and execute the following command ensuring that you change the share folder location to yours.

```ps1
cd C:\Users\Offsec\Desktop\; Set-ExecutionPolicy Unrestricted; \\tsclient\{share_folder}\init.ps1;
```

### `attach-process.ps1`

Based on epi's `attach-process.ps1` with some slight changes. 

[Read usage here](https://github.com/epi052/osed-scripts#attach-processps1)

### `windbg-default.ps1`

Running this will reset WinDbg to it's default state running Python3, you will need a fresh PowerShell terminal for the updated `ENVARS`.

### `windbg-mona.ps1`

Running this will reset WinDbg to the state `init.ps1` created with the older version of pykd running Python2, you will need a fresh PowerShell terminal for the updated `ENVARS`.