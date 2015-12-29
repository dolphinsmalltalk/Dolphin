"Filed out from Dolphin Smalltalk X6.1"!

HtmlInputField subclass: #HtmlTextArea
	instanceVariableNames: 'columns rows text'
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
HtmlTextArea guid: (GUID fromString: '{CAAB5FCC-4CED-4B05-B6A4-31368249182F}')!
HtmlTextArea comment: ''!
!HtmlTextArea categoriesForClass!Unclassified! !
!HtmlTextArea methodsFor!

columns: numberOfColumns rows: numberOfRows 
	columns := numberOfColumns isString 
				ifTrue: [numberOfColumns]
				ifFalse: [numberOfColumns printString].
	rows := numberOfRows isString ifTrue: [numberOfRows] ifFalse: [numberOfRows printString]!

generateOn: aStream 
	aStream nextPutAll: '<textarea '.
	name isNil 
		ifFalse: 
			[aStream
				nextPutAll: ' name="';
				nextPutAll: name asString;
				nextPut: $"].
	columns isNil 
		ifFalse: 
			[aStream
				nextPutAll: ' cols="';
				nextPutAll: columns;
				nextPut: $"].
	rows isNil 
		ifFalse: 
			[aStream
				nextPutAll: ' rows="';
				nextPutAll: rows;
				nextPut: $"].
	"TO DO: add max length support via Javascript since attribute maxLenght is not supported by textarea tag"
	"
	maxLength isNil 
		ifFalse: 
			[aStream
				nextPutAll: ' maxlength=';
				nextPutAll: maxLength;
				nextPut: $].
"
	cssStyle isNil 
		ifFalse: 
			[aStream
				nextPutAll: ' style="';
				nextPutAll: cssStyle;
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
	onKeyDown isNil 
		ifFalse: 
			[aStream
				nextPutAll: ' onkeydown="';
				nextPutAll: onKeyDown;
				nextPut: $"].
	aStream nextPut: $>.
	text isNil ifFalse: [aStream nextPutAll: text webHtmlEncodedForForm].
	aStream nextPutAll: '</textarea>'!

text: aText 
	text := aText! !
!HtmlTextArea categoriesFor: #columns:rows:!public! !
!HtmlTextArea categoriesFor: #generateOn:!public! !
!HtmlTextArea categoriesFor: #text:!public! !

