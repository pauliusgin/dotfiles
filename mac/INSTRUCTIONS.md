## Quick Actions (Automator services)

`Open in Visual Studio Code.workflow` is a Finder Quick Action — right-click any
file or folder → **Open in Visual Studio Code**.

It is kept here as a plain copy (not a symlink) because macOS registers Quick
Actions from the real bundle in `~/Library/Services`.

`boot.sh` copies it into place on a fresh install. To do it by hand:

```sh
cp -R "$HOME/.dotfiles/mac/Open in Visual Studio Code.workflow" "$HOME/Library/Services/"
killall pbs
```

`killall pbs` restarts the services daemon so Finder picks the action up.

The action points at `/Applications/Visual Studio Code.app`, so VS Code is required for this to work.

**Note:** editing the copy in this repo has no effect on the live Quick Action.
If you change the workflow in Automator, copy it back here:

```sh
cp -R "$HOME/Library/Services/Open in Visual Studio Code.workflow" "$HOME/.dotfiles/mac/"
```
