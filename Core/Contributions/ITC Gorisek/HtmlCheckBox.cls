"Filed out from Dolphin Smalltalk X6.1"!

HtmlInputField subclass: #HtmlCheckBox
	instanceVariableNames: 'checked'
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
HtmlCheckBox guid: (GUID fromString: '{F650D443-1606-4259-A9C5-DF15A2B189BA}')!
HtmlCheckBox comment: ''!
!HtmlCheckBox categoriesForClass!Unclassified! !
!HtmlCheckBox methodsFor!

checked: aBoolean 
	aBoolean isInteger ifTrue: [checked := aBoolean = 1] ifFalse: [checked := aBoolean]!

generateOn: aStream 
	aStream nextPutAll: '<input type="checkbox"'.
	checked = true ifTrue: [aStream nextPutAll: ' checked="checked"'].
	aStream
		nextPutAll: ' name="';
		nextPutAll: name;
		nextPutAll: '" id="';
		nextPutAll: name;
		nextPutAll: '" value="';
		nextPutAll: value asWebString;
		nextPut: $".
	readOnly = true ifTrue: [aStream nextPutAll: ' readonly="readonly"'].
	disabled = true ifTrue: [aStream nextPutAll: ' disabled="disabled"'].
	title isNil 
		ifFalse: 
			[aStream
				nextPutAll: ' title="';
				nextPutAll: title;
				nextPut: $"].
	cssClass isNil 
		ifFalse: 
			[aStream
				nextPutAll: ' class="';
				nextPutAll: cssClass;
				nextPut: $"].
	cssStyle isNil 
		ifFalse: 
			[aStream
				nextPutAll: ' style="';
				nextPutAll: cssStyle;
				nextPut: $"].
	onClick isNil 
		ifFalse: 
			[aStream
				nextPutAll: ' onclick="';
				nextPutAll: onClick;
				nextPut: $"].
	onChange isNil 
		ifFalse: 
			[aStream
				nextPutAll: ' onchange="';
				nextPutAll: onChange;
				nextPut: $"].
	aStream nextPutAll: '/>'!

valueFrom: aDictionary 
	| val |
	value := 'true'.
	val := aDictionary at: name ifAbsent: [].
	checked := val = true or: [val = 'true']! !
!HtmlCheckBox categoriesFor: #checked:!public! !
!HtmlCheckBox categoriesFor: #generateOn:!public! !
!HtmlCheckBox categoriesFor: #valueFrom:!public! !

!HtmlCheckBox class methodsFor!

name: fieldName value: value checked: aBoolean 
	| field |
	field := self name: fieldName value: value.
	field checked: aBoolean.
	^field!

name: fieldName value: value checked: aBoolean onClick: onClick 
	| field |
	field := self 
				name: fieldName
				value: value
				checked: aBoolean.
	field onClick: onClick.
	^field! !
!HtmlCheckBox class categoriesFor: #name:value:checked:!public! !
!HtmlCheckBox class categoriesFor: #name:value:checked:onClick:!public! !

