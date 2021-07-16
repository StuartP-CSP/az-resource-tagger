# Az-ResourceTagger.ps1 

## Overview
A simple script to create Owner name, email and region tags on Azure resources in a specified Resource Group, of a specified subscription. Default subscription set in script.

No warranty; use at your own risk.  

## Requirement
Required the Azure 'az' PowerShell module be installed.

Install with:
```
Install-Module -Name Az -AllowClobber -Scope CurrentUser
```

## Usage
Either specify the parameters on the command line or you will be prompted to enter them.

```
Az-ResourceTagger -ResourceGroup xxxxx -Owner xxxxx -Email xxxx.xxxx@xxxx.com -Geo EMEA <-Subscription My-Azure-Subscription>
```

## Author
Stuart Parkington and Darren Harding

## Licence
None.