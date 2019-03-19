param ( [string]$servername,
        [string]$outputfile,
        [switch]$silent)

function Log-Info 
{
    param ([string]$output)
    if(!$silent)
    {
        Write-Host $output
    }
}
#check if input call was made properly
if(!$servername)
{
    Log-Info -output "Please call script in the format: .\servernamepull.ps1 -servername <yourservername>"
    
    return $false
}
#Get Execution Path (for default pathing)

#check output file parameter
if(!$outputfile)
{
    Log-Info -output "using default outputfile location: \servernameresults.csv"
    
    $outputfile = 'servernameresult.csv'
}
#if the file doesn't exist, create it
if(!(Test-Path $outputfile))
{
    Log-Info -output "outputfile does not exist. creating with headers."
    $headers = "input,result,servername,IP"
    Set-Content -Path $outputfile -Value $headers
}
$resultStatus = "Success"
$resultInput = $servername
$hostEntry = [System.Net.Dns]::GetHostByName($serverName)
$resultIp= $hostEntry.AddressList[0].IPAddressToString
$resultServerName = ([System.Net.Dns]::GetHostByAddress($resultIp)).Hostname
if($? -eq $False){
    $resultServerName="Cannot resolve hostname"
    $resultStatus = "Failure"
}
$output = "$resultInput,$ResultStatus,$resultServerName,$resultIp"
Add-Content -Path $outputfile -Value $output

return $true