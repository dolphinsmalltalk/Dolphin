"Filed out from Dolphin Smalltalk 7"!

ScalarField subclass: #CHARField
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
CHARField guid: (GUID fromString: '{a70daacf-9954-43db-943f-1f8f245fcf07}')!
CHARField comment: '<CHARField> is a <ScalarField> class to represent <ExternalStructure> fields that are 8-bit character code units.'!
!CHARField categoriesForClass!External-Data-Types! !
!CHARField methodsFor!

accessorMessage
	"Private - Answer the receiver's 'accessorStem'."

	^#byteAtOffset:put:!

fieldClassName
	^Character name!

printMutatorValueOn: aWriteStream parameter: aString
	"Private - Print a suitable expression onto the specified <puttableStream> which will
	evaluate to the the value to be stored into this field in an instance of the structure when
	compiled into a mutator method where the value parameter is named by the <String> argument."

	aWriteStream
		nextPutAll: aString;
		space;
		display: #codePoint!

readFrom: anExternalStructure
	"Private - Answer a <Character> for the 8-bit code unit at the receiver's offset in the
	<ExternalStructure> argument."

	^(Character value: (anExternalStructure bytes byteAtOffset: offset))!

writeInto: anExternalStructure value: aCharacter
	"Private - Write the 8-bit unsigned <integer> code unit of the <Character>, aCharacter,
	into the <ExternalStructure>, anExternalStructure, at the receiver's offset. Raises an error
	if the Character's code unit > 255."

	^anExternalStructure bytes byteAtOffset: offset put: aCharacter codePoint! !
!CHARField categoriesFor: #accessorMessage!initializing!private! !
!CHARField categoriesFor: #fieldClassName!automatic generation!constants!development!private! !
!CHARField categoriesFor: #printMutatorValueOn:parameter:!automatic generation!development!private! !
!CHARField categoriesFor: #readFrom:!indirect accessing!private! !
!CHARField categoriesFor: #writeInto:value:!indirect accessing!private! !

!CHARField class methodsFor!

byteSize
	"Private - Answer the size of the field type the receiver represents in bytes."

	^1! !
!CHARField class categoriesFor: #byteSize!constants!private! !

