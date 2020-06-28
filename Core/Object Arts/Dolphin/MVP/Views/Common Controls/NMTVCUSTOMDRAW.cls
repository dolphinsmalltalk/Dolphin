"Filed out from Dolphin Smalltalk 7"!

NMCUSTOMDRAW subclass: #NMTVCUSTOMDRAW
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''
	classConstants: {
		'_OffsetOf_clrText' -> 16r30.
		'_OffsetOf_clrTextBk' -> 16r34.
		'_OffsetOf_iLevel' -> 16r38
	}!
NMTVCUSTOMDRAW guid: (GUID fromString: '{6c514b98-57bd-498b-a2ec-9763f141a8e6}')!
NMTVCUSTOMDRAW comment: 'NMTVCUSTOMDRAW is an <ExternalStructure> class to represent the Win32 structure of the same name.

NMTVCUSTOMDRAW is sent by <TreeView> controls to request custom draw information for the text of individual nodes. We implement the <customDrawContext> protocol against it in order that it can be passed directly to the views customDrawBlock.'!
!NMTVCUSTOMDRAW categoriesForClass!External-Data-Structured-Win32! !
!NMTVCUSTOMDRAW methodsFor!

backcolor
	"Answer the background <Color>."

	| clrTextBk |
	clrTextBk := self clrTextBk.
	^clrTextBk = CLR_DEFAULT ifTrue: [Color window] ifFalse: [Color fromCOLORREF: clrTextBk]!

backcolor: aColor
	"Sets the background <Color>."

	self clrTextBk: aColor asCOLORREF!

clrText
	"Answer the <Integer> value of the receiver's 'clrText' field."

	^bytes dwordAtOffset: _OffsetOf_clrText!

clrText: anInteger
	"Set the receiver's 'clrText' field to the value of the argument, anInteger"

	bytes dwordAtOffset: _OffsetOf_clrText put: anInteger!

clrTextBk
	"Answer the <Integer> value of the receiver's 'clrTextBk' field."

	^bytes dwordAtOffset: _OffsetOf_clrTextBk!

clrTextBk: anInteger
	"Set the receiver's 'clrTextBk' field to the value of the argument, anInteger"

	bytes dwordAtOffset: _OffsetOf_clrTextBk put: anInteger!

forecolor
	"Answer the foreground text colour."

	| clrText |
	clrText := self clrText.
	^clrText = CLR_DEFAULT ifTrue: [Color windowText] ifFalse: [Color fromCOLORREF: clrText]!

forecolor: aColor
	"Sets the text foreground <Color>."

	self clrText: aColor asCOLORREF!

iLevel
	"Answer the <Integer> value of the receiver's 'iLevel' field."

	^bytes sdwordAtOffset: _OffsetOf_iLevel! !
!NMTVCUSTOMDRAW categoriesFor: #backcolor!accessing!public! !
!NMTVCUSTOMDRAW categoriesFor: #backcolor:!accessing!public! !
!NMTVCUSTOMDRAW categoriesFor: #clrText!**compiled accessors**!public! !
!NMTVCUSTOMDRAW categoriesFor: #clrText:!**compiled accessors**!public! !
!NMTVCUSTOMDRAW categoriesFor: #clrTextBk!**compiled accessors**!public! !
!NMTVCUSTOMDRAW categoriesFor: #clrTextBk:!**compiled accessors**!public! !
!NMTVCUSTOMDRAW categoriesFor: #forecolor!accessing!public! !
!NMTVCUSTOMDRAW categoriesFor: #forecolor:!accessing!public! !
!NMTVCUSTOMDRAW categoriesFor: #iLevel!**compiled accessors**!public! !

!NMTVCUSTOMDRAW class methodsFor!

defineFields
	"Define the structure template for Win32 NMTVCUSTOMDRAW structure.
		self compileDefinition
	"

	super defineFields.
	self 
		defineField: #clrText type: DWORDField new;
		defineField: #clrTextBk type: DWORDField new;
		defineField: #iLevel type: SDWORDField readOnly!

getFieldNames
	^#(#hwndFrom #idFrom #code #dwDrawStage #hdc #rc #dwItemSpec #uItemState #lParam #clrText #clrTextBk #iLevel)! !
!NMTVCUSTOMDRAW class categoriesFor: #defineFields!public!template definition! !
!NMTVCUSTOMDRAW class categoriesFor: #getFieldNames!**compiled accessors**!constants!private! !

