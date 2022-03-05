"Filed out from Dolphin Smalltalk"!

XMLNode subclass: #XMLStringNode
	instanceVariableNames: 'string'
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
XMLStringNode guid: (GUID fromString: '{456e6e4a-5391-4dcb-8ecc-a504a9619b52}')!
XMLStringNode comment: ''!
!XMLStringNode categoriesForClass!XML-Parser! !
!XMLStringNode methodsFor!

characterData
	^self string!

isText
	^true!

printXMLOn: writer
	writer pcData: self string!

string
	^string ifNil: ['']!

string: aString
	string := aString! !
!XMLStringNode categoriesForMethods!
characterData!accessing!public! !
isText!public!testing! !
printXMLOn:!printing!public! !
string!accessing!public! !
string:!accessing!public! !
!

!XMLStringNode class methodsFor!

string: aString
	^self new string: aString! !
!XMLStringNode class categoriesForMethods!
string:!instance creation!public! !
!

