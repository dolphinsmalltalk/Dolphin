"Filed out from Dolphin Smalltalk"!

UI.Scintilla.TextStyle subclass: #'UI.Scintilla.CallTipStyle'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!
UI.Scintilla.CallTipStyle guid: (Core.GUID fromString: '{81c766f0-616e-4cf1-bc4b-8eba6720f2d7}')!
UI.Scintilla.CallTipStyle comment: ''!
!UI.Scintilla.CallTipStyle categoriesForClass!MVP-Views-Support! !
!UI.Scintilla.CallTipStyle methodsFor!

initialize
	super initialize.
	backcolor := Color tooltip.
	forecolor := Color tooltipText.
	self name: #callTip! !
!UI.Scintilla.CallTipStyle categoriesFor: #initialize!initializing!private! !

!UI.Scintilla.CallTipStyle class methodsFor!

initialize
	"
		self initialize
	"

	propertyMap := self buildPropertyMap
				at: #forecolor
					put: (ColorPropertyDescriptor
							getSelector: #forecolor
							defaultValue: Color gray
							setMessage: SCI_STYLESETFORE);
				isImmutable: true;
				yourself! !
!UI.Scintilla.CallTipStyle class categoriesFor: #initialize!development!initializing!public! !

