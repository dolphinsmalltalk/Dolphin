"Filed out from Dolphin Smalltalk 7"!

ValueConvertingControlView subclass: #CheckButton
	instanceVariableNames: 'image'
	classVariableNames: 'AlignmentMap'
	poolDictionaries: 'ButtonConstants'
	classInstanceVariableNames: ''
	classConstants: {}!
CheckButton guid: (GUID fromString: '{e7a5424e-24cd-4389-a849-591db02a92d0}')!
CheckButton isAbstract: true!
CheckButton comment: 'CheckButton is the abstract subclass of <valueView>s implementing the Windows "BUTTON" class in checkbox and radio button styles. The <valueModel> associated with a CheckButton must alway yield a <boolean> value once mapped through the installed type converter, although nil is also an acceptable value for a <CheckBox> in 3-state mode. A CheckButton will normally be used in conjunction with either a <BooleanPresenter>, or in a group connected to a <RadioButtonSetPresenter>.

The text in a button control can be aligned in various ways (this may also affect the alignment of any image displayed in the button):
		#left			- left edge, vertically centred
		#right			- right edge, vertically centred
		#center			- horizontally and vertically centred (the default)
		#top			- top edge, horizontally centred
		#bottom			- bottom edge, horizontally centred
		#topLeft		- top left corner
		#topRight		- top right corner
		#bottomLeft		- bottom left corner
		#bottomRight	- bottom right corner

Instance Variables:
	image			<Image> or nil, specifying an image to associate with the button..

Class Variables:
	AlignmentMap	<LookupTable> mapping the alignment modes listed above to the corresponding integer flags.
'!
!CheckButton categoriesForClass!MVP-Views! !
!CheckButton methodsFor!

alignment
	"Answer a <Symbol> naming the alignment of the text and graphic in the associated BUTTON
	control."

	| alignment |
	alignment := self baseStyle 
				bitAnd: ##(BS_LEFT | BS_RIGHT | BS_BOTTOM | BS_TOP | BS_CENTER | BS_VCENTER).
	^AlignmentMap keyAtValue: alignment ifAbsent: [#leftCenter]!

alignment: aSymbol 
	"Set the alignment of the button to be the mode named by the <Symbol> argument, which must
	be one of the modes defined in AlignmentMap (see the class comment for a description of
	these modes). Note that this mainly controls the text alignment, but the vertical setting
	also controls the position of the button graphic. The separate #hasLeftText aspect can be
	used to control whether the check button is to the left or right of the label."

	| alignment |
	alignment := AlignmentMap at: aSymbol ifAbsent: [##(BS_LEFT | BS_VCENTER)].
	self 
		baseStyle: alignment
		maskedBy: ##(BS_LEFT | BS_RIGHT | BS_BOTTOM | BS_TOP | BS_CENTER | BS_VCENTER)
		recreateIfChanged: false.
	self invalidate!

basicWindowStyle
	^self subclassResponsibility!

command: anInteger id: id 
	"Private - Responds to a command notification message which has been redirected to us."

	anInteger == BN_CLICKED 
		ifTrue: 
			[self updateModel.
			self presenter performAction].
	^nil!

defaultWindowStyle
	"Private - Answer a default style to use when creating a checkbox."

	^super defaultWindowStyle | BS_MULTILINE | self basicWindowStyle!

displayValue
	"Private - Answer the displayed contents, the check state, of the receiver. This will be
	either true (for checked), false (for unchecked) or nil (for indeterminate)."

	| state |
	state := self sendMessage: BM_GETCHECK.
	^#(false true nil) at: state + 1!

displayValue: aBoolean 
	"Private - Set the displayable contents, the check state, of the receiver to aBoolean"

	| buttonState |
	buttonState := aBoolean isNil 
				ifTrue: [BST_INDETERMINATE]
				ifFalse: [aBoolean ifTrue: [BST_CHECKED] ifFalse: [BST_UNCHECKED]].
	^self sendMessage: BM_SETCHECK wParam: buttonState!

hasLeftText
	"Answer whether the receiver has the text at the left of the button."

	^self baseStyleAllMask: BS_LEFTTEXT!

hasLeftText: boolean 
	"Set whether the receiver has the text at the left of the button button according to
	aBoolean."

	self 
		baseStyleMask: BS_LEFTTEXT
		set: boolean
		recreateIfChanged: true	"Recreate required for this change to take effect."!

image
	"Answer the image displayed on the button, if any."

	^image!

image: anImageOrNil 
	"Sets the image displayed by the receiver to anImageOrNil."

	| style |
	style := (image := anImageOrNil) 
				ifNil: [0]
				ifNotNil: [anImageOrNil imageType = IMAGE_ICON ifTrue: [BS_ICON] ifFalse: [BS_BITMAP]].
	self baseStyle: style maskedBy: ##(BS_BITMAP | BS_ICON).
	style = 0 
		ifFalse: 
			[self 
				sendMessage: BM_SETIMAGE
				wParam: anImageOrNil imageType
				lParam: anImageOrNil asParameter]!

isPushLike
	"Answer whether the receiver has an appearence like a push button (i.e. it is a Toggle
	Button)."

	^self baseStyleAllMask: BS_PUSHLIKE!

isPushLike: boolean 
	"Set whether the receiver has appearence of a toggling push button according to aBoolean."

	self 
		baseStyleMask: BS_PUSHLIKE
		set: boolean
		recreateIfChanged: true	"Recreate required for this change to take effect"!

onViewCreated
	"The receiver's window has been created. Copy any instance variable information across to
	the control."

	super onViewCreated.
	self image: self image! !
!CheckButton categoriesFor: #alignment!accessing!public! !
!CheckButton categoriesFor: #alignment:!accessing!public! !
!CheckButton categoriesFor: #basicWindowStyle!constants!private! !
!CheckButton categoriesFor: #command:id:!commands!private! !
!CheckButton categoriesFor: #defaultWindowStyle!constants!private! !
!CheckButton categoriesFor: #displayValue!private!updating! !
!CheckButton categoriesFor: #displayValue:!private!updating! !
!CheckButton categoriesFor: #hasLeftText!accessing-styles!public! !
!CheckButton categoriesFor: #hasLeftText:!accessing-styles!public! !
!CheckButton categoriesFor: #image!accessing!public! !
!CheckButton categoriesFor: #image:!accessing!public! !
!CheckButton categoriesFor: #isPushLike!accessing-styles!public! !
!CheckButton categoriesFor: #isPushLike:!accessing-styles!public! !
!CheckButton categoriesFor: #onViewCreated!event handling!public! !

!CheckButton class methodsFor!

defaultModel
	"Answer a default model to be assigned to the receiver when it is initialized."

	^false asValue!

initialize
	"Private - Initialize the receiver's class variables.
		CheckButton initialize
	"

	self addClassConstant: 'AlignmentMap'
		value: (IdentityDictionary new
				at: #leftCenter put: BS_LEFT | BS_VCENTER;
				at: #rightCenter put: BS_RIGHT | BS_VCENTER;
				at: #topCenter put: BS_CENTER | BS_TOP;
				at: #bottomCenter put: BS_CENTER | BS_BOTTOM;
				at: #center put: BS_CENTER | BS_VCENTER;
				at: #topLeft put: BS_LEFT | BS_TOP;
				at: #topRight put: BS_RIGHT | BS_TOP;
				at: #bottomLeft put: BS_LEFT | BS_BOTTOM;
				at: #bottomRight put: BS_RIGHT | BS_BOTTOM;
				shrink;
				isImmutable: true;
				yourself)!

themePartName
	^'BUTTON'!

winClassName
	"Private - Answer the name of the Windows window class to use when realising the receiver."

	^'BUTTON'! !
!CheckButton class categoriesFor: #defaultModel!models!public! !
!CheckButton class categoriesFor: #initialize!development!initializing!private! !
!CheckButton class categoriesFor: #themePartName!accessing!public! !
!CheckButton class categoriesFor: #winClassName!constants!private! !

