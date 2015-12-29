"Filed out from Dolphin Smalltalk X6.1"!

HtmlInputField subclass: #HtmlHiddenField
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
HtmlHiddenField guid: (GUID fromString: '{3E3B3BE6-2EED-4212-B3D9-AB97B4C09AA4}')!
HtmlHiddenField comment: ''!
!HtmlHiddenField categoriesForClass!Unclassified! !
!HtmlHiddenField methodsFor!

generateOn: aStream 
	aStream nextPutAll: '<input type="hidden"'.
	name isNil 
		ifFalse: 
			[aStream
				nextPutAll: ' name="';
				nextPutAll: name asString;
				nextPutAll: '"'].
	value isNil 
		ifFalse: 
			[aStream
				nextPutAll: ' value="';
				nextPutAll: (value isString 
							ifTrue: [value webHtmlEncodedForForm]
							ifFalse: [value asWebString]);
				nextPutAll: '"'].
	aStream nextPutAll: '/>'! !
!HtmlHiddenField categoriesFor: #generateOn:!public! !

