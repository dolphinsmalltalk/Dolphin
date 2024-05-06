"Filed out from Dolphin Smalltalk"!

ScalarField subclass: #AbstractCHARField
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!

AbstractCHARField guid: (GUID fromString: '{225e024e-8ea6-493f-ad47-82a47ac5cb5c}')!

AbstractCHARField comment: ''!

!AbstractCHARField categoriesForClass!Unclassified! !

!AbstractCHARField methodsFor!

basicWriteInto: anExternalStructure value: anInteger
	^self subclassResponsibility!

fieldClassName
	^#Character!

printMutatorValueOn: aWriteStream parameter: aString
	"Private - Print a suitable expression onto the specified <puttableStream> which will
	evaluate to the the value to be stored into this field in an instance of the structure when
	compiled into a mutator method where the value parameter is named by the <String> argument."

	aWriteStream
		nextPutAll: aString;
		space;
		display: #codePoint!

writeInto: anExternalStructure value: aCharacter
	"Private - Write the code point of the <Character>, aCharacter, into the <ExternalStructure>, anExternalStructure, at the receiver's offset."

	^self basicWriteInto: anExternalStructure value: aCharacter codePoint! !

!AbstractCHARField categoriesForMethods!
basicWriteInto:value:!accessing!public! !
fieldClassName!automatic generation!constants!development!private! !
printMutatorValueOn:parameter:!automatic generation!development!private! !
writeInto:value:!indirect accessing!private! !
!

