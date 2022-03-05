"Filed out from Dolphin Smalltalk"!

ScintillaTextStyle subclass: #ScintillaCallTipStyle
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
ScintillaCallTipStyle guid: (GUID fromString: '{81c766f0-616e-4cf1-bc4b-8eba6720f2d7}')!
ScintillaCallTipStyle comment: ''!
!ScintillaCallTipStyle categoriesForClass!MVP-Views-Support! !
!ScintillaCallTipStyle methodsFor!

initialize
	super initialize.
	backcolor := Color tooltip.
	forecolor := Color tooltipText.
	self name: #callTip! !
!ScintillaCallTipStyle categoriesForMethods!
initialize!initializing!private! !
!

!ScintillaCallTipStyle class methodsFor!

initialize
	"
		self initialize
	"

	propertyMap := self buildPropertyMap
				at: #forecolor
					put: (ScintillaColorPropertyDescriptor
							getSelector: #forecolor
							defaultValue: Color gray
							setMessage: SCI_STYLESETFORE);
				isImmutable: true;
				yourself! !
!ScintillaCallTipStyle class categoriesForMethods!
initialize!development!initializing!public! !
!

