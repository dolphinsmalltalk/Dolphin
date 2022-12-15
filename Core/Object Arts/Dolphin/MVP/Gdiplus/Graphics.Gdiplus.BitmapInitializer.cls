"Filed out from Dolphin Smalltalk"!

Graphics.Gdiplus.ImageInitializer subclass: #'Graphics.Gdiplus.BitmapInitializer'
	instanceVariableNames: ''
	classVariableNames: 'PixelFormats'
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!
Graphics.Gdiplus.BitmapInitializer guid: (Core.GUID fromString: '{646505b6-e90d-4aef-a2a3-cb87d01e9dde}')!
Graphics.Gdiplus.BitmapInitializer isNonInstantiable: true!
Graphics.Gdiplus.BitmapInitializer comment: ''!
!Graphics.Gdiplus.BitmapInitializer class methodsFor!

initialize
	| pixelFormats |
	pixelFormats := IdentityDictionary new
				at: 0 put: 'PixelFormatDontCare';
				at: 15 put: 'PixelFormatMax';
				at: 65536 put: 'PixelFormatIndexed';
				at: 131072 put: 'PixelFormatGDI';
				at: 135173 put: 'PixelFormat16bppRGB555';
				at: 135174 put: 'PixelFormat16bppRGB565';
				at: 137224 put: 'PixelFormat24bppRGB';
				at: 139273 put: 'PixelFormat32bppRGB';
				at: 196865 put: 'PixelFormat1bppIndexed';
				at: 197634 put: 'PixelFormat4bppIndexed';
				at: 198659 put: 'PixelFormat8bppIndexed';
				at: 262144 put: 'PixelFormatAlpha';
				at: 397319 put: 'PixelFormat16bppARGB1555';
				at: 524288 put: 'PixelFormatPAlpha';
				at: 925707 put: 'PixelFormat32bppPARGB';
				at: 1048576 put: 'PixelFormatExtended';
				at: 1052676 put: 'PixelFormat16bppGrayScale';
				at: 1060876 put: 'PixelFormat48bppRGB';
				at: 1851406 put: 'PixelFormat64bppPARGB';
				at: 2097152 put: 'PixelFormatCanonical';
				at: 2498570 put: 'PixelFormat32bppARGB';
				at: 3424269 put: 'PixelFormat64bppARGB';
				yourself.
	self addClassConstant: 'PixelFormats' value: pixelFormats!

nameOfPixelFormat: aPixelFormat
	^PixelFormats at: aPixelFormat ifAbsent: ['PixelFormatDontCare']! !
!Graphics.Gdiplus.BitmapInitializer class categoriesForMethods!
initialize!class initialization!public! !
nameOfPixelFormat:!public!realizing/unrealizing! !
!

