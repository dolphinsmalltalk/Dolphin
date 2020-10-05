"Filed out from Dolphin Smalltalk 7"!

UI.CommandButton subclass: #'UI.PushButton'
	instanceVariableNames: 'image isDefault note _reserved1 _reserved2'
	classVariableNames: 'ButtonStyleMap'
	imports: #(#{OS.ButtonConstants})
	classInstanceVariableNames: ''
	classConstants: {}!
UI.PushButton guid: (Core.GUID fromString: '{87b4c729-026e-11d3-9fd7-00a0cc3e4a32}')!
UI.PushButton comment: 'PushButton is a <CommandButton> implementing the Windows "BUTTON" class, usually in push button mode, i.e. with the BS_PUSHLIKE style. 

Note that we have chosen not to support the text alignment styles of the BUTTON control on PushButton''s, because the ability to align the text in the push button rectangle doesn''t seem that useful. Alignment styles are, however, supported on the other incarnations of the BUTTON control as represented by the <CheckBox> and <RadioButton> classes, and so if needed the implemenation can be borrowed from there.

As of Dolphin 6.1 the Vista Command Link button style, with a note displayed in the form of a sub-title, is supported, but only when running on Vista. Command Link buttons degrade to a normal push button on earlier platforms. 

Instance Variables:
	image			<Image> or nil, specifying an image to overlay the button.
	buttonStyle		<integer> Windows style flags for the button.
	note				<String> or nil. Sub-text used if in Command Link button style.
	_reserved1		Reserved for future use.
	_reserved2		Reserved for future use.

Class Variables:
	ButtonStyleMap		<IdentityDictionary> mapping <Symbol>ic button style names to the corresponding <Integer> style flags.
'!
!UI.PushButton categoriesForClass!MVP-Views! !
!UI.PushButton methodsFor!

baseCreationStyle
	| base |
	base := self baseStyle.
	"Command Link style is only supported on Vista. If not on Vista (or later) downgrade to a
	normal push button"
	((base allMask: BS_COMMANDLINK) and: [SystemMetrics current hasLinkButtons not])
		ifTrue: [base := base maskClear: BS_COMMANDLINK].
	^base!

bmSetStyle: message wParam: wParam lParam: lParam 
	"Private - Handler for BM_SETSTYLE message."

	"Implementation Note: We use this to keep track of the button style which is useful when 
	buttons are used in dialogs, because the default dialog proc. toggles between BS_PUSHBUTTON
	and BS_DEFPUSHBUTTON as the user navigates around."

	isDefault := wParam allMask: BS_DEFPUSHBUTTON.
	^nil!

command: codeInteger id: idInteger 
	"Private - Responds to a command notification message which has been redirected to us."

	^codeInteger == BN_CLICKED ifTrue: [self presenter performAction]!

defaultWindowStyle
	"Private - Answer the default style to use when creating a push button."

	^super defaultWindowStyle bitOr: ##(BS_PUSHBUTTON | BS_MULTILINE)!

getNote
	| length chars |
	length := self sendMessage: BCM_GETNOTELENGTH.
	length == 0 ifTrue: [^''].
	chars := Utf16String newFixed: length.
	length := DWORD fromInteger: length + 1.
	self
		sendMessage: BCM_GETNOTE
		wParam: length yourAddress
		lpParam: chars.
	^chars asString!

hasFlatAppearance
	"Answers true if the receiver has a flat appearance."

	^self baseStyleAllMask: BS_FLAT!

hasFlatAppearance: aBoolean 
	"Sets the receiver to have a flat appearance if aBoolean is true.
	Note that this has no effect on Windows XP using new look common controls,
	as the visual appearance of these is determined by the current theme."

	self 
		baseStyleMask: BS_FLAT
		set: aBoolean
		recreateIfChanged: true	"Recreate required for this change to take effect."!

id: anInteger 
	"Set the receiver's identifier to the <integer> argument."

	"Implementation Note: Default push buttons need to keep their shell informed 
	of any change because these need to keep track of the default button id
	to correctly manage the default when the user navigates to non-button controls."

	| currentId |
	currentId := self id.
	(currentId ~~ 0 and: [currentId ~~ anInteger and: [self isDefault]]) 
		ifTrue: 
			[self isDefault: false.
			super id: anInteger.
			self isDefault: true]
		ifFalse: [super id: anInteger]!

image
	"Answers the <Image> used for the receiver's background, or nil if none."

	^image!

image: anImageOrNil 
	"Sets the image displayed by the receiver to anImageOrNil"

	(image := anImageOrNil) isNil 
		ifTrue: 
			[self baseStyle: 0 maskedBy: ##(BS_BITMAP | BS_ICON).
			^self].
	self baseStyle: (anImageOrNil imageType = IMAGE_ICON ifTrue: [BS_ICON] ifFalse: [BS_BITMAP])
		maskedBy: ##(BS_BITMAP | BS_ICON).
	self 
		sendMessage: BM_SETIMAGE
		wParam: anImageOrNil imageType
		lParam: anImageOrNil asParameter!

initialize
	super initialize.
	isDefault := false!

isChecked
	"Answer whether the receiver is currently pushed."

	"Implementation Note: The answer is always false if the receiver is the standard push button
	style (i.e. not a toggle button or checkbox)"

	| state |
	state := self 
				sendMessage: BM_GETSTATE
				wParam: 0
				lParam: 0.
	^state allMask: BST_CHECKED!

isChecked: aBoolean 
	"Set whether the receiver is 'checked'. If the receiver has check-box style, this means it
	will be ticked, if toggle-button it will appear pushed in, and if a standard push-button
	then this method has no effect."

	"Note that we don't support the 3rd (indeterminate) state for checkable command buttons"
	| buttonState |
	buttonState := aBoolean ifTrue: [BST_CHECKED] ifFalse: [BST_UNCHECKED].
	self 
		sendMessage: BM_SETCHECK
		wParam: buttonState
		lParam: 0!

isDefault
	"Answer whether the receiver has the default button style."

	^isDefault and: [#(#link #push) includes: self style]!

isDefault: aBoolean 
	"Set the receiver to be the default button in the nearest enclosing Shell according to
	aBoolean. If true, the button displays the default button border (however that is
	represented in the configured theme), and the user can press it by hitting the ENTER key,
	even when the button does not have the input focus. The Shell manages which of its buttons
	is the default, and any conflict as to defaultness is resolved such that the last claimant
	wins."

	self isOpen ifTrue: [self setDefault: aBoolean] ifFalse: [isDefault := aBoolean]!

isMultiline
	"Answers whether the receiver can display multiple lines of button text."

	^self baseStyleAllMask: BS_MULTILINE!

isMultiline: boolean 
	"Set whether the receiver can display multiple lines of button text."

	self 
		baseStyleMask: BS_MULTILINE
		set: boolean
		recreateIfChanged: true	"Recreate required for this style change to take effect"!

note
	"Answer the note (sub-text) associated with the Command Link button, if any."

	^note ?? ''!

note: aString 
	"Set the note (sub-text) associated with the Command Link button. Has no visual effect if
	the receiver is not of Command Link button style and/or not running on Vista."

	| newValue |
	newValue := (aString isNil or: [aString isEmpty]) ifFalse: [aString].
	note = newValue ifTrue: [^self].
	note := newValue.
	self setNote!

onDestroyed
	"Private - Handler for destroy. Inform the top shell that the receiver is being
	destroyed so that, if it is the default button, it may be removed as such"

	self topShell view buttonRemoved: self.
	^super onDestroyed!

onViewCreated
	"The receiver's window has been created. Copy any instance variable information
	across. Also buttons must inform their shell if they think they are the default
	(the last such created default button will assume the default state)."

	super onViewCreated.
	self image: self image.
	self isDefault ifTrue: [self setDefault: true].
	(note notNil and: [note notEmpty]) ifTrue: [self setNote]!

setDefault: aBoolean 
	"Private - Inform the receiver's shell of it's (non-)default state."

	self topShell view setDefaultButton: self state: aBoolean!

setNote
	| text |
	(self style == #link and: [SystemMetrics current hasButtonNotes]) ifFalse: [^self].
	text := self note asUtf16String.
	(self
		sendMessage: BCM_SETNOTE
		wParam: 0
		lpParam: text) == 0 ifTrue: [Win32Error signal]!

style
	^ButtonStyleMap 
		keyAtValue: (self baseStyle bitAnd: ##((BS_TYPEMASK bitOr: BS_PUSHLIKE) maskClear: BS_DEFPUSHBUTTON))!

style: aSymbol 
	| styleFlags |
	self style == aSymbol ifTrue: [^self].
	"We must make sure the button is not checked if switching out of checked button style, as
	otherwise it may remain pushed such that it cannot be unpushed."
	aSymbol == #check ifFalse: [self isChecked: false].
	styleFlags := ButtonStyleMap at: aSymbol ifAbsent: [#push].
	self isDefault ifTrue: [styleFlags := styleFlags maskSet: BS_DEFPUSHBUTTON].
	self 
		baseStyle: styleFlags
		maskedBy: ##(BS_TYPEMASK | BS_PUSHLIKE)
		recreateIfChanged: styleFlags == #link.
	"Redraw the button in the new style, and it may need checking/unchecking depending on that new style"
	self
		invalidate;
		invalidateUserInterface!

text: aString
	"Sets the text of the receiver (and its command description) to aString"

	super text: aString.
	commandDescription description: aString! !
!UI.PushButton categoriesFor: #baseCreationStyle!private!realizing/unrealizing! !
!UI.PushButton categoriesFor: #bmSetStyle:wParam:lParam:!event handling-win32!private! !
!UI.PushButton categoriesFor: #command:id:!commands!private! !
!UI.PushButton categoriesFor: #defaultWindowStyle!constants!private! !
!UI.PushButton categoriesFor: #getNote!helpers!private! !
!UI.PushButton categoriesFor: #hasFlatAppearance!accessing-styles!public! !
!UI.PushButton categoriesFor: #hasFlatAppearance:!accessing-styles!public! !
!UI.PushButton categoriesFor: #id:!accessing!public! !
!UI.PushButton categoriesFor: #image!accessing!public! !
!UI.PushButton categoriesFor: #image:!accessing!public! !
!UI.PushButton categoriesFor: #initialize!initializing!private! !
!UI.PushButton categoriesFor: #isChecked!accessing!public! !
!UI.PushButton categoriesFor: #isChecked:!accessing!public! !
!UI.PushButton categoriesFor: #isDefault!public!testing! !
!UI.PushButton categoriesFor: #isDefault:!accessing-styles!public! !
!UI.PushButton categoriesFor: #isMultiline!accessing-styles!public! !
!UI.PushButton categoriesFor: #isMultiline:!accessing-styles!public! !
!UI.PushButton categoriesFor: #note!accessing!public! !
!UI.PushButton categoriesFor: #note:!accessing!public! !
!UI.PushButton categoriesFor: #onDestroyed!event handling!private! !
!UI.PushButton categoriesFor: #onViewCreated!event handling!public! !
!UI.PushButton categoriesFor: #setDefault:!accessing-styles!private! !
!UI.PushButton categoriesFor: #setNote!helpers!private! !
!UI.PushButton categoriesFor: #style!accessing!public! !
!UI.PushButton categoriesFor: #style:!accessing!public! !
!UI.PushButton categoriesFor: #text:!accessing!public! !

UI.PushButton methodProtocol: #commandSource attributes: #(#readOnly) selectors: #(#commandDescription)!

!UI.PushButton class methodsFor!

buttonMessageMappings
	^{BM_SETSTYLE -> #bmSetStyle:wParam:lParam:}!

icon
	"Answers an <Icon> that can be used to represent this class"

	^##(self) defaultIcon!

initialize
	"Private - Initialize the receiver's class variables.
		PushButton initialize
	"

	self registerMessageMappings: self buttonMessageMappings.
	self addClassConstant: 'ButtonStyleMap'
		value: (IdentityDictionary new
				at: #push put: BS_PUSHBUTTON;
				at: #toggle put: BS_CHECKBOX | BS_PUSHLIKE;
				at: #check put: BS_CHECKBOX;
				at: #link put: BS_COMMANDLINK;
				shrink;
				isImmutable: true;
				yourself).

	"Implementation makes some assumptions about the nature of the default button encoding in the style flags"
	self assert: [BS_DEFPUSHBUTTON == 1 and: [BS_DEFCOMMANDLINK == (BS_COMMANDLINK | BS_DEFPUSHBUTTON)]]!

resource_Cancel_button
	"Answer the literal data from which the 'Cancel button' resource can be reconstituted.
	DO NOT EDIT OR RECATEGORIZE THIS METHOD.

	If you wish to modify this resource evaluate:
	ViewComposer openOn: (ResourceIdentifier class: self selector: #resource_Cancel_button)
	"

	^#(#'!!STL' 4 985166 10 ##(UI.STBViewProxy) ##(UI.PushButton) 34 20 nil nil 34 2 8 1140924416 1 416 nil nil nil 7 nil nil nil 416 nil 8 1920683440 1377606 4 ##(UI.CommandDescription) #cancel 8 '&Cancel' 1 1 nil nil false nil nil nil 1310982 ##(Core.MessageSequence) 138 144 34 3 1049350 ##(Core.MessageSend) #createAt:extent: 34 2 655878 ##(Graphics.Point) 6143 21 658 141 51 416 610 #isEnabled: 8 #(false) 416 610 #text: 34 1 8 '&Cancel' 416 1179910 ##(OS.WINDOWPLACEMENT) 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 11 0 0 10 0 0 0 69 12 0 0 35 0 0 0] 8 #() 658 193 193 nil 29)!

resource_No_button
	"Answer the literal data from which the 'No button' resource can be reconstituted.
	DO NOT EDIT OR RECATEGORIZE THIS METHOD.

	If you wish to modify this resource evaluate:
	ViewComposer openOn: (ResourceIdentifier class: self selector: #resource_No_button)
	"

	^#(#'!!STL' 4 985166 10 ##(UI.STBViewProxy) ##(UI.PushButton) 34 20 nil nil 34 2 8 1140924416 1 416 nil nil nil 7 nil nil nil 416 nil 8 1920683440 1377606 4 ##(UI.CommandDescription) #no 8 '&No' 1 1 nil nil false nil nil nil 1310982 ##(Core.MessageSequence) 138 144 34 3 1049350 ##(Core.MessageSend) #createAt:extent: 34 2 655878 ##(Graphics.Point) 6143 21 658 141 51 416 610 #isEnabled: 8 #(false) 416 610 #text: 34 1 8 '&No' 416 1179910 ##(OS.WINDOWPLACEMENT) 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 11 0 0 10 0 0 0 69 12 0 0 35 0 0 0] 8 #() 658 193 193 nil 29)!

resource_OK_button
	"Answer the literal data from which the 'OK button' resource can be reconstituted.
	DO NOT EDIT OR RECATEGORIZE THIS METHOD.

	If you wish to modify this resource evaluate:
	ViewComposer openOn: (ResourceIdentifier class: self selector: #resource_OK_button)
	"

	^#(#'!!STL' 4 985166 10 ##(UI.STBViewProxy) ##(UI.PushButton) 34 20 nil nil 34 2 8 1140924416 1 416 nil nil nil 7 nil nil nil 416 nil 8 1920683440 1377606 4 ##(UI.CommandDescription) #ok 8 '&OK' 1 1 nil nil true nil nil nil 1310982 ##(Core.MessageSequence) 138 144 34 3 1049350 ##(Core.MessageSend) #createAt:extent: 34 2 655878 ##(Graphics.Point) 6143 21 658 141 51 416 610 #isEnabled: 8 #(false) 416 610 #text: 34 1 8 '&OK' 416 1179910 ##(OS.WINDOWPLACEMENT) 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 11 0 0 10 0 0 0 69 12 0 0 35 0 0 0] 8 #() 658 193 193 nil 29)!

resource_Push_and_check
	"Answer the literal data from which the 'Push and check' resource can be reconstituted.
	DO NOT EDIT OR RECATEGORIZE THIS METHOD.

	If you wish to modify this resource evaluate:
	ViewComposer openOn: (ResourceIdentifier class: self selector: #resource_Push_and_check)
	"

	^#(#'!!STL' 4 985166 10 ##(UI.STBViewProxy) ##(UI.CheckBox) 34 16 nil nil 34 2 8 1409363971 1 416 918598 2 ##(UI.ValueHolder) nil nil 1441798 ##(Kernel.NeverSearchPolicy) false 917510 ##(Graphics.Color) #default nil 5 nil nil nil 416 nil 8 1920683440 1049094 ##(UI.NullConverter) nil nil nil 1310982 ##(Core.MessageSequence) 138 144 34 2 1049350 ##(Core.MessageSend) #createAt:extent: 34 2 655878 ##(Graphics.Point) 6143 21 738 231 61 416 690 #text: 34 1 8 'Push and Check' 416 1179910 ##(OS.WINDOWPLACEMENT) 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 11 0 0 10 0 0 0 114 12 0 0 40 0 0 0] 8 #() 738 193 193 nil 27)!

resource_Push_button
	"Answer the literal data from which the 'Push button' resource can be reconstituted.
	DO NOT EDIT OR RECATEGORIZE THIS METHOD.

	If you wish to modify this resource evaluate:
	ViewComposer openOn: (ResourceIdentifier class: self selector: #resource_Push_button)
	"

	^#(#'!!STL' 4 985166 10 ##(UI.STBViewProxy) ##(UI.PushButton) 34 20 nil nil 34 2 8 1140924416 1 416 nil nil nil 7 nil nil nil 416 nil 8 1920683440 1377606 4 ##(UI.CommandDescription) nil nil 1 1 nil nil false nil nil nil 1310982 ##(Core.MessageSequence) 138 144 34 2 1049350 ##(Core.MessageSend) #createAt:extent: 34 2 655878 ##(Graphics.Point) 6143 21 642 141 51 416 594 #isEnabled: 8 #(false) 416 1179910 ##(OS.WINDOWPLACEMENT) 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 11 0 0 10 0 0 0 69 12 0 0 35 0 0 0] 8 #() 642 193 193 nil 29)!

resource_Yes_button
	"Answer the literal data from which the 'Yes button' resource can be reconstituted.
	DO NOT EDIT OR RECATEGORIZE THIS METHOD.

	If you wish to modify this resource evaluate:
	ViewComposer openOn: (ResourceIdentifier class: self selector: #resource_Yes_button)
	"

	^#(#'!!STL' 4 985166 10 ##(UI.STBViewProxy) ##(UI.PushButton) 34 20 nil nil 34 2 8 1140924416 1 416 nil nil nil 7 nil nil nil 416 nil 8 1920683440 1377606 4 ##(UI.CommandDescription) #yes 8 '&Yes' 1 1 nil nil false nil nil nil 1310982 ##(Core.MessageSequence) 138 144 34 3 1049350 ##(Core.MessageSend) #createAt:extent: 34 2 655878 ##(Graphics.Point) 6143 21 658 141 51 416 610 #isEnabled: 8 #(false) 416 610 #text: 34 1 8 '&Yes' 416 1179910 ##(OS.WINDOWPLACEMENT) 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 11 0 0 10 0 0 0 69 12 0 0 35 0 0 0] 8 #() 658 193 193 nil 29)!

stbConvertFromVersion1: anArray
	"Private - Perform an STB conversion from a version 1 (or earlier) <View> to version 2."

	| array |
	array := super stbConvertFromVersion1: anArray.
	array at: 13 put: (CommandDescription command: (array at: 13)).
	^array!

stbConvertFromVersion9: anArray 
	"Private - Perform an STB conversion from a version 9 (or earlier) <View> to version 10,
	i.e. use #reserved1 inst. var. for flags."

	| array |
	array := super stbConvertFromVersion9: anArray.
	array at: 17 put: (array at: 17) == BS_DEFPUSHBUTTON.
	^array!

stbVersion
	^14!

uninitialize
	self unregisterMessageMappings: {BM_SETSTYLE}!

winClassName
	"Private - Answer the name of the Windows window class to use when realising the receiver."

	^'BUTTON'
! !
!UI.PushButton class categoriesFor: #buttonMessageMappings!constants!must not strip!private! !
!UI.PushButton class categoriesFor: #icon!constants!public! !
!UI.PushButton class categoriesFor: #initialize!development!initializing!private! !
!UI.PushButton class categoriesFor: #resource_Cancel_button!public!resources-views! !
!UI.PushButton class categoriesFor: #resource_No_button!public!resources-views! !
!UI.PushButton class categoriesFor: #resource_OK_button!public!resources-views! !
!UI.PushButton class categoriesFor: #resource_Push_and_check!public!resources-views! !
!UI.PushButton class categoriesFor: #resource_Push_button!public!resources-views! !
!UI.PushButton class categoriesFor: #resource_Yes_button!public!resources-views! !
!UI.PushButton class categoriesFor: #stbConvertFromVersion1:!binary filing!private! !
!UI.PushButton class categoriesFor: #stbConvertFromVersion9:!binary filing!private! !
!UI.PushButton class categoriesFor: #stbVersion!public! !
!UI.PushButton class categoriesFor: #uninitialize!class hierarchy-removing!private! !
!UI.PushButton class categoriesFor: #winClassName!constants!private! !

