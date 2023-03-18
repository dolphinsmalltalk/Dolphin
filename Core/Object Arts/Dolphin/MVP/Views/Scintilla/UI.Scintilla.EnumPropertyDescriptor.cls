"Filed out from Dolphin Smalltalk"!

UI.Scintilla.PropertyDescriptor
	subclass: #'UI.Scintilla.EnumPropertyDescriptor'
	instanceVariableNames: 'values nilChoice type'
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!
UI.Scintilla.EnumPropertyDescriptor guid: (Core.GUID fromString: '{d51520de-b9de-4bb2-9de8-fdeb0d9572b0}')!
UI.Scintilla.EnumPropertyDescriptor comment: '`EnumPropertyDescriptor`s are `PropertyDescriptor`s for `ScintillaView` properties defined as being of an enumerated type in the scintilla.iface definition file.

Enumerated values are mapped to `Symbol`s in Dolphin''s abstraction of the Scintilla API.
'!
!UI.Scintilla.EnumPropertyDescriptor categoriesForClass!Kernel-Objects! !
!UI.Scintilla.EnumPropertyDescriptor methodsFor!

initialize
	super initialize.
	nilChoice := '<Unspecified>'.
	type := Symbol!

nilChoice
	^nilChoice!

nilChoice: aString
	nilChoice := aString.
	self beNullable!

type: aClass 
	type := aClass!

values
	^values!

values: anObject
	values := anObject! !
!UI.Scintilla.EnumPropertyDescriptor categoriesForMethods!
initialize!initializing!private! !
nilChoice!accessing!public! !
nilChoice:!accessing!public! !
type:!public! !
values!accessing!public! !
values:!accessing!public! !
!

