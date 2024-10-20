# wipe

Script for Directory Backup, Remote Upload, and Maintenance

This script automates several tasks to streamline your workflow:
   - Backup: Safeguard your specified directory by creating a backup.
   - Remote Upload: Transfer the backup to a remote server for secure storage.
   - Notifications: Receive alerts upon completion or in case of issues.
   - Cleanup: Automatically remove unnecessary cache and temporary files to free up space.
   - Designed to simplify and secure your data management process.

## License

[apache](http://www.apache.org/licenses/)

## Features

The script performs various tasks, including backing up the user's
Desktop directory, uploading the backup to a remote server, sending
notifications, and removing unnecessary cache and temporary files.

- Desktop Backup
- Backup Upload
- Notification System
- Cache and Temporary File Removal
- Password Protection
- Storage Information

## Demo

Insert gif or link to demo


## Installation

Install my-project with npm

```bash
  ./path/to/wipe.sh --install
  cd my-project
```


## Environment Variables

To run this project, you will need to add the following environment variables to your .env file

`CHAT_ID`

`BOT_TOKEN`

Learn more about the Bot API here » [TDLib – build your own Telegram](https://core.telegram.org/#tdlib--build-your-own-telegram)


## Deployment

To deploy this project run

```bash
  ./wipe.sh
```


## Usage/Examples

```
The script can be run with various options:

-b or --bkup: Performs a backup and upload.
-p or --pass: Performs a password-protected backup and upload.
-d or --debug: Prints the debug information.
-t or --test: Performs a simple backup and upload with verbose Log information.

```


## Running Tests

To run tests, run the following command

```bash
  ./wipe.sh --test
```


## Documentation

[Documentation](https://linktodocumentation)


## Acknowledgements

 - [Telegram bot](https://core.telegram.org/#tdlib--build-your-own-telegram)
 - [ffsend](https://github.com/timvisee/ffsend)
 - [Borg](https://www.borgbackup.org/)


## Contributing

Contributions are always welcome!

See `contributing.md` for ways to get started.

Please adhere to this project's `code of conduct`.


## Authors

- [@slicedMango64](https://www.github.com/slicedMango64)

