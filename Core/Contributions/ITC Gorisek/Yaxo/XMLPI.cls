"Filed out from Dolphin Smalltalk"!

XMLNode subclass: #XMLPI
	instanceVariableNames: 'target data'
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!

XMLPI guid: (GUID fromString: '{2a41e7a7-e44c-4134-9472-1e0ae3fa1c9c}')!

XMLPI comment: ''!

!XMLPI categoriesForClass!XML-Parser! !

!XMLPI methodsFor!

data
	^data!

data: aString
	data := aString!

isProcessingInstruction
	^true!

name
	#swYAXO.
	^target!

printXMLOn: writer
	writer pi: self target data: self data!

target
	^target!

target: aString
	target := aString! !

!XMLPI categoriesForMethods!
data!accessing!public! !
data:!accessing!public! !
isProcessingInstruction!public!testing! !
name!accessing!public! !
printXMLOn:!printing!public! !
target!accessing!public! !
target:!accessing!public! !
!

!XMLPI class methodsFor!

target: targetName data: aString
	^self new
		target: targetName;
		data: aString! !

!XMLPI class categoriesForMethods!
target:data:!instance creation!public! !
!

