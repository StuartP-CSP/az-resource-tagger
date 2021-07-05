$Tag = @{Owner="xxxxx xxxxxx"}      # <- Your full name
$ResourceGroup = "xxxxxxxx"         # <- The Resource Group to tag
# Set the above variables.
$Subscription="Citrix-CSP-SEs"

Write-Host -ForegroundColor Green "Add Owner to Resource group Objexts that do not have a cooreponding tag"
Write-Host -ForegroundColor Green "Log on to Azure"
Connect-AzAccount

Write-Host -ForegroundColor Green   "Parameters to set:"
Write-host -ForegroundColor Yellow  $Tag
Write-host -ForegroundColor Yellow  $ResourceGroup
Write-host -ForegroundColor Yellow  $Subscription
Write-Host -ForegroundColor Green   "If this is correct press Enter"
pause
if ( Get-Module -ListAvailable -Name Az ) {
     Write-Host "Az Module found, tagging...."
        Set-AzContext -Subscription $Subscription
        $Resources = Get-AzResource | Where-Object {$_.ResourceGroupName -eq $ResourceGroup}
    foreach ( $Resource in $Resources ) {
        if ( $Nul -eq $Resource.Tags ) {
            Write-Host $Resource
            Set-AzResource -ResourceId $res.ResourceId -Tag $Tag -Force
        }
    }
} else {
    Write-Host "Az Module NOT found. Exiting."
    Write-Host "To install Azure PoSH run the following command"
    Write-Host -ForegroundColor Yellow "Install-Module -Name Az -AllowClobber -Scope CurrentUser"
}