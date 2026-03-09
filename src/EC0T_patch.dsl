/**
 * ASUS EC0 Thermal Management Fix
 * * This patch defines missing thermal threshold variables in the global namespace.
 * These variables are referenced by the Embedded Controller (EC0) thermal zones 
 * (SEN1, SEN2, SEN3, SEN4) but are not defined in the original BIOS ACPI tables,
 * leading to 'AE_NOT_FOUND' errors during boot.
 */

DefinitionBlock ("", "SSDT", 2, "KALI", "THERMFIX", 0x00000001)
{
    /**
     * Configurable TDP (cTDP)
     * Defines the power limit level for the processor's thermal design.
     */
    Name (\CTDP, 0)

    /**
     * Thermal Sensor Thresholds
     * Format: 
     * xxCT: Critical Temperature (System shutdown)
     * xxHT: Hot Temperature (Critical notification)
     * xxPT: Passive Cooling Temperature (CPU Throttling start)
     * xxAT: Active Cooling Temperature (Fan speed increase)
     */

    // Sensor 1 Thresholds (CPU/Package)
    Name (\S1CT, 100) 
    Name (\S1HT, 90) 
    Name (\S1PT, 80) 
    Name (\S1AT, 60)

    // Sensor 2 Thresholds (GPU/Discrete Graphics)
    Name (\S2CT, 100) 
    Name (\S2HT, 90) 
    Name (\S2PT, 80) 
    Name (\S2AT, 60)

    // Sensor 3 Thresholds (Mainboard/VRM)
    Name (\S3CT, 85)  
    Name (\S3HT, 75) 
    Name (\S3PT, 65) 
    Name (\S3AT, 50)

    // Sensor 4 Thresholds (Battery/Chassis)
    Name (\S4CT, 85)  
    Name (\S4HT, 75) 
    Name (\S4PT, 65) 
    Name (\S4AT, 50)
}
