﻿"Filed out from Dolphin Smalltalk"!

External.ScalarField
	subclass: #'External.BOOLField'
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

	^#uint32AtOffset:put:!

readFrom: anExternalStructure
	"Private - Answer a <Boolean> of equivalent value to the 32-bit integer field at the
	receiver's offset in the <ExternalStructure> argument, i.e. false if zero, true for any
	other value."

	^(anExternalStructure bytes uint32AtOffset: offset) asBoolean!

valueType
	^Boolean!

writeInto: anExternalStructure value: anObject
	"Private - Write zero or non-zero to the BOOL field of the <ExternalStructure>,
	anExternalStructure, at the receiver's offset, depending on the value of the <integer> or
	<Boolean> argument, anObject."

	anExternalStructure bytes uint32AtOffset: offset put: anObject asParameter! !

!External.BOOLField categoriesForMethods!
accessorMessage!automatic generation!private! !
readFrom:!indirect accessing!private! !
valueType!automatic generation!constants!development!private! !
writeInto:value:!indirect accessing!private! !
!

