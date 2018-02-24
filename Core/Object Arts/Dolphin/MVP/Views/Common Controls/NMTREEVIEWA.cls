"Filed out from Dolphin Smalltalk 7"!

NMTREEVIEWW subclass: #NMTREEVIEWA
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
NMTREEVIEWA guid: (GUID fromString: '{75c615f1-acf7-402c-b349-e86c69fd1a7e}')!
NMTREEVIEWA comment: ''!
!NMTREEVIEWA categoriesForClass!External-Data-Structured-Win32! !
!NMTREEVIEWA methodsFor!

itemNew
	"Answer the <TVITEMA> value of the receiver's 'itemNew' field."

	^TVITEMA fromAddress: bytes yourAddress + ##(self offsetOf: #itemNew)!

itemOld
	"Answer the <TVITEMA> value of the receiver's 'itemOld' field."

	^TVITEMA fromAddress: bytes yourAddress + ##(self offsetOf: #itemOld)! !
!NMTREEVIEWA categoriesFor: #itemNew!**compiled accessors**!public! !
!NMTREEVIEWA categoriesFor: #itemOld!**compiled accessors**!public! !

!NMTREEVIEWA class methodsFor!

defineFields
	"Define the structure template for Win32 NMTREEVIEW structure.
		self compileDefinition
	"

	super defineFields.
	self
		defineField: #itemOld type: (StructureField type: TVITEMA) beReadOnly beOverride offset: 16; 
		defineField: #itemNew type: (StructureField type: TVITEMA) beReadOnly beOverride offset: 56! !
!NMTREEVIEWA class categoriesFor: #defineFields!initializing!public! !

