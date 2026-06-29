# tel42fax-rx

A Docker container for receiving faxes over VoIP using IAX modem.

## Quick start

1. Copy the example docker-compose file:

   ```
   cp docker-compose.example.yml docker-compose.yml
   ```

2. Create the required directories:

   ```
   mkdir -p iaxmodem logs/iaxmodem logs/fax incoming
   ```

3. Add your iaxmodem configuration file(s) to the `iaxmodem/` directory.

4. Start the container:

   ```
   docker-compose up -d
   ```

## Configuration

Place IAX modem config files in `iaxmodem/`. Each config file represents one fax line. The filename becomes the device name (e.g., `ttyIAX1`).

Example iaxmodem config file (`iaxmodem/ttyIAX1`):

```
device		/dev/ttyIAX1
owner		uucp:uucp
mode		660
port		4571
refresh		60
server		pbx.example.dn42
peername	fax1
secret		secret-password
cidname		Fax Modem 1
cidnumber	+042400000000
codec		slinear
nodaemon	1
```

## Asterisk Configuration

### iax.conf

Define peers for each fax modem. The `peername` in iaxmodem config must match the Asterisk peer name.

```ini
[fax1]
type=friend
username=fax1
secret=secret-password
auth=md5
host=dynamic
context=context-local
requirecalltoken=no
```

Repeat for each fax modem (fax2, fax3, etc.) with unique ports and credentials.

### extensions.conf

Route incoming fax calls to the fax queue:

```ini
[incoming]
exten => _X.,1,Queue(faxs,,,,30)
```

Or direct to a specific modem:

```ini
exten => 0000,1,Dial(IAX2/fax1)
```

### queues.conf

Create a queue to distribute fax calls across multiple modems:

```ini
[faxs]
strategy=ringall
member=IAX2/fax1,15
member=IAX2/fax2,15
member=IAX2/fax3,15
; Add more members as needed
```

### Troubleshooting

- Check iaxmodem logs: `docker-compose logs -f fax`
- Verify IAX registration in Asterisk: `iax2 show peers`
- Test TTY device: `ls -la /dev/ttyIAX*` in the container
- Monitor efax activity: `tail -f ./logs/fax/*.log`

## LICENSE

AGPL-v3
