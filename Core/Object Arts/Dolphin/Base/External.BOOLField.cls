"Filed out from Dolphin Smalltalk 7"!

External.ScalarField subclass: #'External.BOOLField'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!
External.BOOLField guid: (Core.GUID fromString: '{87b4c4e6-026e-11d3-9fd7-00a0cc3e4a32}')!
External.BOOLField comment: '<BOOLField> is a <ScalarField> class to represent <ExternalStructure> fields that are boolean values encoded as 32-bit integers, where 0 is False, and any other value is True.'!
!External.BOOLField categoriesForClass!External-Data-Types! !
!External.BOOLField methodsFor!

accessorMessage
	"Private - Answer the receiver's 'accessorStem'."

	^#dwordAtOffset:put:!

printMutatorValueOn: aWriteStream parameter: aString
	"Private - Print a suitable expression onto the specified <puttableStream> which will
	evaluate to the the value to be stored into this field in an instance of the structure when
	compiled into a mutator method where the value parameter is named by the <String> argument."

	aWriteStream
		nextPutAll: aString;
		space;
		display: #asParameter!

readFrom: anExternalStructure
	"Private - Answer a <Boolean> of equivalent value to the 32-bit integer field at the
	receiver's offset in the <ExternalStructure> argument, i.e. false if zero, true for any
	other value."

	^(anExternalStructure bytes dwordAtOffset: offset) asBoolean!

valueType
	^Boolean!

writeInto: anExternalStructure value: anObject
	"Private - Write zero or non-zero to the BOOL field of the <ExternalStructure>,
	anExternalStructure, at the receiver's offset, depending on the value of the <integer> or
	<Boolean> argument, anObject."

	anExternalStructure bytes dwordAtOffset: offset put: anObject asParameter! !
!External.BOOLField categoriesFor: #accessorMessage!automatic generation!private! !
!External.BOOLField categoriesFor: #printMutatorValueOn:parameter:!automatic generation!development!private! !
!External.BOOLField categoriesFor: #readFrom:!indirect accessing!private! !
!External.BOOLField categoriesFor: #valueType!automatic generation!constants!development!private! !
!External.BOOLField categoriesFor: #writeInto:value:!indirect accessing!private! !

