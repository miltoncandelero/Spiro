package;

import openfl.Assets;
import openfl.display.Bitmap;
import openfl.text.TextFormat;
import feathers.layout.VerticalLayout;
import feathers.controls.Check;
import feathers.controls.HSlider;
import feathers.controls.HProgressBar;
import feathers.core.PopUpManager;
import Spiro.ColorMode;
import feathers.controls.ToggleSwitch;
import openfl.display.Shape;
import feathers.controls.Button;
import openfl.events.MouseEvent;
import feathers.events.FeathersEvent;
import openfl.events.Event;
import feathers.layout.HorizontalLayout;
import feathers.controls.Label;
import feathers.controls.TextInput;
import feathers.controls.LayoutGroup;
import feathers.layout.VerticalListFixedRowLayout;
import motion.Actuate;
import openfl.Lib;
import feathers.controls.ScrollContainer;
import feathers.style.Theme;
import feathers.themes.steel.SteelTheme;
import openfl.display.Sprite;
import feathers.style.IDarkModeTheme;
import openfl.events.FocusEvent;

using StringTools;

class UI extends Sprite {
	var group:ScrollContainer = new ScrollContainer();
	var spiro:Spiro;

	var animDuration:Float = 5;

	var color1:Shape = new Shape();
	var color2:Shape = new Shape();
	var bgColor:Shape = new Shape();

	var tweenMode:ColorMode = HSV;
	var fps:Float = 60;
	var loop:Bool = true;
	var quality:Int = 100;

	public function new(spiro:Spiro) {
		super();
		this.spiro = spiro;

		var steel = new SteelTheme(0xA20025, 0xA20025);
		// steel.darkMode = true;
		Theme.setTheme(steel);
		cast(Theme.getTheme(), IDarkModeTheme).darkMode = true;
		group.width = 210;
		group.height = 600;

		// var layout:VerticalListFixedRowLayout = new VerticalListFixedRowLayout();
		var layout:VerticalLayout = new VerticalLayout();
		layout.horizontalAlign = JUSTIFY;
		layout.paddingLeft = 10;

		group.layout = layout;

		group.addChild(new Bitmap(Assets.getBitmapData("logo.png")));

		// ##################################################
		// Spirosettings
		var label:Label = new Label();
		label.text = "Spirograph Parameters";
		label.width = 90;
		label.paddingTop = 20;
		group.addChild(label);

		// big radius ---------------------------------------
		var hBox:LayoutGroup = new LayoutGroup();
		var hLayout:HorizontalLayout = new HorizontalLayout();
		hLayout.horizontalAlign = JUSTIFY;
		hLayout.verticalAlign = MIDDLE;
		hBox.layout = hLayout;
		group.addChild(hBox);

		var label:Label = new Label();
		label.text = "Big radius";
		label.width = 90;
		hBox.addChild(label);

		var input:TextInput = new TextInput();
		input.restrict = "0-9.\\-";
		input.width = 90;
		input.addEventListener(FocusEvent.FOCUS_OUT, fixFloatBox, false, 999999999);
		input.addEventListener(FocusEvent.FOCUS_OUT, changeBigR);
		input.text = Std.string(spiro.bigR);
		hBox.addChild(input);

		// small radius --------------------------------------
		var hBox:LayoutGroup = new LayoutGroup();
		var hLayout:HorizontalLayout = new HorizontalLayout();
		hLayout.horizontalAlign = JUSTIFY;
		hLayout.verticalAlign = MIDDLE;
		hBox.layout = hLayout;
		group.addChild(hBox);

		var label:Label = new Label();
		label.text = "Small radius";
		label.width = 90;
		hBox.addChild(label);

		var input:TextInput = new TextInput();
		input.restrict = "0-9.\\-";
		input.width = 90;
		input.addEventListener(FocusEvent.FOCUS_OUT, fixFloatBox, false, 999999999);
		input.addEventListener(FocusEvent.FOCUS_OUT, changeSmallR);
		input.text = Std.string(spiro.smallR);
		hBox.addChild(input);

		// pen radius --------------------------------------
		var hBox:LayoutGroup = new LayoutGroup();
		var hLayout:HorizontalLayout = new HorizontalLayout();
		hLayout.horizontalAlign = JUSTIFY;
		hLayout.verticalAlign = MIDDLE;
		hBox.layout = hLayout;
		group.addChild(hBox);

		var label:Label = new Label();
		label.text = "Pen radius";
		label.width = 90;
		hBox.addChild(label);

		var input:TextInput = new TextInput();
		input.restrict = "0-9.\\-";
		input.width = 90;
		input.addEventListener(FocusEvent.FOCUS_OUT, fixFloatBox, false, 999999999);
		input.addEventListener(FocusEvent.FOCUS_OUT, changePenR);
		input.text = Std.string(spiro.penR);
		hBox.addChild(input);

		// spins --------------------------------------
		var hBox:LayoutGroup = new LayoutGroup();
		var hLayout:HorizontalLayout = new HorizontalLayout();
		hLayout.horizontalAlign = JUSTIFY;
		hLayout.verticalAlign = MIDDLE;
		hBox.layout = hLayout;
		group.addChild(hBox);

		var label:Label = new Label();
		label.text = "Spins";
		label.width = 90;
		hBox.addChild(label);

		var input:TextInput = new TextInput();
		input.restrict = "0-9.\\-";
		input.width = 90;
		input.addEventListener(FocusEvent.FOCUS_OUT, fixFloatBox, false, 999999999);
		input.addEventListener(FocusEvent.FOCUS_OUT, changeSpins);
		input.text = Std.string(spiro.spins);
		hBox.addChild(input);

		// ##################################################
		// color settings
		var label:Label = new Label();
		label.text = "Colors";
		label.paddingTop = 20;
		label.width = 90;
		group.addChild(label);

		// pen thickness --------------------------------------
		var hBox:LayoutGroup = new LayoutGroup();
		var hLayout:HorizontalLayout = new HorizontalLayout();
		hLayout.horizontalAlign = JUSTIFY;
		hLayout.verticalAlign = MIDDLE;
		hBox.layout = hLayout;
		group.addChild(hBox);

		var label:Label = new Label();
		label.text = "Pen thickness";
		label.width = 100;
		hBox.addChild(label);

		var input:TextInput = new TextInput();
		input.restrict = "0-9.";
		input.width = 70;
		input.addEventListener(FocusEvent.FOCUS_OUT, fixFloatBox, false, 999999999);
		input.addEventListener(FocusEvent.FOCUS_OUT, changePenThicc);
		input.text = Std.string(spiro.thickness);
		hBox.addChild(input);

		// start color --------------------------------------
		var hBox:LayoutGroup = new LayoutGroup();
		var hLayout:HorizontalLayout = new HorizontalLayout();
		hLayout.horizontalAlign = JUSTIFY;
		hLayout.verticalAlign = MIDDLE;
		hBox.layout = hLayout;
		group.addChild(hBox);

		var label:Label = new Label();
		label.text = "Start color";
		label.width = 80;
		hBox.addChild(label);

		var input:TextInput = new TextInput();
		input.restrict = "0-9#a-f";
		input.width = 75;
		input.addEventListener(FocusEvent.FOCUS_OUT, fixHexBox, false, 999999999);
		input.addEventListener(FocusEvent.FOCUS_OUT, changeColor1);
		input.text = Std.string("#ff00ff");
		hBox.addChild(input);

		color1.graphics.beginFill(0xFF00FF, 1);
		color1.graphics.drawRect(5, 0, 20, 20);
		color1.graphics.endFill();
		hBox.addChild(color1);

		// end color --------------------------------------
		var hBox:LayoutGroup = new LayoutGroup();
		var hLayout:HorizontalLayout = new HorizontalLayout();
		hLayout.horizontalAlign = JUSTIFY;
		hLayout.verticalAlign = MIDDLE;
		hBox.layout = hLayout;
		group.addChild(hBox);

		var label:Label = new Label();
		label.text = "End color";
		label.width = 80;
		hBox.addChild(label);

		var input:TextInput = new TextInput();
		input.restrict = "0-9#a-f";
		input.width = 75;
		input.addEventListener(FocusEvent.FOCUS_OUT, fixHexBox, false, 999999999);
		input.addEventListener(FocusEvent.FOCUS_OUT, changeColor2);
		input.text = Std.string("#00ff00");
		hBox.addChild(input);

		color2.graphics.beginFill(0x00ff00, 1);
		color2.graphics.drawRect(5, 0, 20, 20);
		color2.graphics.endFill();
		hBox.addChild(color2);

		// bg color --------------------------------------
		var hBox:LayoutGroup = new LayoutGroup();
		var hLayout:HorizontalLayout = new HorizontalLayout();
		hLayout.horizontalAlign = JUSTIFY;
		hLayout.verticalAlign = MIDDLE;
		hBox.layout = hLayout;
		group.addChild(hBox);

		var label:Label = new Label();
		label.text = "Background color";
		label.width = 80;
		hBox.addChild(label);

		var input:TextInput = new TextInput();
		input.restrict = "0-9#a-f";
		input.width = 75;
		input.addEventListener(FocusEvent.FOCUS_OUT, fixHexBox, false, 999999999);
		input.addEventListener(FocusEvent.FOCUS_OUT, changeBgColor);
		input.text = Std.string("#000000");
		hBox.addChild(input);

		bgColor.graphics.beginFill(0x000000, 1);
		bgColor.graphics.drawRect(5, 0, 20, 20);
		bgColor.graphics.endFill();
		hBox.addChild(bgColor);

		// tween Mode --------------------------------------
		var label:Label = new Label();
		label.text = "Color tween mode";
		// label.width = 80;
		group.addChild(label);

		var hBox:LayoutGroup = new LayoutGroup();
		var hLayout:HorizontalLayout = new HorizontalLayout();
		hLayout.horizontalAlign = CENTER;
		hLayout.verticalAlign = MIDDLE;
		hBox.layout = hLayout;
		group.addChild(hBox);

		var label:Label = new Label();
		label.text = "RGB";
		// label.width = 80;
		hBox.addChild(label);

		var toggle:ToggleSwitch = new ToggleSwitch();
		toggle.selected = true;
		toggle.addEventListener(Event.CHANGE, changeTweenMode);
		hBox.addChild(toggle);

		var label:Label = new Label();
		label.text = "HSV";
		// label.width = 80;
		hBox.addChild(label);

		// ##################################################
		// Animation control
		var label:Label = new Label();
		label.text = "Animation";
		label.width = 90;
		label.paddingTop = 20;
		group.addChild(label);

		// start stop --------------------------------------------------
		addChild(group);
		var hBox:LayoutGroup = new LayoutGroup();
		var hLayout:HorizontalLayout = new HorizontalLayout();
		hLayout.horizontalAlign = CENTER;
		hLayout.verticalAlign = MIDDLE;
		hBox.layout = hLayout;
		group.addChild(hBox);

		var button = new Button();
		button.text = "Start ⏯️";
		button.addEventListener(MouseEvent.CLICK, play);
		hBox.addChild(button);

		var button = new Button();
		button.text = "Stop ⏹️";
		button.addEventListener(MouseEvent.CLICK, stop);
		hBox.addChild(button);

		// playback speed ---------------------------------------
		var hBox:LayoutGroup = new LayoutGroup();
		var hLayout:HorizontalLayout = new HorizontalLayout();
		hLayout.horizontalAlign = JUSTIFY;
		hLayout.verticalAlign = MIDDLE;
		hBox.layout = hLayout;
		group.addChild(hBox);

		var label:Label = new Label();
		label.text = "Duration";
		label.width = 90;
		hBox.addChild(label);

		var input:TextInput = new TextInput();
		input.restrict = "0-9.\\-";
		input.width = 90;
		input.addEventListener(FocusEvent.FOCUS_OUT, fixFloatBox, false, 999999999);
		input.addEventListener(FocusEvent.FOCUS_OUT, changeDuration);
		input.text = Std.string(animDuration);
		hBox.addChild(input);

		// fps --------------------------------------
		var hBox:LayoutGroup = new LayoutGroup();
		var hLayout:HorizontalLayout = new HorizontalLayout();
		hLayout.horizontalAlign = JUSTIFY;
		hLayout.verticalAlign = MIDDLE;
		hBox.layout = hLayout;
		group.addChild(hBox);

		var label:Label = new Label();
		label.text = "FPS";
		label.width = 90;
		hBox.addChild(label);

		var input:TextInput = new TextInput();
		input.restrict = "0-9.\\-";
		input.width = 90;
		input.addEventListener(FocusEvent.FOCUS_OUT, fixFloatBox, false, 999999999);
		input.addEventListener(FocusEvent.FOCUS_OUT, changeFPS);
		input.text = Std.string(fps);
		hBox.addChild(input);

		// loop --------------------------------------
		var hBox:LayoutGroup = new LayoutGroup();
		var hLayout:HorizontalLayout = new HorizontalLayout();
		hLayout.horizontalAlign = JUSTIFY;
		hLayout.verticalAlign = MIDDLE;
		hBox.layout = hLayout;
		group.addChild(hBox);

		var label:Label = new Label();
		label.text = "Loop";
		label.width = 90;
		hBox.addChild(label);

		var toggle:Check = new Check();
		toggle.selected = true;
		toggle.addEventListener(Event.CHANGE, changeLoop);
		hBox.addChild(toggle);

		// quality --------------------------------------
		var hBox:LayoutGroup = new LayoutGroup();
		var hLayout:HorizontalLayout = new HorizontalLayout();
		hLayout.horizontalAlign = JUSTIFY;
		hLayout.verticalAlign = MIDDLE;
		hBox.layout = hLayout;
		group.addChild(hBox);

		var label:Label = new Label();
		label.text = "Quality %";
		label.width = 90;
		hBox.addChild(label);

		var input:TextInput = new TextInput();
		input.restrict = "0-9";
		input.width = 90;
		input.addEventListener(FocusEvent.FOCUS_OUT, fixQualityBox, false, 999999999);
		input.addEventListener(FocusEvent.FOCUS_OUT, changeQuality);
		input.text = Std.string(quality);
		hBox.addChild(input);

		// save ------------------------------------
		addChild(group);
		var hBox:LayoutGroup = new LayoutGroup();
		var hLayout:HorizontalLayout = new HorizontalLayout();
		hLayout.horizontalAlign = CENTER;
		hLayout.verticalAlign = MIDDLE;
		hBox.layout = hLayout;
		group.addChild(hBox);

		var button = new Button();
		button.text = "Save gif 💾";
		button.addEventListener(MouseEvent.CLICK, save);
		hBox.addChild(button);

		resize(Lib.current.stage.stageWidth, Lib.current.stage.stageHeight);
	}

	public function resize(w:Int, h:Int) {
		group.height = h;
	}

	private function stop(_) {
		Actuate.reset();
	}

	private function play(_) {
		Actuate.reset();
		Actuate.timer(0.001).onComplete(() -> spiro.draw(animDuration, tweenMode)); // skip a frame
	}

	private function save(_) {
		var progress = new HProgressBar();
		progress.minimum = 0;
		progress.maximum = 1;
		progress.value = 0;

		function updateStatus(current:Int, total:Int) {
			progress.value = current / total;
			if (current == total) {
				trace("complete");
				PopUpManager.removePopUp(progress);
				if (progress.parent != null) {
					progress.parent.removeChild(progress);
				}
			}
		}

		spiro.save(animDuration, fps, loop, quality, tweenMode, updateStatus);

		PopUpManager.addPopUp(progress, stage);
	}

	private function fixFloatBox(e:FocusEvent) {
		cast(e.currentTarget, TextInput).text = Std.string(Std.parseFloat(cast(e.currentTarget, TextInput).text));
		if (cast(e.currentTarget, TextInput).text == "NaN") {
			cast(e.currentTarget, TextInput).text = "0";
		}
	}

	private function fixHexBox(e:FocusEvent) {
		if (cast(e.currentTarget, TextInput).text.indexOf("#") != 0) {
			cast(e.currentTarget, TextInput).text = "#" + cast(e.currentTarget, TextInput).text;
		}
		cast(e.currentTarget, TextInput).text = cast(e.currentTarget, TextInput).text.rpad("0", 7);

		var int = Std.parseInt(cast(e.currentTarget, TextInput).text.replace("#", "0x0"));
		if (int == null) {
			cast(e.currentTarget, TextInput).text = "0xFFFFFF";
		}
	}

	private function fixQualityBox(e:FocusEvent) {
		quality = Std.parseInt(cast(e.currentTarget, TextInput).text);
		if (quality == null || quality == 0) {
			cast(e.currentTarget, TextInput).text = "100";
		}
	}

	private function changeQuality(e:FocusEvent) {
		quality = Std.int(Math.max(Math.min(Std.parseInt(cast(e.currentTarget, TextInput).text), 100), 1));
		cast(e.currentTarget, TextInput).text = Std.string(quality);
	}

	private function changeBigR(e:FocusEvent) {
		spiro.bigR = Std.parseFloat(cast(e.currentTarget, TextInput).text);
	}

	private function changeSmallR(e:FocusEvent) {
		spiro.smallR = Std.parseFloat(cast(e.currentTarget, TextInput).text);
	}

	private function changePenR(e:FocusEvent) {
		spiro.penR = Std.parseFloat(cast(e.currentTarget, TextInput).text);
	}

	private function changePenThicc(e:FocusEvent) {
		spiro.thickness = Std.parseFloat(cast(e.currentTarget, TextInput).text);
	}

	private function changeDuration(e:FocusEvent) {
		animDuration = Std.parseFloat(cast(e.currentTarget, TextInput).text);
	}

	private function changeFPS(e:FocusEvent) {
		fps = Math.max(Std.parseFloat(cast(e.currentTarget, TextInput).text), 2);
		cast(e.currentTarget, TextInput).text = Std.string(fps);
	}

	private function changeColor1(e:FocusEvent) {
		spiro.color1 = Std.parseInt(cast(e.currentTarget, TextInput).text.replace("#", "0x0"));
		color1.graphics.clear();
		color1.graphics.beginFill(spiro.color1, 1);
		color1.graphics.drawRect(5, 0, 20, 20);
		color1.graphics.endFill();
	}

	private function changeColor2(e:FocusEvent) {
		spiro.color2 = Std.parseInt(cast(e.currentTarget, TextInput).text.replace("#", "0x0"));
		color2.graphics.clear();
		color2.graphics.beginFill(spiro.color2, 1);
		color2.graphics.drawRect(5, 0, 20, 20);
		color2.graphics.endFill();
	}

	private function changeBgColor(e:FocusEvent) {
		spiro.argbBackgroundColor = 0xFF000000 + Std.parseInt(cast(e.currentTarget, TextInput).text.replace("#", "0x0"));
		bgColor.graphics.clear();
		bgColor.graphics.beginFill(Std.parseInt(cast(e.currentTarget, TextInput).text.replace("#", "0x0")), 1);
		bgColor.graphics.drawRect(5, 0, 20, 20);
		bgColor.graphics.endFill();

		Lib.current.stage.color = Std.parseInt(cast(e.currentTarget, TextInput).text.replace("#", "0x0"));
	}

	private function changeTweenMode(e:Event) {
		tweenMode = cast(e.currentTarget, ToggleSwitch).selected ? HSV : RGB;
	}

	private function changeLoop(e:Event) {
		loop = cast(e.currentTarget, ToggleSwitch).selected;
	}

	private function changeSpins(e:FocusEvent) {
		spiro.spins = Std.parseFloat(cast(e.currentTarget, TextInput).text);
		if (spiro.spins == 0) {
			spiro.spins = -1;
			cast(e.currentTarget, TextInput).text = "-1";
		}
	}
}
