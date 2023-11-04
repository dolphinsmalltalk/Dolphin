"Filed out from Dolphin Smalltalk"!

UI.StaticControlView
	subclass: #'UI.StaticText'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {
			'AlignmentMap' -> (IdentityDictionary
						withAll: { #center -> 16r1. #left -> 16r0. #leftNoWrap -> 16rC. #right -> 16r2. #simple -> 16rB })
		}!
UI.StaticText guid: (Core.GUID fromString: '{87b4c740-026e-11d3-9fd7-00a0cc3e4a32}')!
UI.StaticText comment: '`StaticText` is a `<valueView>` class for a Window STATIC control for displaying text in one of a number of text styles. The `<valueModel>` associated with a `StaticText` must always yield a `<readableString>` value when mapped through the installed type converter. A `StaticText` will normally be used in conjunction with a `TextPresenter`. The alignment of the text (and therefore the style of the underlying Windows control) can be specified using the alignment aspect which can assume of of the following values: (`#left`, `#center`, `#right`, `#leftNoWrap`, `#simple`).

## Class Constants:
  AlignmentMap	`LookupTable` of `Symbol` alignment specifiers to Windows styles.
'!
!UI.StaticText categoriesForClass!MVP-Views! !
!UI.StaticText methodsFor!

alignment
	"Answer a symbolic text alignment for the receiver's current mode."

	| typeFlags |
	typeFlags := self getAlignment.
	^AlignmentMap keyAtValue: typeFlags ifAbsent: #left!

alignment: aSymbol
	"Sets the text alignment to the symbolic alignment name, aSymbol."

	self setAlignment: ((AlignmentMap lookup: aSymbol)
				ifNil: 
					[##(IdentityDictionary withAll: {#topRight -> SS_RIGHT.
								#topCenter -> SS_CENTER.
								#rightCenter -> SS_RIGHT.
								#bottomCenter -> SS_CENTER.
								#bottomLeft -> SS_LEFT.
								#bottomRight -> SS_RIGHT.
								#leftCenter -> SS_LEFT.
								#topLeft -> SS_LEFT})
						at: aSymbol])!

beCenterAligned
	"Sets the receiver into center aligned mode"

	self setAlignment: SS_CENTER!

beLeftAligned
	"Sets the receiver into left aligned mode"

	self setAlignment: SS_LEFT!

beNoWordWrap
	"Sets the receiver into left aligned no word wrap mode"

	self setAlignment: SS_LEFTNOWORDWRAP!

beRightAligned
	"Sets the receiver into right aligned mode"

	self setAlignment: SS_RIGHT!

calculateExtent: aLayoutContext
	"Private - Calculate an extent for the receiver that would allow it to display all the text that it currently contains in the vertical/horizontal space that best suits its configured alignment."

	"Implementation Note: The calculated extent depends on the alignment mode, and sometimes (in word-wrapping modes only) the current width.
	- In #simple mode (which is the only true single line mode, and corresponds to the SS_SIMPLE mode of the static control), the calculated extent is that required to draw the text on a single line, stripping out newlines and tabs. Mnemonic prefix characters are also not interpreted in this mode, but will appear as ampersands in the output.
	- In the non-wrapping #leftNoWrap mode (SS_LEFTNOWORDWRAP), the width is calculated based on the longest line, and the height is that required to draw however many lines of text there are as delineated by newline separators.
	- In the wrapping modes, #left (SS_LEFT), #right (SS_RIGHT), and #center (SS_CENTER), the width is calculated as the minimum of the current width and the width of the longest line (i.e .the current width is the maximum width), and the height is that required to draw the number of lines of text that there are after (possibly) wrapping to the width."

	| canvas extent dtFlags wrapWidth |
	wrapWidth := 0.
	self isSingleLine
		ifTrue: 
			[wrapWidth := 0.
			dtFlags := ##(DT_CALCRECT | DT_SINGLELINE | DT_NOPREFIX)]
		ifFalse: 
			[| alignmentFlags |
			dtFlags := ##(DT_CALCRECT | DT_EXPANDTABS).
			alignmentFlags := self getAlignment.
			alignmentFlags ~~ SS_LEFTNOWORDWRAP
				ifTrue: 
					[wrapWidth := (aLayoutContext clientRectangleOf: self) width.

					"The DT_LEFT (0), DT_CENTER (1), and DT_RIGHT (2) flags are actually the same as the SS_LEFT, etc, flags"
					dtFlags := (dtFlags bitOr: alignmentFlags) bitOr: DT_WORDBREAK]].
	canvas := self canvas.
	canvas font: self actualFont.
	extent := canvas
				textExtent: self text
				width: wrapWidth
				flags: dtFlags.
	canvas free.

	"Now adjust required client extent to window extent to account for the chrome"
	^self calcExtentFromClientExtent: extent!

clear
	"Clears the contents of the receiver"

	self text: ''!

displayValue
	"Private - Answer the displayed contents, the text, of the receiver"

	^self text!

displayValue: anObject
	"Private - Set the displayable contents, the text, of the receiver to the
	displayString of anObject"

	| newText |
	newText := anObject displayString.
	self displayValue = newText ifFalse: [
		"If the text has changed then set the new text for anObject"
		self text: newText ]!

getAlignment
	"Private - Answers the text alignment, one of SS_LEFT, SS_CENTER, SS_RIGHT, SS_LEFTNOWORDWRAP, or SS_SIMPLE"

	^self baseStyle bitAnd: SS_TYPEMASK!

initialize
	"Private - Initialise the receiver."

	super initialize.
	self beLeftAligned.
!

isSingleLine
	^self alignment == #simple!

refreshContents
	"The model held by the receiver has probably been changed so refresh 
	he receiver contents. Overridden here since StaticText and subclasses
	are allowed to have no model. This is for efficiency, to avoid having to 
	maintain two copies of possibly large text (one in Windows, one in Smalltalk)"

	self model notNil ifTrue: [ super refreshContents ]!

setAlignment: anInteger
	"Private - Sets the text alignment to anInteger, one of SS_LEFT, 
	SS_CENTER, SS_RIGHT, etc."

	self baseStyle: anInteger maskedBy: SS_TYPEMASK	!

value
	"Answer the value of the receiver. Overridden here and in TextEdit since
	StaticText can potentially have no (nil) model. This method accesses the 
	receiver's window directly via #displayValue."

	^self typeconverter convertFromRightToLeft: self displayValue!

value: anObject
	"Set the value of the receiver to anObject. Overridden here and in TextEdit
	since StaticText can potentially have no (nil) model. This method accesses the 
	receiver's window directly via #displayValue:."

	self displayValue: (self typeconverter convertFromLeftToRight: anObject)! !
!UI.StaticText categoriesForMethods!
alignment!accessing!public! !
alignment:!accessing!public! !
beCenterAligned!accessing!public! !
beLeftAligned!accessing!public! !
beNoWordWrap!accessing!public! !
beRightAligned!accessing!public! !
calculateExtent:!geometry!private! !
clear!operations!public! !
displayValue!private!updating! !
displayValue:!private!updating! !
getAlignment!accessing!private! !
initialize!initializing!private! !
isSingleLine!private!testing! !
refreshContents!public!updating! !
setAlignment:!accessing!private! !
value!accessing!public! !
value:!accessing!public! !
!

!UI.StaticText class methodsFor!

icon
	"Answers an Icon that can be used to represent this class"

	^##(self) defaultIcon!

initialize
	"Private - Initialize the receiver's class variables.
		StaticText initialize
	"

	self addClassConstant: 'AlignmentMap'
		value: (IdentityDictionary withAll: {
						#left -> SS_LEFT.
						#right -> SS_RIGHT.
						#center -> SS_CENTER.
						#leftNoWrap -> SS_LEFTNOWORDWRAP.
						#simple -> SS_SIMPLE
					})! !
!UI.StaticText class categoriesForMethods!
icon!constants!public! !
initialize!development!initializing!private! !
!

