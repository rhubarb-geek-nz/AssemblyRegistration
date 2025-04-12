# Copyright (c) 2025 Roger Brown.
# Licensed under the MIT License.

param(
	$CertificateThumbprint = '601A8B683F791E51F647D34AD102C38DA4DDB65F',
	$Architectures = @('arm', 'arm64', 'x86', 'x64')
)

$ProgressPreference = 'SilentlyContinue'
$ErrorActionPreference = 'Stop'

trap
{
	throw $PSItem
}

foreach ($ARCH in $Architectures)
{
	$VERSION=(Get-Item -LiteralPath "..\displib\bin\Release\netstandard2.0\publish\RhubarbGeekNz.AssemblyRegistration.Library.dll").VersionInfo.ProductVersion

	$env:PRODUCTVERSION = $VERSION
	$env:PRODUCTARCH = $ARCH
	$env:PRODUCTWIN64 = 'yes'
	$env:PRODUCTPROGFILES = 'ProgramFiles64Folder'
	$env:INSTALLERVERSION = '500'

	switch ($ARCH)
	{
		'arm64' {
			$env:UPGRADECODE = '51191F80-6BF8-4862-A63D-CCA1026BD624'
		}

		'arm' {
			$env:UPGRADECODE = 'FCB762D5-D85D-44E2-B1D3-058B09072B6B'
			$env:PRODUCTWIN64 = 'no'
			$env:PRODUCTPROGFILES = 'ProgramFilesFolder'
		}

		'x86' {
			$env:UPGRADECODE = '6631BDE3-4F3E-437B-8866-6D155464C49E'
			$env:PRODUCTWIN64 = 'no'
			$env:PRODUCTPROGFILES = 'ProgramFilesFolder'
			$env:INSTALLERVERSION = '200'
		}

		'x64' {
			$env:UPGRADECODE = 'A2258CB8-425D-4E13-989C-DDAD04AF5BA3'
			$env:INSTALLERVERSION = '200'
		}
	}	

	& "${env:WIX}bin\candle.exe" -nologo "displib.wxs"

	if ($LastExitCode -ne 0)
	{
		exit $LastExitCode
	}

	$MsiFilename = "rhubarb-geek-nz.AssemblyRegistration-$VERSION-$ARCH.msi"

	& "${env:WIX}bin\light.exe" -nologo -cultures:null -out $MsiFilename 'displib.wixobj'

	if ($LastExitCode -ne 0)
	{
		exit $LastExitCode
	}

	Remove-Item 'displib.wix*'
	Remove-Item 'rhubarb-geek-nz.AssemblyRegistration-*.wixpdb'

	if ($CertificateThumbprint)
	{
		$codeSignCertificate = Get-ChildItem -path Cert:\ -Recurse -CodeSigningCert | Where-Object { $_.Thumbprint -eq $CertificateThumbprint }

		if ($codeSignCertificate -and ($codeSignCertificate.Count -eq 1))
		{
			$result = Set-AuthenticodeSignature -FilePath $MsiFilename -HashAlgorithm 'SHA256' -Certificate $codeSignCertificate -TimestampServer 'http://timestamp.digicert.com'
		}
		else
		{
			Write-Error "Error with certificate - $CertificateThumbprint"
		}
	}
}
