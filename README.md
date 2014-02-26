NavLicenseSwap
==============

Swaps licence for a NAV service
This small PowerShell script is made so you can choose which license to import into a database quickly and at the same time restaret the service.

Prerequisite
------------
* PowerShell
* Dynamics Nav 2013 or 2013 R2

How to
------
1. Download [ReplaceLicense.ps1](https://github.com/SShadowS/NavLicenseSwap/blob/master/ReplaceLicense.ps1)
2. Change settings in the file to reflect the installation.
3. Run script and chose which version of script to import into service.

Features
--------
- FTP download of developer script without saving the file on local pc
- Fetches client license from local directory
- Can easily be modified to use local/FTP method both for client and developer license

On the drawing board
--------------------
- Remotely import license
- Run script on server from a NAV object
