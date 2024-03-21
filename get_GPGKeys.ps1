# List GPG keys and format them into a table
$gpgKeys = @()
$gpgKeysList = gpg --list-keys --with-colons

foreach ($key in $gpgKeysList) {
    #Get Public key
    if ($key -match "^pub:") {
        $fields = $key.Split(':')
        $keyID = $fields[4]
        $gpgKeys += [PSCustomObject]@{
            KeyID = $keyID
        }
    }
}#foreach
$gpgkey =@()
foreach($key in $gpgKeys)
{
    $Id = $key.KeyId
    $GPGKeytarget = gpg --list-keys $Id
    foreach($line in $GPGKeytarget)
    {
        if ($line -match '^pub\s+(\S+)\s+(\S+)\s+(\S+)\s+(\S+)\s+(\S+)\s+(\S+)$') 
        {
            $keyType = $Matches[1]
            $keyCreation= $Matches[2]
            $keyId = $Matches[3]
            $Expiration = $Matches[6]

            $gpgKey += [PSCustomObject]@{
            KeyID = $Id
            keyType = $keyType
            KeyCreation = $keyCreation
            Expiration = $Expiration.Replace(']','')
            }
        }#if
    }#Foreach
}#Foreach
 
# Output the keys in a table format
$gpgKey | Format-Table -AutoSize





