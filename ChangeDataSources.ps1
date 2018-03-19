[String]$ReportServerUri = 'http://reportpreprod/ReportServer'
[String]$Password ='user password'
[String]$Username ='DOMAIN\username'

$RsDataSources= Get-RsFolderContent -ReportServerUri $ReportServerUri -RsFolder / -Recurse | Where-Object TypeName -eq 'DataSource' | Select Path

foreach($dataSourcePath in $RsDataSources)
{
     
    $DataSource = Get-RsDataSource -ReportServerUri $ReportServerUri -Path "$dataSourcePath"
    if($DataSource.ConnectString -ne " " -or $DataSource.ConnectString -ne "" -and ($DataSource.ConnectString -ne $null) -eq $true)
    {
        $DataSource.ConnectString= $DataSource.ConnectString.Replace("TESTLSTR","PREPRODLSTR").Replace("10.0.19.03","PREPRODLSTR")
        $DataSource.UserName = $Username
        $DataSource.Password= $Password
        $DataSource.WindowsCredentials=$true
        $DataSource.Extension = "SQL"
        $DataSource.OriginalConnectStringExpressionBased = $true;
        $DataSource.ImpersonateUserSpecified = $true
        $DataSource.CredentialRetrieval = 'Store'

        Set-RsDataSource -ReportServerUri $ReportServerUri -Path "$dataSourcePath" -DataSourceDefinition $DataSource
        Set-RsDataSourcePassword -ReportServerUri $ReportServerUri -Path "$dataSourcePath" -Password $Password
        Write-Host "Replaced: " $dataSourcePath
        
    }
    $DataSource =$null;
}
