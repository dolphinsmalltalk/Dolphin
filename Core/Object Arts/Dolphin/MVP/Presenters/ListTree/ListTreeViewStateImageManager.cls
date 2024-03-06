"Filed out from Dolphin Smalltalk"!

AbstractListTreeViewStateImageManager subclass: #ListTreeViewStateImageManager
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!

ListTreeViewStateImageManager guid: (GUID fromString: '{6c9cd848-51e2-470a-a6f8-ef40ade7c076}')!

ListTreeViewStateImageManager comment: ''!

!ListTreeViewStateImageManager categoriesForClass!Graphics-Tools! !

!ListTreeViewStateImageManager methodsFor!

addExpandos: aWinImageList forDpi: anInteger
	| themeLib rect bitmap hTheme extent |
	themeLib := ThemeLibrary default.
	hTheme := themeLib
				openThemeDataForDpi: nil
				pszClassList: 'Explorer::TreeView'
				dpi: anInteger.
	extent := aWinImageList extent.
	rect := RECT extent: extent.
	"Image for expanded state"
	bitmap := Bitmap displayCompatibleWithExtent: extent.
	themeLib
		drawThemeBackground: hTheme
		hdc: bitmap canvas asParameter
		iPartId: ThemeConstants.TVP_GLYPH
		iStateId: ThemeConstants.GLPS_OPENED
		pRect: rect
		pClipRect: nil.
	aWinImageList addBitmap: bitmap mask: Color white.
	bitmap free.

	"Image for collapsed state"
	bitmap := Bitmap displayCompatibleWithExtent: extent.
	themeLib
		drawThemeBackground: hTheme
		hdc: bitmap canvas asParameter
		iPartId: ThemeConstants.TVP_GLYPH
		iStateId: ThemeConstants.GLPS_CLOSED
		pRect: rect
		pClipRect: nil.
	aWinImageList addBitmap: bitmap mask: Color white.
	bitmap free.
	themeLib closeThemeData: hTheme! !

!ListTreeViewStateImageManager categoriesForMethods!
addExpandos:forDpi:!helpers!private! !
!

