param (
    [Parameter(Mandatory = $false)]
    [string] $ResourceGroup = (Read-Host -Prompt 'Resource Group name'),
    [Parameter(Mandatory = $false)]
    [string] $Owner = (Read-Host -Prompt "Your full name"),
    [Parameter(Mandatory = $false)]
    [string] $Email = (Read-Host -Prompt "Your email address"),
    [Parameter(Mandatory = $false)]
    [string] $Geo = (Read-Host -Prompt "In which region (EMEA, AMS or APJ)"),
    [Parameter(Mandatory = $false)]
    [string] $Subscription="Citrix-CSP-SEs"
)

# You shouldn't need to change the variables below.
$Tag = @{Owner="$Owner"; Email="$Email"; Geo="$Geo"}

Write-Host
Write-Host -ForegroundColor Green "Add Owner tags to all Objects in the Resource Group: " -NoNewline
Write-Host -ForegroundColor Yellow $ResourceGroup
Write-Host
Write-Host -ForegroundColor Green   "Parameters to set:"
Write-Host -ForegroundColor White "   Tag all resources in " -NoNewline
Write-Host -ForegroundColor Yellow  $ResourceGroup -NoNewline
Write-Host -ForegroundColor White " in the " -NoNewline
Write-Host -ForegroundColor Yellow $Subscription -NoNewline
Write-Host -ForegroundColor White " subscription"
Write-Host -ForegroundColor White "   with the tags:"
Write-Host -ForegroundColor Yellow  "   - Owner:" $Owner
Write-Host -ForegroundColor Yellow  "   - Email:" $Email
Write-Host -ForegroundColor Yellow  "   - Geo:" $Geo
Write-Host 
Write-Host -ForegroundColor Green   "If this is correct press Enter"
pause

if ( Get-Module -ListAvailable -Name Az ) {
    Write-Host "Az Module found, tagging...."
    Write-Host "Checking Azure Context..."
    if ( (get-azcontext).Subscription.Name -ne $Subscription ) {
        Write-Host -ForegroundColor Green "Log on to Azure"
        Connect-AzAccount
        Set-AzContext -Subscription $Subscription | Out-Null
    } else {
        Get-AzContext | Out-Null
    }        
    $Resources = Get-AzResource | Where-Object {$_.ResourceGroupName -eq $ResourceGroup}
    foreach ( $Resource in $Resources ) {
        if ( $Nul -eq $Resource.Tags ) {
            Write-Host "Tags not set. Adding owner tags to " -NoNewline
            Write-Host -ForegroundColor Yellow $Resource.ResourceName ...
            Set-AzResource -ResourceId $Resource.ResourceId -Tag $Tag -Force | Out-Null
            # Write-Host $res.Tags
        } else {
            Write-Host "Tags already set. Merging owner tags to " -NoNewline
            Write-Host -ForegroundColor Yellow $Resource.ResourceName ...
            $CombinedTag = @{}
            # copy all keys and values from the current tags ($Resource.Tags) Hashtable into $CombinedTag
            $Resource.Tags.Keys | ForEach-Object { $CombinedTag[$_] = $Resource.Tags[$_] }
            # make sure the value of the $Resource.Tags hashtable is NOT overwritten (i.e. $Resource.Tags value 'wins')
            $tag.Keys | ForEach-Object { if (!($CombinedTag.ContainsKey($_))) { $CombinedTag[$_] = $Tag[$_] }}

            Set-AzResource -ResourceId $Resource.ResourceId -Tag $CombinedTag -Force | Out-Null
            # Write-host $Resource.Tags
        }
    }
} else {
    Write-Host "Az Module NOT found. Exiting."
    Write-Host "To install Azure PoSH run the following command"
    Write-Host -ForegroundColor Yellow "Install-Module -Name Az -AllowClobber -Scope CurrentUser"
}