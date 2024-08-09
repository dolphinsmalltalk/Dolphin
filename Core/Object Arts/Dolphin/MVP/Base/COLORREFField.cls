"Filed out from Dolphin Smalltalk"!

DWORDField subclass: #COLORREFField
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!

COLORREFField guid: (GUID fromString: '{f39a53df-c864-4753-a8c9-709c195d1680}')!

COLORREFField comment: ''!

!COLORREFField categoriesForClass!Unclassified! !

!COLORREFField methodsFor!

readFrom: anExternalStructure
	"Private - Answer a <Color> equivalent to the COLORREF field at the receiver's offset in the <ExternalStructure> argument."

	^Color fromCOLORREF: (super readFrom: anExternalStructure)!

valueType
	^Color!

writeInto: anExternalStructure value: aColor
	"Private - Write the COLORREF representation of the <Color> 2nd argument into the <ExternalStructure> first argument."

	^super writeInto: anExternalStructure value: aColor asCOLORREF! !

!COLORREFField categoriesForMethods!
readFrom:!indirect accessing!private! !
valueType!automatic generation!constants!development!private! !
writeInto:value:!indirect accessing!private! !
!

