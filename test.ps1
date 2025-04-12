# Copyright (c) 2025 Roger Brown.
# Licensed under the MIT License.

param($CLSID = '4c00572c-ccf0-4f6d-8203-546c754a125a', $Method = 'GetMessage', $Hint = 1)

$guid = [Guid]::Parse($CLSID)
$type = [Type]::GetTypeFromCLSID($guid)
$obj = [Activator]::CreateInstance($type)
$obj.$Method($Hint)
