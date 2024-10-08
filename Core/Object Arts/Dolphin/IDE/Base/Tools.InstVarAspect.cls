﻿"Filed out from Dolphin Smalltalk"!

Tools.KeyedAspect
	subclass: #'Tools.InstVarAspect'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!

Tools.InstVarAspect guid: (Core.GUID fromString: '{c92cbde8-f3b1-4799-9a70-0f2b15a024fc}')!

Tools.InstVarAspect comment: ''!

!Tools.InstVarAspect categoriesForClass!Attribute-Definition! !

!Tools.InstVarAspect methodsFor!

batchSize
	"Answers the batch size of the receiver, i.e. the number of keyed elements to return at a time"

	^200!

canWriteInto: anObject
	^self key ~= 0 and: [super canWriteInto: anObject]!

displayAspectNameOf: anObject on: aStream 
	self key == 0 
		ifTrue: [aStream nextPutAll: 'self']
		ifFalse: [aStream display: (self instVarName: anObject)]!

displayAspectText: anObject on: aStream
	self key == 0
		ifFalse: 
			[aStream
				display: (self instVarName: anObject);
				nextPut: $=].
	[(self readFrom: anObject) aspectDisplayOn: aStream] on: Error do: [:ex | ex displayOn: aStream]!

instVarName: anObject
	"Answer the name of the instance variable described by the receiver in the 
	specified <Object>."

	| fixedSize index |
	(index := self key) = 0 ifTrue: [^#self].
	fixedSize := anObject class instSize.
	^index <= fixedSize ifTrue: [anObject class instVarName: index] ifFalse: [index - fixedSize]!

nameIn: anObject
	"Private - Answer the 'name' of the aspect of the <Object> argument described by the receiver."

	^self instVarName: anObject!

objectRefName: anObject
	| index stream |
	index := self key.
	stream := String writeStream.
	index > anObject class instSize 
		ifTrue: [stream nextPutAll: (anObject basicPrintString copyWithout: Character space)].
	stream display: (self instVarName: anObject).
	^stream contents!

readFrom: anObject
	^self key = 0 ifTrue: [anObject] ifFalse: [anObject instVarAt: self key]!

selectIn: anInspector
	anInspector selectAspect: self!

writeInto: subjectObject value: valueObject
	"Private - Set the attribute of subjectObject described by the receiver 
	to valueObject."

	^subjectObject instVarAt: self key put: valueObject! !

!Tools.InstVarAspect categoriesForMethods!
batchSize!constants!public! !
canWriteInto:!private!testing! !
displayAspectNameOf:on:!displaying!private! !
displayAspectText:on:!displaying!private! !
instVarName:!accessing!public! !
nameIn:!accessing!private! !
objectRefName:!helpers!private! !
readFrom:!indirect accessing!private! !
selectIn:!event handling!private! !
writeInto:value:!indirect accessing!private! !
!

