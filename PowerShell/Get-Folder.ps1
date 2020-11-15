<#
.DESCRIPTION
    A function to help sumarize the content of given folder,
    list all contents and show their size in MB, preseve the mode property
    from Get-ChildItem command.
    
    This function takes one parameter and verify it's a valid folder path
#>

function GetFolder {
    param (
        [Parameter()]
        [ValidateScript({Test-Path $_})]
        [string]
        $FolderPath
    )
    
    begin {
        if (!$FolderPath) {
            $FolderPath = Get-Location
        }
    }

    process {
        $Folder = Get-ChildItem -Path $FolderPath
        if ($null -eq $Folder) {
            continue
        }
        else {
            $ReportObj = @()
            foreach ($item in $Folder) {
                $ItemObj = [PSCustomObject]@{}
                try {
                    $SizeInMB = [math]::Round((Get-ChildItem $item.PSPath -Recurse | Measure-Object -Property Length -Sum -ErrorAction Stop).Sum / 1MB, 2)
                    $ItemObj = [PSCustomObject]@{
                        Name = $item.Name
                        Mode = $item.Mode
                        SizeInMB = $SizeInMB
                    }
                }
                catch {
                    $ItemObj = [PSCustomObject]@{
                        Name = $item.Name
                        Mode = $item.Mode
                        SizeInMB = 0
                    }
                }
                $ReportObj += $ItemObj
            }
        }
    }

    end {
        $FolderPathSize = [math]::Round((Get-ChildItem $FolderPath -Recurse | Measure-Object -Property Length -Sum).Sum / 1MB, 2)
        Write-Host "$FolderPath size is: $FolderPathSize MB"
        $ReportObj | Sort-Object -Property SizeInMB -Descending
    }
}