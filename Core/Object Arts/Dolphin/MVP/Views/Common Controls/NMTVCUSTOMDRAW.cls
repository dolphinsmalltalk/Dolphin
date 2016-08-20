"Filed out from Dolphin Smalltalk 7"!

NMCUSTOMDRAW subclass: #NMTVCUSTOMDRAW
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
NMTVCUSTOMDRAW guid: (GUID fromString: '{6C514B98-57BD-498B-A2EC-9763F141A8E6}')!
NMTVCUSTOMDRAW comment: 'NMTVCUSTOMDRAW is an <ExternalStructure> class to represent the Win32 structure of the same name.

NMTVCUSTOMDRAW is sent by <TreeView> controls to request custom draw information for the text of individual nodes. We implement the <customDrawContext> protocol against it in order that it can be passed directly to the views customDrawBlock.'!
!NMTVCUSTOMDRAW categoriesForClass!External-Data-Structured-Win32! !
!NMTVCUSTOMDRAW methodsFor!

backcolor
	"Answer the background <Color>."

	| clrTextBk |
	clrTextBk := self clrTextBk.
	^clrTextBk = CLR_DEFAULT ifTrue: [Color window] ifFalse: [ColorRef fromInteger: clrTextBk]!

backcolor: aColor
	"Sets the background <Color>."

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

forecolor
	"Answer the foreground text colour."

	| clrText |
	clrText := self clrText.
	^clrText = CLR_DEFAULT ifTrue: [Color windowText] ifFalse: [ColorRef fromInteger: clrText]!

forecolor: aColor
	"Sets the text foreground <Color>."

	self clrText: aColor asColorRef asParameter!

iLevel
	"Answer the receiver's iLevel field as a Smalltalk object."

	^bytes sdwordAtOffset: ##(self offsetOf: #iLevel)!

itemHandle
	"Private - Answer the 'handle' of the receiver's node."

	^self dwItemSpec! !
!NMTVCUSTOMDRAW categoriesFor: #backcolor!accessing!public! !
!NMTVCUSTOMDRAW categoriesFor: #backcolor:!accessing!public! !
!NMTVCUSTOMDRAW categoriesFor: #clrText!**compiled accessors**!public! !
!NMTVCUSTOMDRAW categoriesFor: #clrText:!**compiled accessors**!public! !
!NMTVCUSTOMDRAW categoriesFor: #clrTextBk!**compiled accessors**!public! !
!NMTVCUSTOMDRAW categoriesFor: #clrTextBk:!**compiled accessors**!public! !
!NMTVCUSTOMDRAW categoriesFor: #forecolor!accessing!public! !
!NMTVCUSTOMDRAW categoriesFor: #forecolor:!accessing!public! !
!NMTVCUSTOMDRAW categoriesFor: #iLevel!**compiled accessors**!public! !
!NMTVCUSTOMDRAW categoriesFor: #itemHandle!accessing!private! !

!NMTVCUSTOMDRAW class methodsFor!

defineFields
	"Define the structure template for Win32 NMTVCUSTOMDRAW structure.
		self compileDefinition
	"

	super defineFields.
	self 
		defineField: #clrText type: DWORDField new;
		defineField: #clrTextBk type: DWORDField new;
		defineField: #iLevel type: SDWORDField readOnly! !
!NMTVCUSTOMDRAW class categoriesFor: #defineFields!initializing!public! !

