package nochump.util.zip;

import flash.utils.ByteArray;


/**
 * Computes CRC32 data checksum of a data stream.
 * The actual CRC32 algorithm is described in RFC 1952
 * (GZIP file format specification version 4.3).
 * 
 * @author David Chang
 * @date January 2, 2007.
 */
class CRC32  {
	
	/** The crc data checksum so far. */
	private var crc:Int;
	/** The fast CRC table. Computed once when the CRC32 class is loaded. */
	private static var crcTable:Array<Dynamic> = makeCrcTable();
	

	/** Make the table for a fast CRC. */
	private static function makeCrcTable():Array<Dynamic> {
		
		var crcTable:Array<Dynamic> = new Array<Dynamic>();
		var n:Int = 0;
		while (n < 256) {
			var c:Int = n;
			var k:Int = 8;
			while (--k >= 0) {
				if ((c & 1) != 0) {
					c = 0xedb88320 ^ (c >>> 1);
				} else {
					c = c >>> 1;
				}
			}

			crcTable[n] = c;
			
			// update loop variables
			n++;
		}

		return crcTable;
	}

	/**
	 * Returns the CRC32 data checksum computed so far.
	 */
	public function getValue():Int {
		
		return crc & 0xffffffff;
	}

	/**
	 * Resets the CRC32 data checksum as if no update was ever called.
	 */
	public function reset():Void {
		
		crc = 0;
	}

	/**
	 * Adds the complete byte array to the data checksum.
	 * 
	 * @param buf the buffer which contains the data
	 */
	public function update(buf:ByteArray):Void {
		
		var off:Int = 0;
		var len:Int = buf.length;
		var c:Int = ~crc;
		while (--len >= 0) {
			c = crcTable[(c ^ Reflect.field(buf, off++)) & 0xff] ^ (c >>> 8);
		}

		crc = ~c;
	}

	// autogenerated
	public function new () {
		
		OPPOSITE_OR[X | X] = N;
		OPPOSITE_OR[XY | X] = Y;
		OPPOSITE_OR[XZ | X] = Z;
		OPPOSITE_OR[XYZ | X] = YZ;
		OPPOSITE_OR[Y | Y] = N;
		OPPOSITE_OR[XY | Y] = X;
		OPPOSITE_OR[XYZ | Y] = XZ;
		OPPOSITE_OR[YZ | Y] = Z;
		OPPOSITE_OR[Z | Z] = N;
		OPPOSITE_OR[XZ | Z] = X;
		OPPOSITE_OR[XYZ | Z] = XY;
		OPPOSITE_OR[YZ | Z] = Y;
		SCALINGS[1] = [1, 1, 1];
		SCALINGS[2] = [-1, 1, 1];
		SCALINGS[4] = [-1, 1, -1];
		SCALINGS[8] = [1, 1, -1];
		SCALINGS[16] = [1, -1, 1];
		SCALINGS[32] = [-1, -1, 1];
		SCALINGS[64] = [-1, -1, -1];
		SCALINGS[128] = [1, -1, -1];
	}

	

}

