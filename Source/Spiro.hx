package;

import gif.Gif;
import openfl.display.BitmapData;
import lime.math.RGBA;
import openfl.geom.ColorTransform;
import motion.easing.Linear;
import openfl.display.GradientType;
import openfl.display.Shape;
import motion.Actuate;

class Spiro extends Shape {
	/**
	 * Distance from the center of the small cog to the pen
	 */
	public var penR:Float;

	/**
	 * Radius of the small cog
	 */
	public var smallR:Float;

	/**
	 * Radius of the big cog
	 */
	public var bigR:Float;

	public var resolution:Float;
	public var spins:Float;

	public var color1:Int = 0x0;
	public var color2:Int = 0x0;

	public var thickness:Float = 1;

	public var argbBackgroundColor:Int = 0xFF000000;

	var result:Array<Float> = [];

	public function new(bigR:Float, smallR:Float, penR:Float, resolution:Float = 2 * 3.14 / 1000, spins:Float = 5) {
		super();
		this.penR = penR;
		this.smallR = smallR;
		this.bigR = bigR;
		this.resolution = resolution;
		this.spins = spins;

		// draw(0, RGB);
	}

	public function draw(duration:Float = 10, tweenMode:ColorMode) {
		generate();
		var steps:Int = Std.int(result.length / 2);
		var interval:Float = duration / steps;
		trace(interval);
		graphics.clear();
		graphics.lineStyle(1, 0x0);
		graphics.moveTo(result[0], result[1]);

		for (i in 0...steps) {
			Actuate.timer(i * interval).onComplete(() -> {
				if (color1 != color2) {
					if (i % Std.int(steps / 10) == 0) {
						switch tweenMode {
							case HSV:
								graphics.lineStyle(thickness, ColorMathUtil.lerpHSV(color1, color2, i / steps));
							case RGB:
								graphics.lineStyle(thickness, ColorMathUtil.lerpRGB(color1, color2, i / steps));
						}
					}
				}
				graphics.lineTo(result[i * 2], result[i * 2 + 1]);
			});
		}
	}

	public function save(duration:Float = 10, fps:Float = 15, loop:Bool = true, quality:Int = 90, tweenMode:ColorMode, updateStatus:(Int, Int) -> Void) {
		generate();
		var steps:Int = Std.int(result.length / 2);
		var interval:Float = duration / steps;
		var spf:Float = 1 / fps;

		graphics.clear();
		graphics.lineStyle(1, 0x0);
		graphics.moveTo(result[0], result[1]);

		for (i in 0...steps) {
			graphics.lineTo(result[i * 2], result[i * 2 + 1]);
		}
		var auxW:Int = Math.ceil(width + thickness * 2 + 2);
		var auxH:Int = Math.ceil(height + thickness * 2 + 2);
		var offW:Int = Math.ceil(-getRect(this).x + thickness + 1);
		var offH:Int = Math.ceil(-getRect(this).y + thickness + 1);

		graphics.clear();
		graphics.lineStyle(1, 0x0);
		graphics.moveTo(result[0], result[1]);

		var gif = new Gif(auxW, auxH, spf, // delay in seconds
			loop ? -1 : 0, // Infinite = -1, None = 0
			100 - quality, // Worst = 100, Best = 1
			1 // 1 - noskip, 2 - skip every second frame, 3 - every third
		);

		var bData:BitmapData = new BitmapData(auxW, auxH, true, argbBackgroundColor);
		bData.draw(this, new openfl.geom.Matrix(1, 0, 0, 1, offW, offH));
		gif.addFrame(bData);

		var fpsAux:Float = 0;

		function loop(lasti:Int) {
			for (i in lasti...steps) {
				if (color1 != color2) {
					// if (i % Std.int(steps / 10) == 0) {
					switch tweenMode {
						case HSV:
							graphics.lineStyle(thickness, ColorMathUtil.lerpHSV(color1, color2, i / steps));
						case RGB:
							graphics.lineStyle(thickness, ColorMathUtil.lerpRGB(color1, color2, i / steps));
					}
					// }
				}
				graphics.lineTo(result[i * 2], result[i * 2 + 1]);

				fpsAux += interval;

				if (fpsAux > spf) {
					fpsAux = 0;
					var bData:BitmapData = new BitmapData(auxW, auxH, true, argbBackgroundColor);
					bData.draw(this, new openfl.geom.Matrix(1, 0, 0, 1, offW, offH));
					gif.addFrame(bData);
					updateStatus(i, steps);
					Actuate.timer(0.01).onComplete(loop, [i + 1]);
					return;
				}
			}

			var bData:BitmapData = new BitmapData(auxW, auxH, true, argbBackgroundColor);
			bData.draw(this, new openfl.geom.Matrix(1, 0, 0, 1, offW, offH));
			gif.addFrame(bData);
			gif.save("spiro.gif");
			updateStatus(steps, steps);
		}

		loop(0);
	}

	private function generate() {
		trace("beginning generation");
		trace("big R " + bigR);
		trace("small R " + smallR);
		trace("pen R " + penR);
		var theta:Float = 0;

		var internalSpins:Float = 0;
		if (spins <= 0) {
			while (internalSpins < 1000) {
				internalSpins++;
				if (Math.abs(solveX(0) - solveX(2 * Math.PI * internalSpins)) < resolution
					&& Math.abs(solveY(0) - solveY(2 * Math.PI * internalSpins)) < resolution) {
					break;
				}
			}
		} else {
			internalSpins = spins;
		}
		trace("found soluton @ " + internalSpins);

		result.splice(0, result.length);

		while (theta < 2 * Math.PI * internalSpins) {
			var x = solveX(theta);
			var y = solveY(theta);
			// graphics.lineTo(x, y);
			result.push(x);
			result.push(y);
			theta += resolution;
		}
	}

	private inline function solveX(theta:Float):Float {
		return (bigR - smallR) * Math.cos(theta) + penR * Math.cos((bigR - smallR) / smallR * theta);
	}

	private inline function solveY(theta:Float):Float {
		return (bigR - smallR) * Math.sin(theta) - penR * Math.sin((bigR - smallR) / smallR * theta);
	}
}

enum ColorMode {
	HSV;
	RGB;
}
