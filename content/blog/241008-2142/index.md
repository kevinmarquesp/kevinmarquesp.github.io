---
title: "Nix OS: First Impressions"
date: "2024-10-08T21:42:18-03:00"

draft: false
comments: true
math: false
toc: true

author: "Kevin Marques"
tags: ["programming", "exploring", "linux", "arch", "btrfs", "network", "wifi"]
---

About a month ago, I bought a 3.5" Western Digital 2 TB HDD that I'll just use
as a backup storage for now -- but, in the future, I plan to build my own desktop
computer, so it'll surely be useful both now and then. But the real reason that
I bought this HDD just to back up all my Arch Linux data and start testing
[Nix OS](https://nixos.org/) for the first time; I was so excited about it that
I copied my important files to it the moment that I opened the delivery box from
Mercado Libre.

But I came back to Arch again. I was having some problems that I didn't know how
to fix in Nix OS, so I installed Arch once more, but in a smarter way to dual
boot other distros more easily, and to figure out what was causing the problem.
And this time I actually documented the whole process as I installed Arch Linux!
So, expect for new articles in the future about that.

Once I "finished" (I'm still configuring everything to be the way I want),
I thought that it might be a good article to share here about some of my
experiments and ideas might help someone else -- and they will serve as an
archive of this whole drama, in future Arch/Nix OS installations it'll be
helpful.


## Nix OS May Be The Perfect Linux Distribution

Nix OS is just what I expected, it's quite perfect for all my needs, mainly
because of the reproducibillity and the version management of some programs --
by itself it can replace [`asdf`](https://github.com/asdf-vm/asdf), my
*dotfiles* and even BTRFS for taking system snapshots.

I really don't want to dig too deeply into how Nix OS is great for developers or
for game servers, but I need to mention the feature that helped the most when
I was trying it out. Once, a friend of mine was explaining how a project that
we were working on works, he mentioned that I needed to learn a little bit about
Mongo DB, then I used Nix to create an isolated environment with the `mongocli`
package installed. Seriously, that was so smooth; I just wanted to test some
application a little bit, and I get it up and running temporailly with one
single command.

But, yeah... Of course, it went wrong when I installed it for the first time. For
some reason, the internet connection was unbearably slow, and it should not be
Nix OS fault. Right? No, it wasn't; of course, it was a *skill issue* of mine.
I tried to configure the [NetworkManager](https://wiki.archlinux.org/title/NetworkManager)
and the [WPA Supplicant](https://wiki.archlinux.org/title/Wpa_supplicant)
packages, but none of those fixed my problem. Then I just lost my patience and
just burned yet another Arch Linux ISO to my [Ventoy](https://www.ventoy.net/en/index.html)
USB Drive.

Besides that silly problem, there is some stuff that's worth commenting about
Nix OS.


### The Pros And Cons Of Nix OS

Nix OS is **weird** -- someone had to say it. It doesn't follow the pattern that
other distributions follow, so any configuration that you normally do in a Linux
Mint, Gentoo, or something else, you're forced to do in the
`/etc/nixos/configuration.nix` or `/etc/nixos/hardware.nix`. Like, you don't
edit the `fstab` file, nor the Systemd ones, everything should be *declared*
into those two files.

I know that's the beauty of Nix OS, and, as far as I know, Nix OS supports
a bunch of different system configurations that's out there. But... I don't
know, the documentation is pretty bad to me, and I just managed to use the
system with the help of some friends on Discord or in random blog posts. I don't
mean that the documentation is bad written, it's just bad organized and doesn't
cover some tweaks that may be necessary for some use cases.

And I heard from some game developers that Nix OS is annoying because some
softwares that they use for doing gaming development stuff is not available for
that platform. I'm not a game dev; in my case, I found it very annoying that I
wasn't able to run, nor install, AppImages like I'd do normally in Linux Mint,
or Manjaro, you've got my point.


## Why I'm Back To Arch Linux

Because I was annoyed, and I wanted to have a system that just works... Well,
never though that I would say those words when speaking about Arch Linux.

But also, because I did a poor backup of my stuff before installing Nix OS (I
want to be better this time) and I just wanted to see what was the problem with
the network -- I tested that in Linux Mint, it worked just fine, and in Manjaro,
which didn't worked for some reason.

Once I installed my beloved Arch Linux, I was having the same problem. As it
turned out, it was a NetworkManager version issue; or WPA Supplicant, they both
come together in the same package now. To fix that, I just started using [Systemd
Networkd](https://wiki.archlinux.org/title/Systemd-networkd) to replace
NetworkManager and [IWD](https://wiki.archlinux.org/title/Iwd) to replace WPA
Supplicant. But that's a story for another post, this one is becoming too big.


## Conclusion

And, that's it. Nix OS is a darn good distribution, and it's a good new
philosophy to try out. All my commentaries was just picky things to justify why
I moved back to Arch. But, ya' know, it wasn't worthless.

I liked how the Nix OS installer has an option to encrypt my system with LUKS.
And I love that the default bootloader was Systemd Boot -- I didn't even know
that it existed! Now, in my Arch setup, I choose to use Systemd Boot too,
because it renders the bootloader in firmware, which means that I don't need to
decrypt my SSD to load GRUB and then chose which system I want to boot; this
really annoyed me in my previous Arch setup.

Still about Systemd Boot, I liked how dead simple it is to configure. Maybe in
the future, I'll create a script that adds entries to boot into snapshots taken
by [Snapper](https://wiki.archlinux.org/title/Snapper) and write about that
here. Who knows, right?

It was a great journey, and I'll give more details about my freshly installed
Arch Linux and how it's less difficult for me to dual boot without creating or
formatting the partitions on my SSD. At the very least, I gained experience with
this mess. Thanks for reading!
