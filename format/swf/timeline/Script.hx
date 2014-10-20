package format.swf.timeline;

import format.swf.tags.ITag;
import format.swf.tags.TagPlaceObject;

class ScriptElement {
	
	private var firstFrame:Int;
	
	private var matrixArray:Array<Int>;
	private var colorTransformArray:Array<Int>;
	private var nameArray:Array<Int>;
	private var filterListArray:Array<Int>;
	private var ratioArray:Array<Int>;
	
	public function new( firstFrame:Int ) {
		
		this.firstFrame = firstFrame;
		
		matrixArray = new Array<Int>();
		colorTransformArray = new Array<Int>();
		nameArray = new Array<Int>();
		filterListArray = new Array<Int>();
		ratioArray = new Array<Int>();
	}
	
	public function add( tags:Array<ITag>, frameObject:FrameObject  ):Void {
		
		var index:Int;
		var tag:TagPlaceObject;
		
		tag = null;
		
		if ( frameObject.lastModifiedAtIndex > 0 )
			index = frameObject.lastModifiedAtIndex;
		else
			index = frameObject.placedAtIndex;
		
		tag = cast tags[ index ];
		
		if ( tag == null )
			tag = cast tags[ index ];
		
		if ( tag.hasMatrix )
			matrixArray.push( index );
		else if ( matrixArray.length != 0 )
			matrixArray.push( matrixArray[ matrixArray.length - 1 ] );
		else
			matrixArray.push( -1 );
		
		if ( tag.hasColorTransform )
			colorTransformArray.push( index );
		else if ( colorTransformArray.length != 0 )
			colorTransformArray.push( colorTransformArray[ colorTransformArray.length - 1 ] );
		else
			colorTransformArray.push( -1 );
		
		if ( tag.hasName )
			nameArray.push( index );
		else if ( nameArray.length != 0 )
			nameArray.push( nameArray[ nameArray.length - 1 ] );
		else
			nameArray.push( -1 );
		
		if ( tag.hasFilterList )
			filterListArray.push( index );
		else if ( filterListArray.length != 0 )
			filterListArray.push( filterListArray[ filterListArray.length - 1 ] );
		else
			filterListArray.push( -1 );
		
		if ( tag.hasRatio )
			ratioArray.push( index );
		else if ( ratioArray.length != 0 )
			ratioArray.push( ratioArray[ ratioArray.length - 1 ] );
		else
			ratioArray.push( -1 );
	}
	
	public function getMatrix( frame:Int ):Int {
		
		return matrixArray [ frame - firstFrame ];
	}
	
	public function getColor( frame:Int ):Int {
		
		return colorTransformArray [ frame - firstFrame ];
	}
	
	public function getFilterList( frame:Int ):Int {
		
		return filterListArray [ frame - firstFrame ];
	}
	
	public function getName( frame:Int ):Int {
		
		return nameArray [ frame - firstFrame ];
	}
	
	public function getRatio( frame:Int ):Int {
		
		return ratioArray [ frame - firstFrame ];
	}
	
	public function toString():String {
		
		var line1:String;
		var line2:String;
		var line3:String;
		var line4:String;
		var line5:String;
		var line6:String;
		
		line1 = formatIndexes( 6, 4, " | ", matrixArray.length );
		line2 = formatArray( 6, 4, " | ", "matrix", matrixArray );
		line3 = formatArray( 6, 4, " | ", "color", colorTransformArray );
		line4 = formatArray( 6, 4, " | ", "name", nameArray );
		line5 = formatArray( 6, 4, " | ", "filter", filterListArray );
		line6 = formatArray( 6, 4, " | ", "ratio", ratioArray );
		
		return( line1 + "\n" + line2 + "\n" + line3 + "\n" + line4 + "\n" + line5 + "\n" + line6 );
	}
	
	private function formatIndexes( titleLength:Int, valueLength:Int, separator:String, length:Int ):String {
		
		var indexesArray:Array<Int>;
		var i:Int;
		
		indexesArray = new Array<Int>();
		
		for ( i in 0...length )
			indexesArray.push( firstFrame + i );
		
		return formatArray( titleLength, valueLength, separator, "index", indexesArray );
	}
	
	private function formatArray( titleLength:Int, valueLength:Int, separator:String, title:String, array:Array<Int> ):String {
		
		var res:String;
		var value:Int;
		
		res = formatString( title, titleLength );
		
		for ( value in array ) {
			
			res += separator;
			res += formatString( Std.string( value ), valueLength );
		}
		
		return res;
	}
	
	private function formatString( v:String, length:Int ):String {
		
		var res:String;
		
		res = v;
		while ( res.length < length )
			res = " " + res;
			
		return res;
	}
}

class Script {
	
	private var scriptElements:Map<Int,ScriptElement>;

	public function new() {
		
		scriptElements = new Map<Int,ScriptElement>();
	}
	
	public function pushFrame( tags:Array<ITag>, frame:Frame ):Void {
		
		var frameObject:FrameObject;
		
		for ( frameObject in frame.objects ) {
			
			if ( !scriptElements.exists( frameObject.id ) )
				scriptElements.set( frameObject.id, new ScriptElement( frame.frameNumber ) );
			
			scriptElements[ frameObject.id ].add( tags, frameObject );
		}
	}
	
	public function matrixLastModifiedAt( id:Int, frame:Int ):Int {
		
		return scriptElements[ id ].getMatrix( frame );
	}
	
	public function colorLastModifiedAt( id:Int, frame:Int ):Int {
		
		return scriptElements[ id ].getColor( frame );
	}
	
	public function filtersLastModifiedAt( id:Int, frame:Int ):Int {
		
		return scriptElements[ id ].getFilterList( frame );
	}
	
	public function nameLastModifiedAt( id:Int, frame:Int ):Int {
		
		return scriptElements[ id ].getName( frame );
	}
	
	public function ratioLastModifiedAt( id:Int, frame:Int ):Int {
		
		return scriptElements[ id ].getRatio( frame );
	}
	
	public function toString():String {
		
		var res:String;
		var id:Int;
		
		res = "";
		
		for ( id in scriptElements.keys() ) {
			
			res += "id " + Std.string( id ) + "\r";
			res += scriptElements.get( id ).toString() + "\r";
		}
		
		return res;
	}
}