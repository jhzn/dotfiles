# Getting ddcutil to work

*Note: I was using Archlinux for the below guide.*

Enable kernel module across reboots:
```shell
sudoedit /etc/modules-load.d/i2c_dev.conf
## add
i2c_dev
```
or for one time enabling:
```
sudo modprobe i2c-dev
```
## Permanent installation
```shell
sudo groupadd i2c
sudo usermod -aG i2c $USER
# makes the /dev/i2c-* have the group i2c as owner and the group i2c have RW, on system init
# otherwise we'd have to chmod/chown at every boot
sudo cp /usr/share/ddcutil/data/45-ddcutil-i2c.rules /etc/udev/rules.d
# see if everything went all ok
ddcutil environment
# if ok then this should work
ddcutil detect
```

## Usage
```shell
ddcutil detect
```
Outputs for example:
```
Display 1
   I2C bus:  /dev/i2c-5
   EDID synopsis:
      Mfg id:               BNQ
      Model:                BenQ GL2240
      Product code:         30855
      Serial number:        XBA01138SL0
      Binary serial number: 21573 (0x00005445)
      Manufacture year:     2010,  Week: 47
   VCP version:         2.1

Display 2
   I2C bus:  /dev/i2c-10
   EDID synopsis:
      Mfg id:               AOC
      Model:                U2777B
      Product code:         10103
      Serial number:
      Binary serial number: 3824 (0x00000ef0)
      Manufacture year:     2019,  Week: 17
   VCP version:         2.2

Display 3
   I2C bus:  /dev/i2c-13
   EDID synopsis:
      Mfg id:               AOC
      Model:                U2777B
      Product code:         10103
      Serial number:
      Binary serial number: 3824 (0x00000ef0)
      Manufacture year:     2019,  Week: 17
   VCP version:         2.2
```

### What can we do?

```shell
# Check with this
ddcutil capabilities
# Can we set brightness?
ddcutil capabilities | grep Brightness
# Use the integer here as input in commands like the following
# Try setting brightness
ddcutil --display=2 setvcp 10 50
```
