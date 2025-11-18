# TypeWriterLabel <img src="https://raw.githubusercontent.com/Pignomaster/simple-type-writer/refs/heads/main/github_assets/md_inline_icon.png" width="24">

Add a new node providing "typing" effect to your `RichTextLabel`. Configure speed, play sound and stop on specific characters to animate your typewriter.
Compatible with BBCode.

## Table of Contents
- [Why use TypeWriterLabel](#why-use-typewriterlabel)
- [Quick Start](#quick-start)
- [Features](#features)
  - [Type a text](#type-a-text)
  - [Manage the typing speed](#manage-the-typing-speed)
  - [Add sound effect when typing](#add-sound-effect-when-typing)
  - [Short stop after a specific character](#short-stop-after-a-specific-character)
  - [Pause and resume typing](#pause-and-resume-typing)
  - [Notify when typing is done](#notify-when-the-typing-is-done)
  - [Skip typing](#skip-typing)
  - [Compatibility with BBCode](#compatibility-with-bbcode)
- [Examples](#examples)
- [License](#license)

## Why use TypeWriterLabel?

The `TypeWriterLabel` is a new node extended from `RichTextLabel`. The main feature is that the text will be typed instead of displayed all at once.
You can configure the typing with parameters or control it with functions & signals.

In fact it's pretty straightforward to add a simple typing effect with the base `RichTextLabel`. There are some basic implementations using an `AnimationPlayer` & the `RichTextLabel`'s `visible_ratio` which works fine.

But if you want to add more fancy effects just like games like Animal Crossing or Undertale (sound effect when displaying new text, short stop after ending a sentence), it becomes a bit more complexe.

The `TypeWriterLabel` aims to be a solution for developers who:
- Want a fancy typing effect on their text
- Want a light solution to do so (it's a single Node)
- Don't want to add heavy addons in their project (like Dialogic*) for a simple purpose

*If your goal is to add a full dialogue manager, you might want to check [Dialogic](https://github.com/dialogic-godot/dialogic?tab=readme-ov-file#documentation).

## Quick Start

1. Download the ZIP (Not available on Godot Asset Library for now)
2. Copy `addons/type_writer_label` folder to your projects's `addons/`
3. Enable the plugin in Project Settings > Plugins
4. Open any scene tree, go to "add/create a new node" and search for `TypeWriterLabel`, then create it.

The created node is a extension of `RichTextLabel`, so just like a new `RichTextLabel` it comes with no formatting at all.

5. Look in the inspector for the `TypeWriterLabel`section and play with the parameters.

Please check the class documentation. Press F1 > Search TypeWriterLabel


## Features
### Type a text
Add a `TypeWriterLabel`node then call the `typewrite(text_to_type: String)` function to ask the `TypeWriterLabel`to type the given text.

Note: If you fill the inherited `text` field in the inspector, when entering the scene tree, the `TypeWriterLabel`will start typing this text.

/!\ If your text does not fit into the control borders, then enable `scroll_following_visible_characters` on your `TypeWriterLabel`. (You might also want to disable `scroll_active` to hide the scrollbar)

### Manage the typing speed
Set the `typing_speed` parameter in the inspector or by code. You can lower or increase the speed while the `TypeWriterLabel`is actually typing a text.

### Add sound effect when typing
Inject an `AudioStreamPlayer` in the `typing_sound_player` to make it play its stream whenever new text is typed by the TypeWriterLabel.

(Tip: If you want to randomly pitch up or down the typing sound, you might want to check [AudioStreamRandomizer](https://docs.godotengine.org/en/stable/classes/class_audiostreamrandomizer.html))

### Short stop after a specific character
If you enable the `stop_after_character` attribute, you will be able to configure a stop after the `TypeWriterLabel` reaches a specific character (by default ".").
The stop has a duration defined by `stop_duration` and the typing will automatically resume after that.

### Pause and resume typing
By calling `pause_typing()` and `resume_typing()`, you can (guess what) pause and resume the typing.
Do not mistake the "pause" for the "stop". When paused, the `TypeWriterLabel`will only resume when you ask for, while the stop automatically resume after a duration.

### Notify when the typing is done
The signal `typewriting_done` is emitted when the last character of the current typed text has been displayed.
You can also ask the `TypeWriterLabel`still has some text to type with the function `is_typing()`.

### Notify when new chars are typed
The signal `new_chars_typed` is emitted when new chars are written in the label. The signal brings the written chars.

### Skip typing
By calling `skip_typing` while the `TypeWriterLabel`is typing, the text will be displayed all at once.
In combination with the function `is_typing()`, you can setup a simple dialogue manager.

### Compatibility with BBCode
You may use BBCode to write fancy texts. The `TypeWriterLabel` work fine with it. Inline images injected with BBCode will count as 1 character when typed.

## Examples

[Spawn Quest](https://gringo-charlatan.itch.io/spawn-quest) - The game makes use of TypeWriterLabel and BBCode for its texts.

## License

TypeWriterLabel is released under the MIT License. See the LICENSE file for details.
