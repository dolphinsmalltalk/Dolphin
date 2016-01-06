"Filed out from Dolphin Smalltalk X6.1"!

Shell subclass: #PrintPreviewShell
	instanceVariableNames: 'image documentView printer currentPage bitmap lastPage'
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
PrintPreviewShell guid: (GUID fromString: '{9BC31592-F010-4EB2-952D-C7FB44733B01}')!
PrintPreviewShell comment: 'See [DolphinImageFolder]/Idb/Documentation for details

(C) 2006 Ian Bartholomew
ian@idb.me.uk
Public Domain Freeware'!
!PrintPreviewShell categoriesForClass!IDB Goodies! !
!PrintPreviewShell methodsFor!

bitmap: anObject
	bitmap := anObject!

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
	image value: bitmap.
	self
		caption:
			((String writeStream)
				print: currentPage;
				nextPutAll: ' of ';
				print: lastPage;
				contents)!

lastPage: anObject
	lastPage := anObject!

moveToFirstPage
	currentPage := 1.
	self displayCurrentPage!

moveToLastPage
	currentPage := lastPage.
	self displayCurrentPage!

moveToNextPage
	currentPage := currentPage + 1.
	self displayCurrentPage!

moveToPreviousPage
	currentPage := currentPage - 1.
	self displayCurrentPage!

onPositionChanged: aPositionEvent
	super onPositionChanged: aPositionEvent.
	self centreImage!

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

queryCommand: aCommandQuery
	(#(#moveToPreviousPage #moveToFirstPage) identityIncludes: aCommandQuery commandSymbol)
		ifTrue:
			[aCommandQuery isEnabled: (currentPage notNil and: [currentPage > 1]).
			^true].
	(#(#moveToNextPage #moveToLastPage) identityIncludes: aCommandQuery commandSymbol)
		ifTrue:
			[aCommandQuery isEnabled: (currentPage notNil and: [lastPage notNil and: [currentPage < lastPage]]).
			^true].
	^super queryCommand: aCommandQuery!

selectPage
	| text |
	text := Prompter prompt: 'Enter required page number (1 to ' , lastPage printString , ')'.
	(text isNil or: [(text := text trimBlanks) = 0 or: [text anySatisfy: [:each | each isDigit not]]])
		ifTrue: [^self].
	currentPage := Integer fromString: text.
	self displayCurrentPage!

zoomIn
	image view extent: (image view extent * 1.5) rounded.
	self centreImage!

zoomOut
	image view extent: (image view extent * 0.666) rounded.
	self centreImage! !
!PrintPreviewShell categoriesFor: #bitmap:!accessing!public! !
!PrintPreviewShell categoriesFor: #centreImage!commands!public! !
!PrintPreviewShell categoriesFor: #createComponents!initializing!public! !
!PrintPreviewShell categoriesFor: #currentPage!accessing!public! !
!PrintPreviewShell categoriesFor: #displayCurrentPage!displaying!public! !
!PrintPreviewShell categoriesFor: #lastPage:!accessing!public! !
!PrintPreviewShell categoriesFor: #moveToFirstPage!commands!public! !
!PrintPreviewShell categoriesFor: #moveToLastPage!commands!public! !
!PrintPreviewShell categoriesFor: #moveToNextPage!commands!public! !
!PrintPreviewShell categoriesFor: #moveToPreviousPage!commands!public! !
!PrintPreviewShell categoriesFor: #onPositionChanged:!event handling!public! !
!PrintPreviewShell categoriesFor: #onViewClosed!event handling!public! !
!PrintPreviewShell categoriesFor: #pageSetup!commands!public! !
!PrintPreviewShell categoriesFor: #print!commands!public! !
!PrintPreviewShell categoriesFor: #printer:documentView:!initializing!public! !
!PrintPreviewShell categoriesFor: #queryCommand:!commands!public! !
!PrintPreviewShell categoriesFor: #selectPage!commands!public! !
!PrintPreviewShell categoriesFor: #zoomIn!commands!public! !
!PrintPreviewShell categoriesFor: #zoomOut!commands!public! !

!PrintPreviewShell class methodsFor!

resource_Default_view
	"Answer the literal data from which the 'Default view' resource can be reconstituted.
	DO NOT EDIT OR RECATEGORIZE THIS METHOD.

	If you wish to modify this resource evaluate:
	ViewComposer openOn: (ResourceIdentifier class: self selector: #resource_Default_view)
	"

	^#(#'!!STL' 3 788558 10 ##(STBViewProxy) 8 ##(ShellView) 98 27 0 0 98 2 27131905 131073 416 0 524550 ##(ColorRef) 8 4278190080 0 551 0 0 0 416 852230 ##(FramingLayout) 234 240 98 4 410 8 ##(ScrollingDecorator) 98 18 0 416 98 2 8 1143996416 131073 592 0 0 0 7 0 0 0 592 1573190 1 ##(ScrollingDecoratorLayout) 16 234 256 98 2 410 8 ##(ImageView) 98 21 0 592 98 2 8 1149239552 1 736 721990 2 ##(ValueHolder) 0 0 1376774 ##(PluggableSearchPolicy) 459270 ##(Message) 8 #= 98 0 882 8 #hash 98 0 0 482 8 4278190080 0 7 0 0 0 736 0 8 4294903431 852486 ##(NullConverter) 0 0 0 0 8 #scaleToFit 1 0 0 983302 ##(MessageSequence) 202 208 98 1 721670 ##(MessageSend) 8 #createAt:extent: 98 2 328198 ##(Point) 1 1 1218 1185 685 736 983302 ##(WINDOWPLACEMENT) 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 0 0 0 0 80 2 0 0 86 1 0 0] 98 0 1218 193 193 0 27 8 'image' 0 1218 1 1 16 1218 17 17 1090 202 208 98 1 1154 1184 98 2 1218 1 49 1218 1185 685 592 1266 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 24 0 0 0 80 2 0 0 110 1 0 0] 98 1 736 1328 0 27 1181766 2 ##(FramingConstraints) 1114638 ##(STBSingletonProxy) 8 ##(FramingCalculation) 8 #fixedParentLeft 1 1594 1616 8 #fixedParentRight 1 1594 1616 8 #fixedPreviousBottom 1 1594 1616 8 #fixedParentBottom 1 410 8 ##(ContainerView) 98 15 0 416 98 2 8 1140850688 131073 1744 0 0 0 7 0 0 0 1744 530 234 240 98 20 410 8 ##(PushButton) 98 17 0 1744 98 2 8 1140924416 1 1872 0 0 0 7 0 0 0 1872 0 8 4294906413 1180998 4 ##(CommandDescription) 8 #pageSetup 8 'Page Setup' 1 1 0 0 32 1090 202 208 98 3 1154 1184 98 2 1218 149 1 1218 141 49 1872 1154 8 #isEnabled: 98 1 32 1872 1154 8 #text: 98 1 8 'Page Setup' 1872 1266 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 74 0 0 0 0 0 0 0 144 0 0 0 24 0 0 0] 98 0 1328 0 27 1554 1594 1616 8 #fixedPreviousRight 9 1594 1616 8 #fixedViewLeft 141 1594 1616 8 #fixedParentTop 1 1712 1 410 1888 98 17 0 1744 98 2 8 1140924416 1 2416 0 0 0 7 0 0 0 2416 0 8 4294906413 1970 8 #zoomOut 8 'Out' 1 1 0 0 32 1090 202 208 98 3 1154 1184 98 2 1218 737 1 1218 61 49 2416 1154 2160 98 1 32 2416 1154 2208 98 1 8 'Out' 2416 1266 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 112 1 0 0 0 0 0 0 142 1 0 0 24 0 0 0] 98 0 1328 0 27 1554 2320 9 2352 61 2384 1 1712 1 410 1888 98 17 0 1744 98 2 8 1140924416 1 2800 0 0 0 7 0 0 0 2800 0 8 4294906413 1970 8 #moveToFirstPage 8 'I<' 1 1 0 0 32 1090 202 208 98 3 1154 1184 98 2 1218 313 1 1218 61 49 2800 1154 2160 98 1 32 2800 1154 2208 98 1 8 'I<' 2800 1266 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 156 0 0 0 0 0 0 0 186 0 0 0 24 0 0 0] 98 0 1328 0 27 1554 2320 25 2352 61 2384 1 1712 1 410 1888 98 17 0 1744 98 2 8 1140924416 1 3184 0 0 0 7 0 0 0 3184 0 8 4294906413 1970 8 #moveToLastPage 8 '>I' 1 1 0 0 32 1090 202 208 98 3 1154 1184 98 2 1218 585 1 1218 61 49 3184 1154 2160 98 1 32 3184 1154 2208 98 1 8 '>I' 3184 1266 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 36 1 0 0 0 0 0 0 66 1 0 0 24 0 0 0] 98 0 1328 0 27 1554 2320 9 2352 61 2384 1 1712 1 410 1888 98 17 0 1744 98 2 8 1140924416 1 3568 0 0 0 7 0 0 0 3568 0 8 4294906413 1970 8 #selectPage 8 'Go' 1 1 0 0 32 1090 202 208 98 3 1154 1184 98 2 1218 449 1 1218 61 49 3568 1154 2160 98 1 32 3568 1154 2208 98 1 8 'Go' 3568 1266 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 224 0 0 0 0 0 0 0 254 0 0 0 24 0 0 0] 98 0 1328 0 27 1554 2320 9 2352 61 2384 1 1712 1 410 1888 98 17 0 1744 98 2 8 1140924416 1 3952 0 0 0 7 0 0 0 3952 0 8 4294906413 1970 8 #moveToPreviousPage 8 '<' 1 1 0 0 32 1090 202 208 98 3 1154 1184 98 2 1218 381 1 1218 61 49 3952 1154 2160 98 1 32 3952 1154 2208 98 1 8 '<' 3952 1266 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 190 0 0 0 0 0 0 0 220 0 0 0 24 0 0 0] 98 0 1328 0 27 1554 2320 9 2352 61 2384 1 1712 1 410 1888 98 17 0 1744 98 2 8 1140924416 1 4336 0 0 0 7 0 0 0 4336 0 8 4294906413 1970 8 #exit 8 'Close' 1 1 0 0 32 1090 202 208 98 2 1154 1184 98 2 1218 821 1 1218 141 49 4336 1154 2208 98 1 8 'Close' 4336 1266 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 154 1 0 0 0 0 0 0 224 1 0 0 24 0 0 0] 98 0 1328 0 27 1554 2320 25 2352 141 1594 1616 8 #fixedPreviousTop 1 1680 1 410 1888 98 17 0 1744 98 2 8 1140924416 1 4720 0 0 0 7 0 0 0 4720 0 8 4294906413 1970 8 #print 8 'Print' 1 1 0 0 32 1090 202 208 98 3 1154 1184 98 2 1218 1 1 1218 141 49 4720 1154 2160 98 1 32 4720 1154 2208 98 1 8 'Print' 4720 1266 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 0 0 0 0 70 0 0 0 24 0 0 0] 98 0 1328 0 27 1554 1600 1 2352 141 2384 1 1712 1 410 1888 98 17 0 1744 98 2 8 1140924416 1 5104 0 0 0 7 0 0 0 5104 0 8 4294906413 1970 8 #moveToNextPage 8 '>' 1 1 0 0 32 1090 202 208 98 3 1154 1184 98 2 1218 517 1 1218 61 49 5104 1154 2160 98 1 32 5104 1154 2208 98 1 8 '>' 5104 1266 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 2 1 0 0 0 0 0 0 32 1 0 0 24 0 0 0] 98 0 1328 0 27 1554 2320 9 2352 61 2384 1 1712 1 410 1888 98 17 0 1744 98 2 8 1140924416 1 5488 0 0 0 7 0 0 0 5488 0 8 4294906413 1970 8 #zoomIn 8 'In' 1 1 0 0 32 1090 202 208 98 3 1154 1184 98 2 1218 669 1 1218 61 49 5488 1154 2160 98 1 32 5488 1154 2208 98 1 8 'In' 5488 1266 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 78 1 0 0 0 0 0 0 108 1 0 0 24 0 0 0] 98 0 1328 0 27 1554 2320 25 2352 61 2384 1 1712 1 234 256 98 0 0 1090 202 208 98 1 1154 1184 98 2 1218 1 1 1218 1185 49 1744 1266 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 0 0 0 0 80 2 0 0 24 0 0 0] 98 10 4720 1872 2800 3952 3568 5104 3184 5488 2416 4336 1328 0 27 1554 1600 1 1648 1 2384 1 1594 1616 8 #fixedViewTop 49 234 256 5888 0 0 0 0 4336 1 0 0 0 0 1 0 0 1090 202 208 98 2 1154 1184 98 2 1218 20001 20001 1218 1201 801 416 1154 8 #menuBar: 98 1 0 416 1266 8 #[44 0 0 0 0 0 0 0 0 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 16 39 0 0 16 39 0 0 104 41 0 0 160 40 0 0] 98 2 1744 592 1328 0 27)! !
!PrintPreviewShell class categoriesFor: #resource_Default_view!public!resources-views! !

