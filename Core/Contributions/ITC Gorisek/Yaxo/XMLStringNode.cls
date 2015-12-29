"Filed out from Dolphin Smalltalk X6.2"!

XMLNode subclass: #XMLStringNode
	instanceVariableNames: 'string'
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
XMLStringNode guid: (GUID fromString: '{456E6E4A-5391-4DCB-8ECC-A504A9619B52}')!
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

