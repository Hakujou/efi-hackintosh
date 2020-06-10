# Hackintosh Files

Each machine gets its own branch, sometimes with variations (version upgrades, MacOS versions, experiments).  
As of today, there are:

* Main PC - branch desktop
* Main PC (Legacy) - branch desktop-legacy
* HP EliteDesk 800 G3 - branch hp800g3

I always use OpenCore (except if doesn't boot at all) since I find it cleaner than Clover.

## Desktop
### Configuration

* Asus Prime Z390-A
* Intel Core i5 9600KF
* 16GB RAM
* AMD RX 580
* Crucial P2 NVMe SSD
* Sonnet Solo 10G-BaseT PCIe card

### Notes

Works fine on Catalina with OpenCore 0.5.9.  
RTC seems to cause motherboard in safe mode at next reboot, disabling motherboard errors will hide that issue (RTCMemoryFixup should work and be a cleaner way to handle that, but it would require to search correct offsets).  
USBMap still needs to be done, currently using OpenCore USB Inject All.  
iMacPro1,1 SMBios is used as we're using an iGPU-less CPU, hardware acceleration is properly detected on the RX 580. 

Some weird bugs: htop causes the system to load and doesn't display anything. Intel Power Gadget freezes the system instantly.

## Desktop (Legacy)
### Configuration

* MSI Z170A Gaming Pro
* Intel Core i5 6600K
* 16GB RAM
* AMD RX 580 (main GPU for MacOS, soft disabled in Windows)
* NVidia GTX 1080 (main GPU for Windows, hidden in OC DeviceProperties for MacOS)
* Crucial M2 SATA SSD (used for MacOS)
* 2xIntel SATA SSD (used for Windows + shared data)
* Sonnet Solo 10G-BaseT PCIe card

### Notes

Works fine on High Sierra, Mojave, and Catalina with OpenCore 0.5.7 (current) and 0.5.6.  
OpenCore 0.5.5 would not boot on that machine, otherwise nothing specific or particular difficulties.  
Beware of GPU disabling patch (Root -> DeviceProperties -> Add) as your GPU PCI root is probably different than mine. You can remove it if you only has an AMD GPU.

If you want sleep to work, you need to set Sleep controlled by OS in BIOS settings (default value, IIRC). Secure Boot can still be enabled, but I disabled it since I don't like it.

### Broken things

As far as I can tell, nothing.

## HP 800 G3
### Configuration

* Intel Core i5 7500T vPro
* 8GB RAM
* Intel iGPU (HD 630)
* Optional third DP port installed
* Samsung SATA 2,5" SSD
* No Wifi (had some Dell compatible cards laying around but no antennas on the device as they're optional)

### Notes

This one had some quirks. First of all, it doesn't boot Catalina at all. It goes all the way up to Apple logo, then display crashes.
It doesn't seem to be an EC issue as the usual EC patches works without issues since names are generic ones for EC.

HP has very crappy firmwares, and this one is no exception.  
The main issue with this device (other than Catalina issues) seems to be RTC. By default, RTC is entirely disabled, causing MacOS to halt boot in very early stage.  
SSDT-AWAC fixes that by setting ```STAS = one``` in ACPI table, which cause _STA of RTC to return 0x0f (expected value for _STA/Status).
Enabling RTC allows MacOS Mojave to boot fine, but causes a second issue: BIOS will throw error 005 (real time clock error) at each reboot.  
This is due to MacOS writing in CMOS (RTC) offsets where it shouldn't. This is fixed using RTCMemoryFixup and setting ```rtcfx_exclude=58-59,B0-B3,D0-DF``` in boot arguments. The error is now gone.

This one was pretty troublesome and since it can't run three screens nor Catalina (Catalina apparently boots using Clover in Legacy Mode, doesn't matter to me since I need 3 screens), so I stopped there. 7500T seems to have issues to boot on OpenCore Hackintoshes and Catalina, I saw some reports with Dell devices using same CPU having the same issues.

### Broken things

* MacOS Catalina
* Third DP output

I suspect the third DP output is not really cabled as DisplayPort in iGPU as it's a modular port, causing it to not work since MacOS doesn't like adapters. Trying different Framebuffer values without success.  
The standard two first DP ports works fine, as long as you don't unplug, which often causes display to crash.

# Tips and tricks
### Entirely disabling GateKeeper

```sudo spctl --master-disable```
