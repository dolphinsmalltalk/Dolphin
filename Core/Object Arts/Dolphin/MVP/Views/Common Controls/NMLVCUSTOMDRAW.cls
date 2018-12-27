"Filed out from Dolphin Smalltalk 7"!

NMCUSTOMDRAW subclass: #NMLVCUSTOMDRAW
	instanceVariableNames: 'column'
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
NMLVCUSTOMDRAW guid: (GUID fromString: '{7fbf7515-c756-4b0e-8d4f-01debafa1178}')!
NMLVCUSTOMDRAW comment: '`NMLVCUSTOMDRAW` is an `ExternalStructure` class to represent the Win32 structure of the same name.

`NMLVCUSTOMDRAW` is sent by `ListView` controls to request custom draw information for the text of individual items (and optionally sub-items). We implement the `customDrawContext` protocol against it in order that it can be passed directly to the views customDrawBlock.'!
!NMLVCUSTOMDRAW categoriesForClass!External-Data-Structured-Win32! !
!NMLVCUSTOMDRAW methodsFor!

backcolor
	"Answer the background <Color>."

	| clrTextBk |
	clrTextBk := self clrTextBk.
	^clrTextBk = CLR_DEFAULT ifTrue: [Color window] ifFalse: [ColorRef fromInteger: clrTextBk]!

backcolor: aColor
	"Sets the background <Color>.
	Implementation Note: We must convert to an RGB because a COLORREF is needed."

	self clrTextBk: aColor asColorRef asParameter!

clrText
	"Answer the <Integer> value of the receiver's 'clrText' field."

	^bytes dwordAtOffset: ##(self offsetOf: #clrText)!

clrText: anInteger
	"Set the receiver's 'clrText' field to the value of the argument, anInteger"

	bytes dwordAtOffset: ##(self offsetOf: #clrText) put: anInteger!

clrTextBk
	"Answer the <Integer> value of the receiver's 'clrTextBk' field."

	^bytes dwordAtOffset: ##(self offsetOf: #clrTextBk)!

clrTextBk: anInteger
	"Set the receiver's 'clrTextBk' field to the value of the argument, anInteger"

	bytes dwordAtOffset: ##(self offsetOf: #clrTextBk) put: anInteger!

column
	"Answer the <ListViewColumn> associated with the sub-item if this is a sub-item
	draw, otherwise nil."

	^column!

column: aListViewColumn
	"Private -"
	column := aListViewColumn!

forecolor
	"Answer the foreground text colour."

	| clrText |
	clrText := self clrText.
	^clrText = CLR_DEFAULT ifTrue: [Color windowText] ifFalse: [ColorRef fromInteger: clrText]!

forecolor: aColor
	"Sets the text foreground <Color>."

	self clrText: aColor asColorRef asParameter!

iSubItem
	"Answer the <Integer> value of the receiver's 'iSubItem' field."

	^bytes sdwordAtOffset: ##(self offsetOf: #iSubItem)!

itemHandle
	"Answer the 'handle' of the receiver's item."

	^self dwItemSpec + 1!

reset
	"Reset the canvas to default settings."

	self font
		isItalic: false;
		isStruckThrough: false.
	self forecolor: (self view forecolor ifNil: [Color windowText])!

subItem
	| item |
	item := self item.
	self column ifNotNil: [:col | col getContentsBlock ifNotNil: [:getblock | ^getblock value: item]].
	^item! !
!NMLVCUSTOMDRAW categoriesFor: #backcolor!accessing!public! !
!NMLVCUSTOMDRAW categoriesFor: #backcolor:!accessing!public! !
!NMLVCUSTOMDRAW categoriesFor: #clrText!**compiled accessors**!public! !
!NMLVCUSTOMDRAW categoriesFor: #clrText:!**compiled accessors**!public! !
!NMLVCUSTOMDRAW categoriesFor: #clrTextBk!**compiled accessors**!public! !
!NMLVCUSTOMDRAW categoriesFor: #clrTextBk:!**compiled accessors**!public! !
!NMLVCUSTOMDRAW categoriesFor: #column!accessing!public! !
!NMLVCUSTOMDRAW categoriesFor: #column:!accessing!private! !
!NMLVCUSTOMDRAW categoriesFor: #forecolor!accessing!public! !
!NMLVCUSTOMDRAW categoriesFor: #forecolor:!accessing!public! !
!NMLVCUSTOMDRAW categoriesFor: #iSubItem!**compiled accessors**!public! !
!NMLVCUSTOMDRAW categoriesFor: #itemHandle!accessing!private! !
!NMLVCUSTOMDRAW categoriesFor: #reset!public! !
!NMLVCUSTOMDRAW categoriesFor: #subItem!accessing!public! !

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
!NMLVCUSTOMDRAW class categoriesFor: #defineFields!initializing!public! !
!NMLVCUSTOMDRAW class categoriesFor: #getFieldNames!**compiled accessors**!constants!private! !

