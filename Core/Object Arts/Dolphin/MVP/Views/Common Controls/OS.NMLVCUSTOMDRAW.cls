"Filed out from Dolphin Smalltalk 7"!

OS.NMCUSTOMDRAW subclass: #'OS.NMLVCUSTOMDRAW'
	instanceVariableNames: 'column'
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {
		'_OffsetOf_clrText' -> 16r30.
		'_OffsetOf_clrTextBk' -> 16r34.
		'_OffsetOf_iSubItem' -> 16r38
	}!
OS.NMLVCUSTOMDRAW guid: (Core.GUID fromString: '{7fbf7515-c756-4b0e-8d4f-01debafa1178}')!
OS.NMLVCUSTOMDRAW comment: '`NMLVCUSTOMDRAW` is an `ExternalStructure` class to represent the Win32 structure of the same name.

`NMLVCUSTOMDRAW` is sent by `ListView` controls to request custom draw information for the text of individual items (and optionally sub-items). We implement the `customDrawContext` protocol against it in order that it can be passed directly to the views customDrawBlock.'!
!OS.NMLVCUSTOMDRAW categoriesForClass!External-Data-Structured-Win32! !
!OS.NMLVCUSTOMDRAW methodsFor!

applyFont
	
	"If a font has not been set, install the view's font to ensure any font change from a previous column is reset"
	font isNil ifTrue: [font := self view actualFont].

	^super applyFont!

backcolor
	"Answer the background <Color>."

	| clrTextBk |
	clrTextBk := self clrTextBk.
	^clrTextBk = CLR_DEFAULT ifTrue: [Graphics.Color window] ifFalse: [Graphics.Color fromCOLORREF: clrTextBk]!

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
	^clrText = CLR_DEFAULT ifTrue: [Graphics.Color windowText] ifFalse: [Graphics.Color fromCOLORREF: clrText]!

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

	self forecolor: (self view forecolor ifNil: [Graphics.Color windowText])!

subItem
	| row |
	row := self item.
	self column ifNotNil: [:col | col getContentsBlock ifNotNil: [:getblock | ^getblock value: row]].
	^row! !
!OS.NMLVCUSTOMDRAW categoriesFor: #applyFont!operations!private! !
!OS.NMLVCUSTOMDRAW categoriesFor: #backcolor!accessing!public! !
!OS.NMLVCUSTOMDRAW categoriesFor: #backcolor:!accessing!public! !
!OS.NMLVCUSTOMDRAW categoriesFor: #clrText!**compiled accessors**!public! !
!OS.NMLVCUSTOMDRAW categoriesFor: #clrText:!**compiled accessors**!public! !
!OS.NMLVCUSTOMDRAW categoriesFor: #clrTextBk!**compiled accessors**!public! !
!OS.NMLVCUSTOMDRAW categoriesFor: #clrTextBk:!**compiled accessors**!public! !
!OS.NMLVCUSTOMDRAW categoriesFor: #column!accessing!public! !
!OS.NMLVCUSTOMDRAW categoriesFor: #column:!accessing!private! !
!OS.NMLVCUSTOMDRAW categoriesFor: #font!accessing!public! !
!OS.NMLVCUSTOMDRAW categoriesFor: #forecolor!accessing!public! !
!OS.NMLVCUSTOMDRAW categoriesFor: #forecolor:!accessing!public! !
!OS.NMLVCUSTOMDRAW categoriesFor: #iSubItem!**compiled accessors**!public! !
!OS.NMLVCUSTOMDRAW categoriesFor: #itemHandle!accessing!private! !
!OS.NMLVCUSTOMDRAW categoriesFor: #reset!public! !
!OS.NMLVCUSTOMDRAW categoriesFor: #subItem!accessing!public! !

!OS.NMLVCUSTOMDRAW class methodsFor!

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
!OS.NMLVCUSTOMDRAW class categoriesFor: #defineFields!public!template definition! !
!OS.NMLVCUSTOMDRAW class categoriesFor: #getFieldNames!**compiled accessors**!constants!private! !

