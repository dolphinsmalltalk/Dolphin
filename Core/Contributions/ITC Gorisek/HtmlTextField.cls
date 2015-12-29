"Filed out from Dolphin Smalltalk X6.1"!

HtmlInputField subclass: #HtmlTextField
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
HtmlTextField guid: (GUID fromString: '{FE6B845A-04D0-4816-A281-A6ADE26F64BE}')!
HtmlTextField comment: ''!
!HtmlTextField categoriesForClass!Unclassified! !
!HtmlTextField methodsFor!

generateOn: aStream 
	aStream nextPutAll: '<input type="text"'.
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
	size isNil 
		ifFalse: 
			[aStream
				nextPutAll: ' size="';
				nextPutAll: size;
				nextPut: $"].
	width isNil 
		ifFalse: 
			[aStream
				nextPutAll: ' width="';
				nextPutAll: width;
				nextPut: $"].
	title isNil 
		ifFalse: 
			[aStream
				nextPutAll: ' title="';
				nextPutAll: title;
				nextPut: $"].
	disabled = true 
		ifTrue: 
			[aStream nextPutAll: ' disabled="disabled"'.
			cssStyle := 'background:#e0e0e0' add: cssStyle withDelimiter: ';'].
	cssStyle isNil 
		ifFalse: 
			[aStream
				nextPutAll: ' style="';
				nextPutAll: cssStyle;
				nextPut: $"].
	value isNil 
		ifFalse: 
			[aStream
				nextPutAll: ' value="';
				nextPutAll: (value isString ifTrue: [value webHtmlEncodedForForm] ifFalse: [value asWebString]);
				nextPut: $"].
	maxLength isNil 
		ifFalse: 
			[aStream
				nextPutAll: ' maxlength="';
				nextPutAll: maxLength;
				nextPut: $"].
	onKeyDown isNil 
		ifFalse: 
			[aStream
				nextPutAll: ' onkeydown="';
				nextPutAll: onKeyDown;
				nextPutAll: '"'].
	onFocus isNil 
		ifFalse: 
			[aStream
				nextPutAll: ' onfocus="';
				nextPutAll: onFocus;
				nextPutAll: '"'].
	onKeyUp isNil 
		ifFalse: 
			[aStream
				nextPutAll: ' onkeyup="';
				nextPutAll: onKeyUp;
				nextPut: $"].
	onKeyPress isNil 
		ifFalse: 
			[aStream
				nextPutAll: ' onkeypress="';
				nextPutAll: onKeyPress;
				nextPut: $"].
	onBlur isNil 
		ifFalse: 
			[aStream
				nextPutAll: ' onblur="';
				nextPutAll: onBlur;
				nextPut: $"].
	onChange isNil 
		ifFalse: 
			[aStream
				nextPutAll: ' onchange="';
				nextPutAll: onChange;
				nextPut: $"].
	tabIndex isNil 
		ifFalse: 
			[aStream
				nextPutAll: ' tabindex="';
				nextPutAll: tabIndex asWebString;
				nextPut: $"].
	accessKey isNil 
		ifFalse: 
			[aStream
				nextPutAll: ' accesskey="';
				nextPutAll: accessKey asWebString;
				nextPut: $"].
	autocomplete == false ifTrue: [aStream nextPutAll: ' autocomplete="off"'].
	readOnly = true ifTrue: [aStream nextPutAll: ' readonly="readonly"'].
	aStream nextPutAll: ' />'! !
!HtmlTextField categoriesFor: #generateOn:!public! !

