"Filed out from Dolphin Smalltalk 7"!

External.ScalarField subclass: #'External.AbstractCHARField'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!
External.AbstractCHARField guid: (Core.GUID fromString: '{225e024e-8ea6-493f-ad47-82a47ac5cb5c}')!
External.AbstractCHARField comment: ''!
!External.AbstractCHARField categoriesForClass!Unclassified! !
!External.AbstractCHARField methodsFor!

basicWriteInto: anExternalStructure value: anInteger
	^self subclassResponsibility!

valueType
	^Character!

writeInto: anExternalStructure value: aCharacter
	"Private - Write the code point of the <Character>, aCharacter, into the <ExternalStructure>, anExternalStructure, at the receiver's offset."

	^self basicWriteInto: anExternalStructure value: aCharacter codePoint! !
!External.AbstractCHARField categoriesFor: #basicWriteInto:value:!accessing!public! !
!External.AbstractCHARField categoriesFor: #valueType!automatic generation!constants!development!private! !
!External.AbstractCHARField categoriesFor: #writeInto:value:!indirect accessing!private! !

