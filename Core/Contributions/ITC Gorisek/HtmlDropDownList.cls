"Filed out from Dolphin Smalltalk X6.1"!

HtmlInputField subclass: #HtmlDropDownList
	instanceVariableNames: 'items displaySelector valueSelector automatic listSize'
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
HtmlDropDownList guid: (GUID fromString: '{CCE73143-00C1-4154-8803-C75A6A73F3A6}')!
HtmlDropDownList comment: ''!
!HtmlDropDownList categoriesForClass!Unclassified! !
!HtmlDropDownList methodsFor!

automatic: aBoolean 
	automatic := aBoolean!

displaySelector: aSymbol 
	displaySelector := aSymbol!

generateOn: aStream 
	| option skipCr |
	skipCr := ItcSystemManager isRuntime.
	aStream
		nextPutAll: '<span id="' , name , '_div"><select name="';
		nextPutAll: name;
		nextPutAll: '"'.
	elementId isNil 
		ifFalse: 
			[aStream
				nextPutAll: ' id="';
				nextPutAll: elementId asString;
				nextPut: $"].
	listSize isNil 
		ifFalse: 
			[aStream
				nextPutAll: ' size="';
				nextPutAll: listSize printString;
				nextPutAll: '"'].
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
	automatic == true ifTrue: [aStream nextPutAll: ' onchange="form.submit();"'].
	onChange isNil 
		ifFalse: 
			[aStream
				nextPutAll: ' onchange="';
				nextPutAll: onChange;
				nextPut: $"].
	disabled = true ifTrue: [aStream nextPutAll: ' disabled="disabled"'].
	width isNil 
		ifFalse: [cssStyle := cssStyle add: 'width:' , width asWebString , 'px;' withDelimiter: ';'].
	cssStyle isNil 
		ifFalse: 
			[aStream
				nextPutAll: ' style="';
				nextPutAll: cssStyle;
				nextPut: $"].
	aStream nextPut: $>.
	value isSymbol ifTrue: [value := value asString].
	items do: 
			[:each | 
			skipCr ifFalse: [aStream cr].
			each isNil 
				ifTrue: 
					[aStream nextPutAll: '<option>'.
					size notNil ifTrue: [size timesRepeat: [aStream nextPutAll: '&nbsp;']].
					aStream nextPutAll: '</option>']
				ifFalse: 
					[option := self class getOptionValueFor: each valueSelector: valueSelector.
					aStream
						nextPutAll: '<option value="';
						nextPutAll: option.
					(option = value or: [each == value or: [value isString not and: [option = value asWebString]]]) 
						ifTrue: [aStream nextPutAll: '" selected="selected'].
					aStream
						nextPutAll: '">';
						nextPutAll: (self class getOptionDisplayStringFor: each displaySelector: displaySelector) 
									webHtmlEncodedForForm;
						nextPutAll: '</option>']].
	aStream nextPutAll: '</select></span>'!

items: aCollection 
	items := aCollection!

itemsWithNil: aCollection 
	items := (aCollection includes: nil) 
				ifTrue: [items]
				ifFalse: [(OrderedCollection with: nil) , aCollection]!

listSize: anInteger 
	listSize := anInteger!

size: anInteger 
	size := anInteger!

valueSelector: aSymbol 
	valueSelector := aSymbol! !
!HtmlDropDownList categoriesFor: #automatic:!public! !
!HtmlDropDownList categoriesFor: #displaySelector:!public! !
!HtmlDropDownList categoriesFor: #generateOn:!public! !
!HtmlDropDownList categoriesFor: #items:!public! !
!HtmlDropDownList categoriesFor: #itemsWithNil:!public! !
!HtmlDropDownList categoriesFor: #listSize:!public! !
!HtmlDropDownList categoriesFor: #size:!public! !
!HtmlDropDownList categoriesFor: #valueSelector:!public! !

!HtmlDropDownList class methodsFor!

getOptionDisplayStringFor: item displaySelector: displaySelector 
	^displaySelector isNil 
		ifTrue: [item asWebString]
		ifFalse: [(item perform: displaySelector) asWebString]!

getOptionValueFor: item valueSelector: valueSelector 
	^valueSelector isNil ifTrue: [item asWebString] ifFalse: [(item perform: valueSelector) asWebString]! !
!HtmlDropDownList class categoriesFor: #getOptionDisplayStringFor:displaySelector:!public! !
!HtmlDropDownList class categoriesFor: #getOptionValueFor:valueSelector:!public! !

