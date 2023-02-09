"Filed out from Dolphin Smalltalk"!

Graphics.Gdiplus.ImageInitializer subclass: #'Graphics.Gdiplus.BitmapInitializer'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {
		'PixelFormats' -> (IdentityDictionary withAll: {16r0 -> 'PixelFormatDontCare'. 16r10000 -> 'PixelFormatIndexed'. 16r61007 -> 'PixelFormat16bppARGB1555'. 16r200000 -> 'PixelFormatCanonical'. 16r40000 -> 'PixelFormatAlpha'. 16r30101 -> 'PixelFormat1bppIndexed'. 16r30402 -> 'PixelFormat4bppIndexed'. 16r101004 -> 'PixelFormat16bppGrayScale'. 16r34400D -> 'PixelFormat64bppARGB'. 16r21006 -> 'PixelFormat16bppRGB565'. 16rF -> 'PixelFormatMax'. 16r30803 -> 'PixelFormat8bppIndexed'. 16r22009 -> 'PixelFormat32bppRGB'. 16rE200B -> 'PixelFormat32bppPARGB'. 16r1C400E -> 'PixelFormat64bppPARGB'. 16r10300C -> 'PixelFormat48bppRGB'. 16r100000 -> 'PixelFormatExtended'. 16r21808 -> 'PixelFormat24bppRGB'. 16r21005 -> 'PixelFormat16bppRGB555'. 16r20000 -> 'PixelFormatGDI'. 16r26200A -> 'PixelFormat32bppARGB'. 16r80000 -> 'PixelFormatPAlpha'})
	}!
Graphics.Gdiplus.BitmapInitializer guid: (Core.GUID fromString: '{646505b6-e90d-4aef-a2a3-cb87d01e9dde}')!
Graphics.Gdiplus.BitmapInitializer isNonInstantiable: true!
Graphics.Gdiplus.BitmapInitializer comment: ''!
!Graphics.Gdiplus.BitmapInitializer class methodsFor!

nameOfPixelFormat: aPixelFormat
	^PixelFormats at: aPixelFormat ifAbsent: ['PixelFormatDontCare']! !
!Graphics.Gdiplus.BitmapInitializer class categoriesForMethods!
nameOfPixelFormat:!public!realizing/unrealizing! !
!

