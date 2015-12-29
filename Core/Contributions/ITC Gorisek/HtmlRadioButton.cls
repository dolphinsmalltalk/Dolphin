"Filed out from Dolphin Smalltalk X6.1"!

HtmlInputField subclass: #HtmlRadioButton
	instanceVariableNames: 'checked'
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
HtmlRadioButton guid: (GUID fromString: '{A2BFD6D6-FBBE-4B63-91E0-E5142D3579F9}')!
HtmlRadioButton comment: ''!
!HtmlRadioButton categoriesForClass!Unclassified! !
!HtmlRadioButton methodsFor!

checked: boolean 
	checked := boolean!

generateOn: aStream 
	aStream nextPutAll: '<input type="radio"'.
	checked = true ifTrue: [aStream nextPutAll: ' checked="checked"'].
	disabled = true ifTrue: [aStream nextPutAll: ' disabled="disabled"'].
	onClick isNil 
		ifFalse: 
			[aStream
				nextPutAll: ' onclick="';
				nextPutAll: onClick;
				nextPutAll: '"'].
	onChange isNil 
		ifFalse: 
			[aStream
				nextPutAll: ' onchange="';
				nextPutAll: onChange;
				nextPutAll: '"'].
	onKeyPress isNil 
		ifFalse: 
			[aStream
				nextPutAll: ' onkeypress="';
				nextPutAll: onKeyPress;
				nextPutAll: '"'].
	aStream
		nextPutAll: ' name="';
		nextPutAll: name;
		nextPutAll: '" value="';
		nextPutAll: value asWebString;
		nextPutAll: '"/>'! !
!HtmlRadioButton categoriesFor: #checked:!public! !
!HtmlRadioButton categoriesFor: #generateOn:!public! !

!HtmlRadioButton class methodsFor!

checked: boolean

	^self new
		checked: boolean!

name: aString value: value checked: boolean

	^self new
		name: aString;
		value: value;
		checked: boolean! !
!HtmlRadioButton class categoriesFor: #checked:!public! !
!HtmlRadioButton class categoriesFor: #name:value:checked:!public! !

