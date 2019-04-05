$RomName = "ocarina-of-time.z64"

$TEXT_VADDR = @{
    makerom_o="0x80000000";
    boot_o="0x80001060";
    code_o="0x800110A0"
}

# Compile the assembly code in './asm/'
Get-ChildItem "${PSScriptRoot}/asm/*.s" | 
Foreach-Object {
    $Name = $_.FullName.Replace('\', '/').Replace('C:/', '/mnt/c/')
    Write-Host "Compiling: ${Name}"
    $CompiledName = $Name
    $CompiledName = $CompiledName.Replace('.s', '.o')
    $Command = "${PSScriptRoot}/tools/binutils/bin/as ${Name} -o ${CompiledName} -I include"
    $Command = $Command.Replace('\', '/').Replace('C:/', '/mnt/c/')
    bash -c $Command
}

# Create binaries
$I = -1
Get-ChildItem "${PSScriptRoot}/asm/*.o" | 
Foreach-Object {
    $I++
    $Name = $_.FullName.Replace('\', '/').Replace('C:/', '/mnt/c/')
    Write-Host "Binarazing: ${Name}"
    $CompiledName = $Name
    $CompiledName = $CompiledName.Replace('.o', '.bin').Replace('asm', 'build')
    $VADDR = $TEXT_VADDR[$_.Name.Replace('.', '_')]
    $Command = "${PSScriptRoot}/tools/binutils/bin/ld -T ldscript.txt -Ttext ${VADDR} ${Name} -o ${CompiledName}"
    $Command = $Command.Replace('\', '/').Replace('C:/', '/mnt/c/')
    bash -c $Command
}
# Yaz0 Compress the contents of './build'
Get-ChildItem "${PSScriptRoot}/build" | 
Foreach-Object {
    $Name = $_.FullName.Replace('\', '/').Replace('C:/', '/mnt/c/')
    Write-Host "Compressing ${Name}"
    $CompressedName = "${Name}.yaz0"
    $Command = "${PSScriptRoot}/tools/yaz0 ${Name} ${CompressedName}"
    $Command = $Command.Replace('\', '/').Replace('C:/', '/mnt/c/')
    bash -c $Command
}

# Yaz0 Compress the contents of './baserom'
Get-ChildItem "${PSScriptRoot}/baserom" | 
Foreach-Object {
    $Name = $_.FullName.Replace('\', '/').Replace('C:/', '/mnt/c/')
    Write-Host "Compressing ${Name}"
    $CompressedName = "${Name}.yaz0"
    $Command = "${PSScriptRoot}/tools/yaz0 ${Name} ${CompressedName}"
    $Command = $Command.Replace('\', '/').Replace('C:/', '/mnt/c/')
    bash -c $Command
}

# Make the ROM
$Command = "${PSScriptRoot}/tools/makeromfs file_list.txt ${RomName}"
$Command = $Command.Replace('\', '/').Replace('C:/', '/mnt/c/')
bash -c $Command