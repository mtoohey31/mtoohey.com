---
title: Backing up Android Photos using Termux and Rsync
description: A simple, incremental photo backup strategy for Android using Termux and Rsync.
published: 2021-10-26
tags: [Termux, Rsync, photos, backup, Android]
---

<!-- cspell:ignore termux dcim healthchecks -->

## The Plan

- Install the [Termux](https://github.com/termux/termux-app) and Termux:API apps.
- Set up SSH from Termux to your target backup location with key authentication so it can log in automatically.
- Install `rsync` and `termux-api` on Termux, then schedule the sync job.

Note: if you're in a hurry, jump straight to my automated scripts [here](https://github.com/mtoohey31/dotfiles/blob/master/.scripts/setup/schedule_photo_sync), and [here](https://github.com/mtoohey31/dotfiles/blob/master/.scripts/sync_photos). Some modifications **will** be necessary because your paths and hostnames **will** be different than mine.

## Installing Termux

There are a variety of different installation methods, including from [F-Droid](https://f-droid.org/en/packages/com.termux/) or [GitHub](https://github.com/termux/termux-app/releases). Note that the Google Play Store has been deprecated as of the posting of this article, see [the notice in the README](https://github.com/termux/termux-app#google-play-store-deprecated) for more information.

Whichever method you choose, don't forget to install Termux:API while you're at it, as we'll need it to schedule the job.

## Setting Up SSH

This isn't a guide on SSH, so I won't go too in depth on this step, but most servers should have key authentication enabled in their configuration by default. Then you just need to copy your key (after generating one if necessary) to the server with the `ssh-copy-id` command. See [this guide](https://www.digitalocean.com/community/tutorials/how-to-configure-ssh-key-based-authentication-on-a-linux-server) in the DigitalOcean community for more detailed instructions.

## Installing Required Packages

The following command should install everything we'll need:

```bash
pkg install termux-api rsync
```

You'll also need to run the following after installing `termux-api` to give it access to your phone's storage:

```bash
termux-setup-storage
```

## Creating the Script

Create the following script (with variables replaced or set somewhere) and make it executable with `chmod +x`:

```bash
#!/data/data/com.termux/files/usr/bin/sh

rsync -av "$LOCAL_PATH" "$USER@$HOSTNAME:$REMOTE_PATH" && curl "$PING_URL"
```

- Local path should begin with `storage/`, for example: `storage/dcim/Camera` in my case. To determine what it will be for you, use `cd` and `ls` to explore the contents of `storage/` until you find the directory containing your pictures.
- The `&& curl "$PING_URL"` section is optional, and can be used with a service such as [Healthchecks.io](https://healthchecks.io) to send you notifications if the backup starts failing. **I strongly recommend this, you don't want to find out after you loose your phone that backups haven't been working for the past few months!**
- I'd also recommend testing the script manually before setting it up as a termux job, since the first sync will take much longer.
- The parameters given above for Rsync will result in all pictures within the specified directory being uploaded each time the script is run. Old pictures, or pictures deleted from your phone will not be deleted from your server, so id you'd like this behaviour to be different, look into Rsync's different options with the `man rsync` command.

## Setting up the Task

We're almost there! The following command will create the task, and then we're done! Again, don't forget to change or set the environment variables, and feel free to tweak the `--period-ms` argument:

```bash
termux-job-scheduler --script "$PATH_TO_SCRIPT" --period-ms 3600000 --network unmetered
```
