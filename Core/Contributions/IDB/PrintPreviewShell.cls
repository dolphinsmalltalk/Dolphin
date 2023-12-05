"Filed out from Dolphin Smalltalk"!

Shell subclass: #PrintPreviewShell
	instanceVariableNames: 'image documentView printer currentPage bitmap lastPage'
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
PrintPreviewShell guid: (GUID fromString: '{9bc31592-f010-4eb2-952d-c7fb44733b01}')!
PrintPreviewShell comment: 'See [DolphinImageFolder]/Idb/Documentation for details

(C) 2006 Ian Bartholomew
ian@idb.me.uk
Public Domain Freeware'!
!PrintPreviewShell categoriesForClass!IDB Goodies! !
!PrintPreviewShell methodsFor!

bitmap: aBitmap
	bitmap := aBitmap!

canPageBack
	^currentPage notNil and: [currentPage > 1]!

canPageForward
	^currentPage notNil and: [lastPage notNil and: [currentPage < lastPage]]!

centreImage
	image view parentView scrollOffset: (image view width // 2 - (view getWindowRect width // 2)) @ 0!

createComponents
	super createComponents.
	image := self add: ImagePresenter new name: 'image'!

currentPage
	^currentPage!

displayCurrentPage
	printer printPreview: documentView for: self.
	currentPage > lastPage
		ifTrue: 
			[currentPage := lastPage.
			printer printPreview: documentView for: self].
	"We need to discard the bitmap DC because it will be a printer DC, not a display DC"
	image value: bitmap.
	self caption: '<1d> of <2d>' << { currentPage. lastPage }!

hasMultiplePages
	^currentPage notNil and: [lastPage notNil and: [currentPage < lastPage]]!

lastPage: anInteger
	lastPage := anInteger!

moveToFirstPage
	<commandQuery: #canPageBack>
	currentPage := 1.
	self displayCurrentPage!

moveToLastPage
	<commandQuery: #canPageForward>
	currentPage := lastPage.
	self displayCurrentPage!

moveToNextPage
	<commandQuery: #canPageForward>
	currentPage := currentPage + 1.
	self displayCurrentPage!

moveToPreviousPage
	<commandQuery: #canPageBack>
	currentPage := currentPage - 1.
	self displayCurrentPage!

onPositionChanged: aPositionEvent
	super onPositionChanged: aPositionEvent.
	aPositionEvent isResize ifTrue: [self centreImage]!

onViewClosed
	printer pageRangeLimits: nil.
	super onViewClosed!

pageSetup
	printer showPageSetupDialog: true.
	self displayCurrentPage!

print
	printer pageRangeLimits: (1 to: lastPage).
	printer print: documentView selectionRange: (1 to: 0).
	self displayCurrentPage!

printer: aPrinter documentView: aView
	printer := aPrinter.
	documentView := aView.
	currentPage := 1.
	[self displayCurrentPage] postToInputQueue!

selectPage
	<commandQuery: #hasMultiplePages>
	(IntegerPrompter
		on: currentPage asValue
		prompt: 'Enter required page number (1 to ' , lastPage printString , ')'
		caption: 'Goto Page...'
		interval: (1 to: lastPage))
			ifNotNil: 
				[:newPage |
				currentPage := newPage.
				self displayCurrentPage]!

zoomIn
	image view extent: (image view extent * 1.5) rounded.
	self centreImage!

zoomOut
	image view extent: (image view extent * 0.666) rounded.
	self centreImage! !
!PrintPreviewShell categoriesForMethods!
bitmap:!accessing!public! !
canPageBack!commands-queries!public! !
canPageForward!commands-queries!public! !
centreImage!commands-actions!public! !
createComponents!initializing!public! !
currentPage!accessing!public! !
displayCurrentPage!displaying!public! !
hasMultiplePages!commands-queries!public! !
lastPage:!accessing!public! !
moveToFirstPage!commands-actions!public! !
moveToLastPage!commands-actions!public! !
moveToNextPage!commands-actions!public! !
moveToPreviousPage!commands-actions!public! !
onPositionChanged:!event handling!public! !
onViewClosed!event handling!public! !
pageSetup!commands-actions!public! !
print!commands-actions!public! !
printer:documentView:!initializing!public! !
selectPage!commands-actions!public! !
zoomIn!commands-actions!public! !
zoomOut!commands-actions!public! !
!

!PrintPreviewShell class methodsFor!

resource_Default_view
	"Answer the literal data from which the 'Default view' resource can be reconstituted.
	DO NOT EDIT OR RECATEGORIZE THIS METHOD.

	If you wish to modify this resource evaluate:
	ViewComposer openOn: (ResourceIdentifier class: self selector: #resource_Default_view)
	"

	^#(#'!!STL' 4 788558 10 ##(Smalltalk.STBViewProxy) ##(Smalltalk.ShellView) 34 27 nil nil 8 #(13565952 65536) 416 nil 655878 ##(Smalltalk.ThemeColor) #dialog nil 517 nil nil nil 416 852230 ##(Smalltalk.FramingLayout) 170 176 34 4 410 ##(Smalltalk.ContainerView) 34 15 nil 416 34 2 8 1140850688 131073 560 nil nil nil 5 nil nil nil 560 498 170 176 34 20 410 ##(Smalltalk.PushButton) 34 20 nil 560 34 2 8 1140924416 1 672 nil nil nil 5 nil nil nil 672 nil nil 1180998 4 ##(Smalltalk.CommandDescription) #print 8 'Print' 1 1 nil nil false nil nil nil 983302 ##(Smalltalk.MessageSequence) 34 3 721670 ##(Smalltalk.MessageSend) #createAt:extent: 34 2 328198 ##(Smalltalk.Point) 1 -1 882 141 51 672 834 #isEnabled: 8 #(false) 672 834 #text: 34 1 8 'Print' 672 983302 ##(Smalltalk.WINDOWPLACEMENT) 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 255 255 255 255 70 0 0 0 24 0 0 0] 8 #() 882 193 193 nil 29 1181766 2 ##(Smalltalk.FramingConstraints) 1180678 ##(Smalltalk.FramingCalculation) #fixedParentLeft 1 1122 #fixedViewLeft 141 1122 #fixedParentTop -1 1122 #fixedParentBottom -3 410 ##(Smalltalk.PushButton) 34 20 nil 560 34 2 8 1140924416 1 1200 nil nil nil 5 nil nil nil 1200 nil nil 738 #pageSetup 8 'Page Setup' 1 1 nil nil false nil nil nil 786 34 3 834 #createAt:extent: 34 2 882 149 -1 882 157 51 1200 834 #isEnabled: 8 #(false) 1200 834 #text: 34 1 8 'Page Setup' 1200 1010 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 74 0 0 0 255 255 255 255 152 0 0 0 24 0 0 0] 8 #() 1072 nil 29 1090 1122 #fixedPreviousRight 9 1152 157 1168 -1 1184 -3 410 ##(Smalltalk.PushButton) 34 20 nil 560 34 2 8 1140924416 1 1552 nil nil nil 5 nil nil nil 1552 nil nil 738 #moveToFirstPage 8 '⏮' 1 1 nil nil false nil nil nil 786 34 3 834 #createAt:extent: 34 2 882 329 -1 882 53 51 1552 834 #isEnabled: 8 #(false) 1552 834 #text: 34 1 8 '⏮' 1552 1010 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 164 0 0 0 255 255 255 255 190 0 0 0 24 0 0 0] 8 #() 1072 nil 29 1090 1536 25 1152 53 1168 -1 1184 -3 410 ##(Smalltalk.PushButton) 34 20 nil 560 34 2 8 1140924416 1 1888 nil nil nil 5 nil nil nil 1888 nil nil 738 #moveToPreviousPage 8 '⏪' 1 1 nil nil false nil nil nil 786 34 3 834 #createAt:extent: 34 2 882 385 -1 882 53 51 1888 834 #isEnabled: 8 #(false) 1888 834 #text: 34 1 8 '⏪' 1888 1010 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 192 0 0 0 255 255 255 255 218 0 0 0 24 0 0 0] 8 #() 1072 nil 29 1090 1536 5 1152 53 1168 -1 1184 -3 410 ##(Smalltalk.PushButton) 34 20 nil 560 34 2 8 1140924416 1 2224 nil nil nil 5 nil nil nil 2224 nil nil 738 #selectPage 8 '&Goto...' 1 1 nil nil false nil nil nil 786 34 3 834 #createAt:extent: 34 2 882 441 -1 882 105 51 2224 834 #isEnabled: 8 #(false) 2224 834 #text: 34 1 8 '&Goto...' 2224 1010 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 220 0 0 0 255 255 255 255 16 1 0 0 24 0 0 0] 8 #() 1072 nil 29 1090 1536 5 1152 105 1168 -1 1184 -3 410 ##(Smalltalk.PushButton) 34 20 nil 560 34 2 8 1140924416 1 2560 nil nil nil 5 nil nil nil 2560 nil nil 738 #moveToNextPage 8 '⏩' 1 1 nil nil false nil nil nil 786 34 3 834 #createAt:extent: 34 2 882 549 -1 882 53 51 2560 834 #isEnabled: 8 #(false) 2560 834 #text: 34 1 8 '⏩' 2560 1010 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 18 1 0 0 255 255 255 255 44 1 0 0 24 0 0 0] 8 #() 1072 nil 29 1090 1536 5 1152 53 1168 -1 1184 -3 410 ##(Smalltalk.PushButton) 34 20 nil 560 34 2 8 1140924416 1 2896 nil nil nil 5 nil nil nil 2896 nil nil 738 #moveToLastPage 8 '⏭' 1 1 nil nil false nil nil nil 786 34 3 834 #createAt:extent: 34 2 882 605 -1 882 53 51 2896 834 #isEnabled: 8 #(false) 2896 834 #text: 34 1 8 '⏭' 2896 1010 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 46 1 0 0 255 255 255 255 72 1 0 0 24 0 0 0] 8 #() 1072 nil 29 1090 1536 5 1152 53 1168 -1 1184 -3 410 ##(Smalltalk.PushButton) 34 20 nil 560 34 2 8 1140924416 1 3232 nil nil nil 5 nil nil nil 3232 nil nil 738 #zoomIn 8 '➕' 1 1 nil nil false nil nil nil 786 34 3 834 #createAt:extent: 34 2 882 683 -1 882 51 51 3232 834 #isEnabled: 8 #(false) 3232 834 #text: 34 1 8 '➕' 3232 1010 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 85 1 0 0 255 255 255 255 110 1 0 0 24 0 0 0] 8 #() 1072 nil 29 1090 1536 27 1152 51 1168 -1 1184 -3 410 ##(Smalltalk.PushButton) 34 20 nil 560 34 2 8 1140924416 1 3568 nil nil nil 5 nil nil nil 3568 nil nil 738 #zoomOut 8 '➖' 1 1 nil nil false nil nil nil 786 34 3 834 #createAt:extent: 34 2 882 733 -1 882 51 51 3568 834 #isEnabled: 8 #(false) 3568 834 #text: 34 1 8 '➖' 3568 1010 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 110 1 0 0 255 255 255 255 135 1 0 0 24 0 0 0] 8 #() 1072 nil 29 1090 1536 1 1152 51 1168 -1 1184 -3 410 ##(Smalltalk.PushButton) 34 20 nil 560 34 2 8 1140924416 1 3904 nil nil nil 5 nil nil nil 3904 nil nil 738 #exit 8 'Close' 1 1 nil nil false nil nil nil 786 34 2 834 #createAt:extent: 34 2 882 807 1 882 141 49 3904 834 #text: 34 1 8 'Close' 3904 1010 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 147 1 0 0 0 0 0 0 217 1 0 0 24 0 0 0] 8 #() 1072 nil 29 1090 1536 25 1152 141 1122 #fixedPreviousTop 3 1122 #fixedPreviousBottom 1 170 192 8 #() nil 786 34 1 834 #createAt:extent: 34 2 882 1 11 882 1169 53 560 1010 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 5 0 0 0 72 2 0 0 31 0 0 0] 34 10 672 1200 1552 1888 2224 2560 2896 3232 3568 3904 1072 nil 27 1090 1136 1 1122 #fixedParentRight 1 1168 11 1122 #fixedViewTop 53 410 ##(Smalltalk.ScrollingDecorator) 34 18 nil 416 34 2 8 1143996416 131073 4464 nil nil nil 5 nil nil nil 4464 1573190 1 ##(Smalltalk.ScrollingDecoratorLayout) true 170 192 34 2 410 ##(Smalltalk.ImageView) 34 21 nil 4464 34 2 8 1149239552 1 4592 721990 2 ##(Smalltalk.ValueHolder) 0 nil 1376774 ##(Smalltalk.PluggableSearchPolicy) 459270 ##(Smalltalk.Message) #= 8 #() 4722 #hash 8 #() nil 327686 ##(Smalltalk.Color) #default nil 5 nil nil nil 4592 nil nil 852486 ##(Smalltalk.NullConverter) nil nil nil nil #scaleBestFit 3 nil nil 786 34 1 834 #createAt:extent: 34 2 882 1 1 882 1185 685 4592 1010 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 0 0 0 0 80 2 0 0 86 1 0 0] 8 #() 1072 nil 27 8 'image' nil 882 1 1 true 882 17 17 786 34 1 834 #createAt:extent: 34 2 882 1 63 882 1169 661 4464 1010 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 31 0 0 0 72 2 0 0 105 1 0 0] 34 1 4592 1072 nil 27 1090 1136 1 4432 1 4224 1 1184 1 170 192 4256 nil nil nil nil nil 1 nil nil nil nil 1 nil nil 786 34 1 834 #createAt:extent: 34 2 882 6143 21 882 1201 801 416 1010 8 #[44 0 0 0 0 0 0 0 0 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 11 0 0 10 0 0 0 87 14 0 0 154 1 0 0] 34 2 560 4464 1072 nil 27 )! !
!PrintPreviewShell class categoriesForMethods!
resource_Default_view!public!resources-views! !
!

