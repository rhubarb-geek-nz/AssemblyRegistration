# Copyright (c) 2025 Roger Brown.
# Licensed under the MIT License.

param($AppID = 'RhubarbGeekNz.AssemblyRegistration', $Method = 'GetMessage', $Hint = 1)

$ErrorActionPreference = 'Stop'

$obj = New-Object -ComObject $AppID
$obj.$Method($Hint)
