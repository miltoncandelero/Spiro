package;

import lime.ui.FileDialog;
import openfl.display.PNGEncoderOptions;
import openfl.utils.ByteArray;
import openfl.display.BitmapData;
import openfl.events.Event;
import openfl.display.FPS;
import openfl.display.Sprite;

class Main extends Sprite {
	var ui:UI;
	var spiro:Spiro;

	public function new() {
		super();
		spiro = new Spiro(300, 198, 110, 2 * 3.14 / 1000, -1);

		// spiro.scaleX = spiro.scaleY = 10;
		addChild(spiro);

		spiro.color1 = 0xFF0000;
		spiro.color2 = 0xFF00FF;
		spiro.draw(0, HSV);
		// spiro.save(10, 60, 0xFF000000, HSV, status);
		addChild(new FPS(0xFFFFFF));

		ui = new UI(spiro);
		addChild(ui);

		// spiro.bigR = 30;
		// spiro.smallR = 19.8;
		// spiro.penR = 11;
		// spiro.thickness = 0.5;
		// spiro.draw(0, HSV);

		// var bData:BitmapData = new BitmapData(Std.int(spiro.width), Std.int(spiro.height), true, 0x0);
		// bData.draw(this, new openfl.geom.Matrix(1, 0, 0, 1, spiro.width / 2, spiro.height / 2));
		// saveImage(bData);

		stage.addEventListener(Event.RESIZE, onResize);
	}

	public function status(curr:Int, total:Int) {
		trace(curr + "/" + total);
	}

	private function onResize(_) {
		ui.resize(stage.stageWidth, stage.stageHeight);
		spiro.x = (stage.stageWidth + 210) / 2; // +210 of ui
		spiro.y = stage.stageHeight / 2;
	}

	// This is not a real .hx class file. Drop this into a class you see fit.
	// Feed it a bitmap data and save it to PNG.
	public static function saveImage(bitmapData:BitmapData) {
		var b:ByteArray = new ByteArray();
		b = bitmapData.encode(bitmapData.rect, new PNGEncoderOptions(true), b);
		new FileDialog().save(b, "png", null, "file");
	}
}
