/**
 * ASUS TXHC (Thunderbolt/USB-C) Shutdown & Suspend Fix
 * * This patch addresses the 'AE_ALREADY_EXISTS' namespace collision errors 
 * regarding the USB-C Root Hub (RHUB) and its SuperSpeed ports (SS01-SS04).
 *
 * Root Cause: The original BIOS SSDT (TcssSsdt) attempts to redefine methods 
 * like _UPC and _PLD which are already present in the DSDT, causing the 
 * ACPI interpreter to fail and hang during power state transitions (S3/S5).
 *
 * Solution: This override table uses a higher revision (0x3000) and provides 
 * empty scopes for the conflicting objects, effectively silencing the 
 * duplicate definitions while maintaining system stability.
 */

DefinitionBlock ("", "SSDT", 2, "_ASUS_", "TcssSsdt", 0x00003000)
{
    // External references to objects defined in the DSDT or other tables
    External (\_SB.PC00.TXHC.RHUB.APLD, MethodObj)
    External (\_SB.PC00.TXHC.RHUB.AUPC, MethodObj)
    External (_SB_.PC00.TXHC.RHUB, DeviceObj)
    External (_SB_.PC00.TXHC.RHUB.SS01, DeviceObj)
    External (_SB_.PC00.TXHC.RHUB.SS02, DeviceObj)
    External (_SB_.PC00.TXHC.RHUB.SS03, DeviceObj)
    External (_SB_.PC00.TXHC.RHUB.SS04, DeviceObj)

    // Scope for the USB-C Root Hub
    If (CondRefOf (\_SB.PC00.TXHC.RHUB))
    {
        Scope (\_SB.PC00.TXHC.RHUB)
        {
            // Conflicting methods APLD and AUPC are bypassed here 
            // to prevent AE_ALREADY_EXISTS errors.
        }
    }

    // Individual Port Scopes (SuperSpeed 01 through 04)
    // We provide empty scopes to prevent the re-definition of _UPC and _PLD
    
    If (CondRefOf (\_SB.PC00.TXHC.RHUB.SS01))
    {
        Scope (\_SB.PC00.TXHC.RHUB.SS01) { }
    }

    If (CondRefOf (\_SB.PC00.TXHC.RHUB.SS02))
    {
        Scope (\_SB.PC00.TXHC.RHUB.SS02) { }
    }

    If (CondRefOf (\_SB.PC00.TXHC.RHUB.SS03))
    {
        Scope (\_SB.PC00.TXHC.RHUB.SS03) { }
    }

    If (CondRefOf (\_SB.PC00.TXHC.RHUB.SS04))
    {
        Scope (\_SB.PC00.TXHC.RHUB.SS04) { }
    }
}
