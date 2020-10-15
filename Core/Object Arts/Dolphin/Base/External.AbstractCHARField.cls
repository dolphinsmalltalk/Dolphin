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

printMutatorValueOn: aWriteStream parameter: aString
	"Private - Print a suitable expression onto the specified <puttableStream> which will
	evaluate to the the value to be stored into this field in an instance of the structure when
	compiled into a mutator method where the value parameter is named by the <String> argument."

	aWriteStream
		nextPutAll: aString;
		space;
		display: #codePoint!

valueType
	^Character!

writeInto: anExternalStructure value: aCharacter
	"Private - Write the code point of the <Character>, aCharacter, into the <ExternalStructure>, anExternalStructure, at the receiver's offset."

	^self basicWriteInto: anExternalStructure value: aCharacter codePoint! !
!External.AbstractCHARField categoriesFor: #basicWriteInto:value:!accessing!public! !
!External.AbstractCHARField categoriesFor: #printMutatorValueOn:parameter:!automatic generation!development!private! !
!External.AbstractCHARField categoriesFor: #valueType!automatic generation!constants!development!private! !
!External.AbstractCHARField categoriesFor: #writeInto:value:!indirect accessing!private! !

