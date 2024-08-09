"Filed out from Dolphin Smalltalk"!

NMCUSTOMDRAW subclass: #NMTVCUSTOMDRAW
	instanceVariableNames: ''
	classVariableNames: '_OffsetOf_clrText _OffsetOf_clrTextBk _OffsetOf_iLevel'
	poolDictionaries: ''
	classInstanceVariableNames: ''!

NMTVCUSTOMDRAW guid: (GUID fromString: '{6c514b98-57bd-498b-a2ec-9763f141a8e6}')!

NMTVCUSTOMDRAW addClassConstant: '_OffsetOf_clrText' value: 16r30!
NMTVCUSTOMDRAW addClassConstant: '_OffsetOf_clrTextBk' value: 16r34!
NMTVCUSTOMDRAW addClassConstant: '_OffsetOf_iLevel' value: 16r38!

NMTVCUSTOMDRAW comment: 'NMTVCUSTOMDRAW is an <ExternalStructure> class to represent the Win32 structure of the same name.

NMTVCUSTOMDRAW is sent by <TreeView> controls to request custom draw information for the text of individual nodes. We implement the <customDrawContext> protocol against it in order that it can be passed directly to the views customDrawBlock.'!

!NMTVCUSTOMDRAW categoriesForClass!External-Data-Structured-Win32! !

!NMTVCUSTOMDRAW methodsFor!

backcolor
	"Answer the background <Color>."

	| clrTextBk |
	clrTextBk := self clrTextBk.
	^clrTextBk isDefault ifTrue: [Color windowText] ifFalse: [clrTextBk]!

backcolor: aColor
	"Sets the background <Color>."

	self clrTextBk: aColor!

clrText
	"Answer the <Color> value of the receiver's 'clrText' field."

	^Color fromCOLORREF: (bytes dwordAtOffset: _OffsetOf_clrText)!

clrText: aColor
	"Set the receiver's 'clrText' field to the value of the argument, aColor"

	bytes dwordAtOffset: _OffsetOf_clrText put: aColor asCOLORREF!

clrTextBk
	"Answer the <Color> value of the receiver's 'clrTextBk' field."

	^Color fromCOLORREF: (bytes dwordAtOffset: _OffsetOf_clrTextBk)!

clrTextBk: aColor
	"Set the receiver's 'clrTextBk' field to the value of the argument, aColor"

	bytes dwordAtOffset: _OffsetOf_clrTextBk put: aColor asCOLORREF!

forecolor
	"Answer the foreground text colour."

	| clrText |
	clrText := self clrText.
	^clrText isDefault ifTrue: [Color windowText] ifFalse: [clrText]!

forecolor: aColor
	"Sets the text foreground <Color>."

	self clrText: aColor!

iLevel
	"Answer the <Integer> value of the receiver's 'iLevel' field."

	^bytes sdwordAtOffset: _OffsetOf_iLevel! !

!NMTVCUSTOMDRAW categoriesForMethods!
backcolor!accessing!public! !
backcolor:!accessing!public! !
clrText!**compiled accessors**!public! !
clrText:!**compiled accessors**!public! !
clrTextBk!**compiled accessors**!public! !
clrTextBk:!**compiled accessors**!public! !
forecolor!accessing!public! !
forecolor:!accessing!public! !
iLevel!**compiled accessors**!public! !
!

!NMTVCUSTOMDRAW class methodsFor!

defineFields
	"Define the structure template for Win32 NMTVCUSTOMDRAW structure.
		self compileDefinition
	"

	super defineFields.
	self 
		defineField: #clrText type: COLORREFField new;
		defineField: #clrTextBk type: COLORREFField new;
		defineField: #iLevel type: SDWORDField readOnly!

getFieldNames
	^#(#hwndFrom #idFrom #code #dwDrawStage #hdc #rc #dwItemSpec #uItemState #lParam #clrText #clrTextBk #iLevel)! !

!NMTVCUSTOMDRAW class categoriesForMethods!
defineFields!public!template definition! !
getFieldNames!**compiled accessors**!constants!private! !
!

