"Filed out from Dolphin Smalltalk X6.1"!

HtmlInputField subclass: #HtmlPasswordField
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
HtmlPasswordField guid: (GUID fromString: '{9585A9E0-AEBC-44AE-8440-FF8C2E97656E}')!
HtmlPasswordField comment: ''!
!HtmlPasswordField categoriesForClass!Unclassified! !
!HtmlPasswordField methodsFor!

generateOn: aStream 
	aStream nextPutAll: '<input type="password"'.
	name isNil 
		ifFalse: 
			[aStream
				nextPutAll: ' name="';
				nextPutAll: name asString;
				nextPutAll: '"'].
	size isNil 
		ifFalse: 
			[aStream
				nextPutAll: ' size="';
				nextPutAll: size;
				nextPutAll: '"'].
	width isNil 
		ifFalse: 
			[aStream
				nextPutAll: ' width="';
				nextPutAll: width;
				nextPutAll: '"'].
	value isNil 
		ifFalse: 
			[aStream
				nextPutAll: ' value="';
				nextPutAll: value;
				nextPutAll: '"'].
	maxLength isNil 
		ifFalse: 
			[aStream
				nextPutAll: ' maxLength="';
				nextPutAll: maxLength;
				nextPutAll: '"'].
	autocomplete == false ifTrue: [aStream nextPutAll: ' autocomplete="off"'].
	aStream nextPutAll: '/>'! !
!HtmlPasswordField categoriesFor: #generateOn:!public! !

