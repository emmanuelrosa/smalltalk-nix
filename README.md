# smalltalk-nix

Nix packages for Cuis (and eventually Squeak and Pharo) Smalltalk.

**Note:** This is under active development, therefore, some of the things mentioned below don't exist yet.

The goals of this project are to provide:

- Nix packages for [Squeak Smalltalk](https://squeak.org/) and it's variants which use the [OpenSmalltalk](https://opensmalltalk.org/) virtual machine. Support multiple versions of said packages.
- Seamless freedesktop integration for NixOS, such that Smalltalk images can be opened just like any other file; The virtual machine can be launched from an application menu, or through a file manager. 
- Amazin' developer support by providing the ability to install and use multiple versions of Smalltalk, and even customized variants.
- Unmatched packaging and distribution of Smalltalk applications for NixOS.

## Quick start

If you want to get a glimpse of the Smalltalk experience this Nix flake can provide, you're in the right place.

Let's say you're starting from scratch. You don't have any Cuis Smalltalk images nor any Smalltalk virtual machines installed. Or perhaps you do. It doesn't matter. Try this command:

```
nix run github:emmanuelrosa/smalltalk-nix#cuis-7_0
```

After a brief moment you'll be presented with a Zenity dialog asking you whether you want to create a new Cuis Smalltalk image, or open an existing one. If you choose to create one, then you'll be prompted to select the directory where you want to save the image. If you choose to open one, then you'll be prompted for the image file. Either way, after you make your selection Cuis Smalltalk will appear on your screen.

Long are the days of having to go online, find the appropriate Smalltalk website, download the bundle for your platform, extract the bundle somewhere, go to the directory, open a command prompt...

It's all just seemlessly taken care of for you :)

## Packages

The Nix packages are divided into OpenSmalltalk virtual machines, Smalltalk images, and Smalltalk bundle packages.

- The OpenSmalltalk virtual machine packages provide various versions and configurations of the OpenSmalltalk virtual machine; Cog, Spur, etc.
- The Smalltalk image packages provide various Smalltalk variants, such as Cuis, Squeak, and Pharo, and different versions of them.
- The Smalltalk bundles combine a virtual machine, Smalltalk image, and a custom launcher into a unified package. These bundles integrate Smalltalk into your NixOS system. In short, you're gonna love this!

## Next steps

If you completed the *really* quick start, and it blew your pants off, then imagine what will happen when you install the same package into your NixOS system (using `environment.systemPackages`).

Installing the bundle packages registers Smalltalk image files as a MIME type and associates the OopenSmalltalk virtual machine with the image files. This means you can right-click on a Smalltalk Image file using your file manager, and launch the image.
