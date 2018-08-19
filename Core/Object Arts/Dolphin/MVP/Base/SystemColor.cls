"Filed out from Dolphin Smalltalk 7"!

LogicalColor subclass: #SystemColor
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
SystemColor guid: (GUID fromString: '{87b4c53c-026e-11d3-9fd7-00a0cc3e4a32}')!
SystemColor comment: '`SystemColor` instances represent the logical colours defined by the current Windows colour scheme, for example the colour of dialog backgrounds, window captions, etc.'!
!SystemColor categoriesForClass!Drawing! !
!SystemColor methodsFor!

= aSystemColor
	"Answer true if aSystemColor is equal to (has the same id as) the receiver."

	^self species == aSystemColor species and: [self id == aSystemColor id]!

asIndexedColor
	"Answer the receiver as an IndexedColour."

	^(RGB fromInteger: self asParameter) asIndexedColor!

asParameter
	"Answer the receiver in a form suitable for an API call."

	^UserLibrary default getSysColor: self id!

asRGB
	"Answer the receiver as an RGB"

	^RGB fromInteger: self asParameter!

brushClass
	"Private - Answer the class of Brush to be used in conjunction with the receiver."

	^SysColorBrush!

id
	"Private - Answer the system id of the receiver"

	^index! !
!SystemColor categoriesFor: #=!comparing!public! !
!SystemColor categoriesFor: #asIndexedColor!converting!public! !
!SystemColor categoriesFor: #asParameter!converting!public! !
!SystemColor categoriesFor: #asRGB!converting!public! !
!SystemColor categoriesFor: #brushClass!constants!private! !
!SystemColor categoriesFor: #id!accessing!private! !

!SystemColor class methodsFor!

initialize
	#('scrollbar' 'desktop' 'caption' 'inactiveCaption' 'menu' 'window' 'windowFrame' 'menuText' 'windowText' 'captionText' 'activeBorder' 'inactiveBorder' 'applicationWorkspace' 'highlight' 'highlightText' 'face3d' 'shadow3d' 'grayText' 'buttonText' 'inactiveCaptionText' 'highlight3d' 'buttonHighlight' 'darkShadow3d' 'light3d' 'tooltip' 'tooltipText' 'hotlight' 'gradientActiveCaption' 'gradientInactiveCaption' 'menuHilight' 'menuBar')
		keysAndValuesDo: [:k :v | NamesByIndex at: k - 1 put: v asSymbol].
	(COLOR_SCROLLBAR to: COLOR_MENUBAR) do: 
			[:each |
			| syscolor |
			syscolor := self basicNew setIndex: each.
			syscolor isImmutable: true.
			self addNamed: (NamesByIndex at: each) color: syscolor.
			ColorsByIndex at: each put: syscolor].
	Color addClassConstant: 'Face3d' value: (self named: #face3d).
	Color addClassConstant: 'Window' value: (self named: #window).
	Color addClassConstant: 'WindowText' value: (self named: #windowText)! !
!SystemColor class categoriesFor: #initialize!class initialization!development!public! !

