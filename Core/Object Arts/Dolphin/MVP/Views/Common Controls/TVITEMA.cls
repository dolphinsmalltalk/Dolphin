"Filed out from Dolphin Smalltalk 7"!

TVITEMW subclass: #TVITEMA
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
TVITEMA guid: (GUID fromString: '{adc42768-0507-494f-9fb0-65706fcfba41}')!
TVITEMA comment: ''!
!TVITEMA categoriesForClass!External-Data-Structured-Win32! !
!TVITEMA methodsFor!

pszText
	"Answer the <String> value of the receiver's 'pszText' field."

	^String fromAddress: (bytes intPtrAtOffset: ##(self offsetOf: #pszText))!

pszText: aString
	"Set the receiver's 'pszText' field to the value of the argument, aString"

	bytes uintPtrAtOffset: ##(self offsetOf: #pszText) put: aString yourAddress! !
!TVITEMA categoriesFor: #pszText!**compiled accessors**!public! !
!TVITEMA categoriesFor: #pszText:!**compiled accessors**!public! !

!TVITEMA class methodsFor!

defineFields
	"Define the fields of the Win32 TVITEMA structure

		self compileDefinition
	"

	super defineFields.
	self defineField: #pszText type: (PointerField type: String) beOverride offset: 16.
	self assert: [self byteSize = 40]!

textClass
	^String! !
!TVITEMA class categoriesFor: #defineFields!initializing!public! !
!TVITEMA class categoriesFor: #textClass!constants!private! !

