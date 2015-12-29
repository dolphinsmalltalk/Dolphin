"Filed out from Dolphin Smalltalk X6.1"!

HtmlInputField subclass: #HtmlDateField
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
HtmlDateField guid: (GUID fromString: '{1FD312F2-3F25-4EA4-81C7-E2236B263C7C}')!
HtmlDateField comment: ''!
!HtmlDateField categoriesForClass!Unclassified! !
!HtmlDateField methodsFor!

generateOn: aStream 
	aStream nextPutAll: '<input type="text" maxlength="10"'.
	elementId isNil 
		ifFalse: 
			[aStream
				nextPutAll: ' id="';
				nextPutAll: elementId asString;
				nextPut: $"].
	name isNil 
		ifFalse: 
			[aStream
				nextPutAll: ' name="';
				nextPutAll: name asString;
				nextPut: $"].
	width isNil 
		ifFalse: 
			[aStream
				nextPutAll: ' width="';
				nextPutAll: width;
				nextPutAll: '"'].
	disabled = true ifTrue: [aStream nextPutAll: ' disabled="disabled" style="background:#e0e0e0;"'].
	size isNil ifTrue: [self size: 8].
	aStream
		nextPutAll: ' size="';
		nextPutAll: size;
		nextPutAll: '"'.
	value notNil 
		ifTrue: 
			[aStream
				nextPutAll: ' value="';
				nextPutAll: value asWebString;
				nextPut: $"].
	tabIndex isNil 
		ifFalse: 
			[aStream
				nextPutAll: ' tabindex=';
				nextPutAll: tabIndex asWebString].
	autocomplete == false ifTrue: [aStream nextPutAll: ' autocomplete="off"'].
	onKeyDown isNil 
		ifFalse: 
			[aStream
				nextPutAll: ' onkeydown="';
				nextPutAll: onKeyDown;
				nextPutAll: '"'].
	onKeyUp isNil 
		ifFalse: 
			[aStream
				nextPutAll: ' onkeyup="';
				nextPutAll: onKeyUp;
				nextPutAll: '"'].
	onKeyPress isNil 
		ifFalse: 
			[aStream
				nextPutAll: ' onkeypress="';
				nextPutAll: onKeyPress;
				nextPutAll: '"'].
	onBlur isNil 
		ifFalse: 
			[aStream
				nextPutAll: ' onblur="';
				nextPutAll: onBlur;
				nextPutAll: '"'].
	onChange isNil 
		ifFalse: 
			[aStream
				nextPutAll: ' onchange="';
				nextPutAll: onChange;
				nextPutAll: '"'].
	aStream nextPutAll: '/>'! !
!HtmlDateField categoriesFor: #generateOn:!public! !

