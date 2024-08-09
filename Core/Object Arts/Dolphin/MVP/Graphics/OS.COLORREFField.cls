"Filed out from Dolphin Smalltalk"!

External.UInt32Field
	subclass: #'OS.COLORREFField'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!

OS.COLORREFField guid: (Core.GUID fromString: '{f39a53df-c864-4753-a8c9-709c195d1680}')!

OS.COLORREFField comment: ''!

!OS.COLORREFField methodsFor!

readFrom: anExternalStructure
	"Private - Answer a <Color> equivalent to the COLORREF field at the receiver's offset in the <ExternalStructure> argument."

	^Graphics.Color fromCOLORREF: (super readFrom: anExternalStructure)!

valueType
	^Graphics.Color!

writeInto: anExternalStructure value: aColor
	"Private - Write the COLORREF representation of the <Color> 2nd argument into the <ExternalStructure> first argument."

	^super writeInto: anExternalStructure value: aColor asCOLORREF! !

!OS.COLORREFField categoriesForMethods!
readFrom:!indirect accessing!private! !
valueType!automatic generation!constants!development!private! !
writeInto:value:!indirect accessing!private! !
!

