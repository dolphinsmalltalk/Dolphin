"Filed out from Dolphin Smalltalk 7"!

NMCUSTOMDRAW subclass: #NMLVCUSTOMDRAW
	instanceVariableNames: 'column'
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
NMLVCUSTOMDRAW guid: (GUID fromString: '{7fbf7515-c756-4b0e-8d4f-01debafa1178}')!
NMLVCUSTOMDRAW comment: 'NMLVCUSTOMDRAW is an <ExternalStructure> class to represent the Win32 structure of the same name.

NMLVCUSTOMDRAW is sent by <ListView> controls to request custom draw information for the text of individual items (and optionally sub-items). We implement the <customDrawContext> protocol against it in order that it can be passed directly to the views customDrawBlock.'!
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
	"Answer the receiver's clrText field as a Smalltalk object."

	^bytes dwordAtOffset: ##(self offsetOf: #clrText)!

clrText: anObject 
	"Set the receiver's clrText field to the value of anObject."

	bytes dwordAtOffset: ##(self offsetOf: #clrText) put: anObject!

clrTextBk
	"Answer the receiver's clrTextBk field as a Smalltalk object."

	^bytes dwordAtOffset: ##(self offsetOf: #clrTextBk)!

clrTextBk: anObject 
	"Set the receiver's clrTextBk field to the value of anObject."

	bytes dwordAtOffset: ##(self offsetOf: #clrTextBk) put: anObject!

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
	"Answer the receiver's iSubItem field as a Smalltalk object."

	^bytes sdwordAtOffset: ##(self offsetOf: #iSubItem)!

itemHandle
	"Answer the 'handle' of the receiver's item."

	^self dwItemSpec + 1! !
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

!NMLVCUSTOMDRAW class methodsFor!

defineFields
	"Define the structure template for Win32 NMLVCUSTOMDRAW structure.
		self compileDefinition
	"

	super defineFields.
	self 
		defineField: #clrText type: DWORDField new;
		defineField: #clrTextBk type: DWORDField new;
		defineField: #iSubItem type: SDWORDField readOnly! !
!NMLVCUSTOMDRAW class categoriesFor: #defineFields!initializing!public! !

