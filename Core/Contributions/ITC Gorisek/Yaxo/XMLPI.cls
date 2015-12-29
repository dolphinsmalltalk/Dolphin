"Filed out from Dolphin Smalltalk X6.2"!

XMLNode subclass: #XMLPI
	instanceVariableNames: 'target data'
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
XMLPI guid: (GUID fromString: '{2A41E7A7-E44C-4134-9472-1E0AE3FA1C9C}')!
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
!XMLPI categoriesFor: #data!accessing!public! !
!XMLPI categoriesFor: #data:!accessing!public! !
!XMLPI categoriesFor: #isProcessingInstruction!public!testing! !
!XMLPI categoriesFor: #name!accessing!public! !
!XMLPI categoriesFor: #printXMLOn:!printing!public! !
!XMLPI categoriesFor: #target!accessing!public! !
!XMLPI categoriesFor: #target:!accessing!public! !

!XMLPI class methodsFor!

target: targetName data: aString
	^self new
		target: targetName;
		data: aString! !
!XMLPI class categoriesFor: #target:data:!instance creation!public! !

