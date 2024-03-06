"Filed out from Dolphin Smalltalk"!

UI.AbstractListTreeViewStateImageManager
	subclass: #'UI.ListTreeViewStateImageManager'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!

UI.ListTreeViewStateImageManager guid: (Core.GUID fromString: '{6c9cd848-51e2-470a-a6f8-ef40ade7c076}')!

UI.ListTreeViewStateImageManager comment: ''!

!UI.ListTreeViewStateImageManager categoriesForClass!Graphics-Tools! !

!UI.ListTreeViewStateImageManager methodsFor!

addExpandos: aWinImageList forDpi: anInteger
	| rect bitmap hTheme extent |
	hTheme := UxTheme
				openThemeDataForDpi: nil
				pszClassList: 'Explorer::TreeView'
				dpi: anInteger.
	extent := aWinImageList extent.
	rect := RECTL extent: extent.
	"Image for expanded state"
	bitmap := Bitmap displayCompatibleWithExtent: extent.
	UxTheme
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
	UxTheme
		drawThemeBackground: hTheme
		hdc: bitmap canvas asParameter
		iPartId: ThemeConstants.TVP_GLYPH
		iStateId: ThemeConstants.GLPS_CLOSED
		pRect: rect
		pClipRect: nil.
	aWinImageList addBitmap: bitmap mask: Color white.
	bitmap free.
	UxTheme closeThemeData: hTheme! !

!UI.ListTreeViewStateImageManager categoriesForMethods!
addExpandos:forDpi:!helpers!private! !
!

