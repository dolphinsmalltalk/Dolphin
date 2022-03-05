"Filed out from Dolphin Smalltalk"!

NMCUSTOMDRAW subclass: #NMLVCUSTOMDRAW
	instanceVariableNames: 'column'
	classVariableNames: '_OffsetOf_clrText _OffsetOf_clrTextBk _OffsetOf_iSubItem'
	poolDictionaries: ''
	classInstanceVariableNames: ''!
NMLVCUSTOMDRAW guid: (GUID fromString: '{7fbf7515-c756-4b0e-8d4f-01debafa1178}')!
NMLVCUSTOMDRAW addClassConstant: '_OffsetOf_clrText' value: 16r30!
NMLVCUSTOMDRAW addClassConstant: '_OffsetOf_clrTextBk' value: 16r34!
NMLVCUSTOMDRAW addClassConstant: '_OffsetOf_iSubItem' value: 16r38!
NMLVCUSTOMDRAW comment: '`NMLVCUSTOMDRAW` is an `ExternalStructure` class to represent the Win32 structure of the same name.

`NMLVCUSTOMDRAW` is sent by `ListView` controls to request custom draw information for the text of individual items (and optionally sub-items). We implement the `customDrawContext` protocol against it in order that it can be passed directly to the views customDrawBlock.'!
!NMLVCUSTOMDRAW categoriesForClass!External-Data-Structured-Win32! !
!NMLVCUSTOMDRAW methodsFor!

applyFont
	
	"If a font has not been set, install the view's font to ensure any font change from a previous column is reset"
	font isNil ifTrue: [font := self view actualFont].

	^super applyFont!

backcolor
	"Answer the background <Color>."

	| clrTextBk |
	clrTextBk := self clrTextBk.
	^clrTextBk = CLR_DEFAULT ifTrue: [Color window] ifFalse: [Color fromCOLORREF: clrTextBk]!

backcolor: aColor
	"Sets the background <Color>.
	Implementation Note: We must convert to an RGB because a COLORREF is needed."

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

column
	"Answer the <ListViewColumn> associated with the sub-item if this is a sub-item
	draw, otherwise nil."

	^column!

column: aListViewColumn
	"Private -"
	column := aListViewColumn!

font
	"Answer the character font."

	"We assume the font is being accessed in order to be modified, so use a copy"
	^font ifNil: [font := self view actualFont copy]!

forecolor
	"Answer the foreground text colour."

	| clrText |
	clrText := self clrText.
	^clrText = CLR_DEFAULT ifTrue: [Color windowText] ifFalse: [Color fromCOLORREF: clrText]!

forecolor: aColor
	"Sets the text foreground <Color>."

	self clrText: aColor asCOLORREF!

iSubItem
	"Answer the <Integer> value of the receiver's 'iSubItem' field."

	^bytes sdwordAtOffset: _OffsetOf_iSubItem!

itemHandle
	"Answer the 'handle' of the receiver's item."

	^self dwItemSpec + 1!

reset
	"Reset the canvas to default settings."

	self forecolor: (self view forecolor ifNil: [Color windowText])!

subItem
	| item |
	item := self item.
	self column ifNotNil: [:col | col getContentsBlock ifNotNil: [:getblock | ^getblock value: item]].
	^item! !
!NMLVCUSTOMDRAW categoriesForMethods!
applyFont!operations!private! !
backcolor!accessing!public! !
backcolor:!accessing!public! !
clrText!**compiled accessors**!public! !
clrText:!**compiled accessors**!public! !
clrTextBk!**compiled accessors**!public! !
clrTextBk:!**compiled accessors**!public! !
column!accessing!public! !
column:!accessing!private! !
font!accessing!public! !
forecolor!accessing!public! !
forecolor:!accessing!public! !
iSubItem!**compiled accessors**!public! !
itemHandle!accessing!private! !
reset!public! !
subItem!accessing!public! !
!

!NMLVCUSTOMDRAW class methodsFor!

defineFields
	"Define the structure template for Win32 NMLVCUSTOMDRAW structure.
		self compileDefinition
	"

	super defineFields.
	self 
		defineField: #clrText type: DWORDField new;
		defineField: #clrTextBk type: DWORDField new;
		defineField: #iSubItem type: SDWORDField readOnly!

getFieldNames
	^#(#hwndFrom #idFrom #code #dwDrawStage #hdc #rc #dwItemSpec #uItemState #lParam #clrText #clrTextBk #iSubItem)! !
!NMLVCUSTOMDRAW class categoriesForMethods!
defineFields!public!template definition! !
getFieldNames!**compiled accessors**!constants!private! !
!

