Param
(
    [Parameter(Position=0, Mandatory=$true, HelpMessage="Path and File for Source Notebook")]
    [string]
    $SourceFile,

    [Parameter(Position=1, Mandatory=$true, HelpMessage="Path and File for output .ipynb file")]
    [string]
    $DestinationFile
)

function GetSourceData
{
	Param 
	(
		[string]$notebookPathAndFile
	)
	write-host "GetSourceData: '$notebookPathAndFile'"
	
	$lines_of_code = @()

	$notebook_object = get-content -raw -path $notebookPathAndFile | convertfrom-json
	$notebook_directory = Split-Path -Path $notebookPathAndFile -Parent

	# write-host "for each cell"
	foreach($cell in $notebook_object.properties.cells) {
	
		# write-host "Cell_type: $($cell.cell_type)"
		if($cell.cell_type -eq "code") {
			# write-host "for each cell"
			foreach($source in $cell.source) {
				
				$source = $source.replace("`r", "").replace("`n", "")
				
				# Import code from any %run included files
				if ($source.startswith("%run") -eq $True) {
					# write-host "run cell..." 
					
					#TODO:  May need to remove path if it exists (common\helpers\etc)
					$import_path = $source.Replace("%run ", "").Trim() 
					$import_file_name = Split-Path $import_path -Leaf
					
					write-host "Import file: '$import_file_name'"
					# TODO - Write a comment seperator
					$lines_of_code += "################## Importing '$import_file_name' ##################`n"
					$import_notebook = "$notebook_directory\$import_file_name.json"
					write-host "Import notebook: '$import_notebook'"
					foreach($line in GetSourceData($import_notebook)) {
						$lines_of_code += $line
					}
					$lines_of_code += "#---------------------------------------------------------------`n"
				} else {
					$lines_of_code += $source
				}
			}
		}
	}
	
	return $lines_of_code
}

write-host "Source: $SourceFile / Dest: $DestinationFile"

# import the code
write-host "Calling get source data"
GetSourceData($SourceFile) |  Set-Content -Path $DestinationFile