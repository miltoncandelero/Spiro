// http://blog.mindfock.com/rgb-to-hexadecimal-to-hsv-conversion-in-as3/
package;

class ColorMathUtil {
	public static function rgbToHex(r:Int, g:Int, b:Int):Int {
		var hex:Int = (r << 16 | g << 8 | b);
		return hex;
	}

	public static function hexToRGB(hex:Int):Array<Int> {
		var rgb:Array<Int> = [];

		var r:Int = hex >> 16 & 0xFF;
		var g:Int = hex >> 8 & 0xFF;
		var b:Int = hex & 0xFF;

		rgb.push(r);
		rgb.push(g);
		rgb.push(b);
		return rgb;
	}

	public static function hexToHsv(color:Int):Array<Float> {
		var colors:Array<Int> = hexToRGB(color);
		return RGBtoHSV(colors[0], colors[1], colors[2]);
	}

	public static function hsvToHex(h:Float, s:Float, v:Float):Int {
		var colors:Array<Int> = HSVtoRGB(h, s, v);
		return rgbToHex(colors[0], colors[1], colors[2]);
	}

	/**
	 * Converts Red, Green, Blue to Hue, Saturation, Value
	 * @r channel between 0-255
	 * @s channel between 0-255
	 * @v channel between 0-255
	 */
	public static function RGBtoHSV(r:Int, g:Int, b:Int):Array<Float> {
		var max:Int = Std.int(Math.max(Math.max(r, g), b));
		var min:Int = Std.int(Math.min(Math.min(r, g), b));

		var hue:Float = 0;
		var saturation:Float = 0;
		var value:Float = 0;

		var hsv:Array<Float> = [];

		// get Hue
		if (max == min) {
			hue = 0;
		} else if (max == r) {
			hue = (60 * (g - b) / (max - min) + 360) % 360;
		} else if (max == g) {
			hue = (60 * (b - r) / (max - min) + 120);
		} else if (max == b) {
			hue = (60 * (r - g) / (max - min) + 240);
		}

		// get Value
		value = max;

		// get Saturation
		if (max == 0) {
			saturation = 0;
		} else {
			saturation = (max - min) / max;
		}

		hsv = [Math.round(hue), Math.round(saturation * 100), Math.round(value / 255 * 100)];
		return hsv;
	}

	/**
	 * Converts Hue, Saturation, Value to Red, Green, Blue
	 * @h Angle between 0-360
	 * @s percent between 0-100
	 * @v percent between 0-100
	 */
	public static function HSVtoRGB(h:Float, s:Float, v:Float):Array<Int> {
		var r:Float = 0;
		var g:Float = 0;
		var b:Float = 0;
		var rgb:Array<Int> = [];

		var tempS:Float = s / 100;
		var tempV:Float = v / 100;

		var hi:Int = Math.floor(h / 60) % 6;
		var f:Float = h / 60 - Math.floor(h / 60);
		var p:Float = (tempV * (1 - tempS));
		var q:Float = (tempV * (1 - f * tempS));
		var t:Float = (tempV * (1 - (1 - f) * tempS));

		switch (hi) {
			case 0:
				r = tempV;
				g = t;
				b = p;

			case 1:
				r = q;
				g = tempV;
				b = p;

			case 2:
				r = p;
				g = tempV;
				b = t;

			case 3:
				r = p;
				g = q;
				b = tempV;

			case 4:
				r = t;
				g = p;
				b = tempV;

			case 5:
				r = tempV;
				g = p;
				b = q;
		}

		rgb = [Math.round(r * 255), Math.round(g * 255), Math.round(b * 255)];
		return rgb;
	}

	public static function lerpHSV(start:Int, end:Int, ratio:Float):Int {
		// a + ratio * (b - a);
		var a = hexToHsv(start);
		var b = hexToHsv(end);
		var c:Array<Float> = [];
		c[0] = a[0] + ratio * (b[0] - a[0]);
		c[1] = a[1] + ratio * (b[1] - a[1]);
		c[2] = a[2] + ratio * (b[2] - a[2]);
		return hsvToHex(c[0], c[1], c[2]);
	}

	public static function lerpRGB(start:Int, end:Int, ratio:Float):Int {
		// a + ratio * (b - a);
		var a = hexToRGB(start);
		var b = hexToRGB(end);
		var c:Array<Int> = [];
		c[0] = Math.round(a[0] + ratio * (b[0] - a[0]));
		c[1] = Math.round(a[1] + ratio * (b[1] - a[1]));
		c[2] = Math.round(a[2] + ratio * (b[2] - a[2]));
		return rgbToHex(c[0], c[1], c[2]);
	}
}
