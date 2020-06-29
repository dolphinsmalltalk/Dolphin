"Filed out from Dolphin Smalltalk 7"!

XMLNode subclass: #XMLStringNode
	instanceVariableNames: 'string'
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''
	classConstants: {}!
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
!XMLStringNode categoriesFor: #characterData!accessing!public! !
!XMLStringNode categoriesFor: #isText!public!testing! !
!XMLStringNode categoriesFor: #printXMLOn:!printing!public! !
!XMLStringNode categoriesFor: #string!accessing!public! !
!XMLStringNode categoriesFor: #string:!accessing!public! !

!XMLStringNode class methodsFor!

string: aString
	^self new string: aString! !
!XMLStringNode class categoriesFor: #string:!instance creation!public! !

