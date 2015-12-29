"Filed out from Dolphin Smalltalk X6.1"!

HtmlElement subclass: #HtmlInputField
	instanceVariableNames: 'name value size width maxLength border onKeyUp onKeyDown onKeyPress onChange onBlur onClick readOnly disabled accessKey tabIndex autocomplete onFocus title'
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
HtmlInputField guid: (GUID fromString: '{E2A92388-190B-46E8-B74B-EA1DD215100B}')!
HtmlInputField comment: ''!
!HtmlInputField categoriesForClass!Unclassified! !
!HtmlInputField methodsFor!

accessKey: aString 
	accessKey := aString!

alignRight
	self cssStyleAdd: 'text-align:right'!

autocomplete
	^autocomplete!

autocomplete: aBoolean 
	autocomplete := aBoolean!

border: anInteger 
	border := anInteger!

disabled: aBoolean 
	disabled := aBoolean!

maxLength: aStringOrNumber 
	aStringOrNumber isString 
		ifTrue: [maxLength := aStringOrNumber]
		ifFalse: [maxLength := aStringOrNumber printString]!

name
	^name!

name: aStringOrSymbol 
	name := aStringOrSymbol!

onBlur: aString 
	onBlur := aString!

onChange: aString 
	onChange := aString!

onClick: aString 
	onClick := aString!

onFocus: aString 
	onFocus := aString!

onKeyDown: aString 
	onKeyDown := aString!

onKeyPress: aString 
	onKeyPress := aString!

onKeyUp: aString 
	onKeyUp := aString!

readOnly: aBoolean 
	readOnly := aBoolean!

size: aStringOrNumber 
	| val request |
	val := aStringOrNumber isString ifTrue: [aStringOrNumber itcAsInteger] ifFalse: [aStringOrNumber].
	(request := self webRequest) isNil 
		ifFalse: 
			["Define factors that will set correct size based on browsers."
			(request isInternetExplorer and: [request isOpera not]) 
				ifTrue: 
					[val := (val * 0.85s) rounded.
					val := val + (val // 13 * 2)]
				ifFalse: 
					[(request isAppleSafari or: [request isOpera]) 
						ifTrue: 
							[val := (val * 1.15s) rounded.
							val < 6 
								ifTrue: [val := val + 3]
								ifFalse: [val < 10 ifTrue: [val := val + 1] ifFalse: [val := val - (val // 13 * 2)]]]]].
	size := val printString!

tabIndex: anInteger 
	tabIndex := anInteger!

title: aString 
	title := aString!

value
	^value!

value: anObject 
	value := anObject!

valueFrom: aDictionary 
	aDictionary isNil 
		ifTrue: 
			[value := ''.
			^self].
	value := (aDictionary class == Dictionary 
				or: [aDictionary class == LookupTable or: [aDictionary class == ItcLookupTable]]) 
					ifTrue: 
						[aDictionary at: name
							ifAbsent: [aDictionary at: name asSymbol ifAbsent: [aDictionary at: name asString ifAbsent: []]]]
					ifFalse: [(aDictionary respondsTo: name asSymbol) ifTrue: [aDictionary perform: name asSymbol]].
	value isInteger ifTrue: [value := value printString]!

width: aStringOrNumber 
	aStringOrNumber isString 
		ifTrue: [width := aStringOrNumber]
		ifFalse: [width := aStringOrNumber printString]! !
!HtmlInputField categoriesFor: #accessKey:!public! !
!HtmlInputField categoriesFor: #alignRight!public! !
!HtmlInputField categoriesFor: #autocomplete!public! !
!HtmlInputField categoriesFor: #autocomplete:!public! !
!HtmlInputField categoriesFor: #border:!public! !
!HtmlInputField categoriesFor: #disabled:!public! !
!HtmlInputField categoriesFor: #maxLength:!public! !
!HtmlInputField categoriesFor: #name!public! !
!HtmlInputField categoriesFor: #name:!public! !
!HtmlInputField categoriesFor: #onBlur:!public! !
!HtmlInputField categoriesFor: #onChange:!public! !
!HtmlInputField categoriesFor: #onClick:!public! !
!HtmlInputField categoriesFor: #onFocus:!public! !
!HtmlInputField categoriesFor: #onKeyDown:!public! !
!HtmlInputField categoriesFor: #onKeyPress:!public! !
!HtmlInputField categoriesFor: #onKeyUp:!public! !
!HtmlInputField categoriesFor: #readOnly:!public! !
!HtmlInputField categoriesFor: #size:!public! !
!HtmlInputField categoriesFor: #tabIndex:!public! !
!HtmlInputField categoriesFor: #title:!public! !
!HtmlInputField categoriesFor: #value!public! !
!HtmlInputField categoriesFor: #value:!public! !
!HtmlInputField categoriesFor: #valueFrom:!public! !
!HtmlInputField categoriesFor: #width:!public! !

!HtmlInputField class methodsFor!

name: aStringOrSymbol

	^self new name: aStringOrSymbol!

name: aStringOrSymbol value: anObject

	^self new name: aStringOrSymbol; value: anObject!

name: aStringOrSymbol valueFrom: aDictionary

	^self new name: aStringOrSymbol; valueFrom: aDictionary! !
!HtmlInputField class categoriesFor: #name:!public! !
!HtmlInputField class categoriesFor: #name:value:!public! !
!HtmlInputField class categoriesFor: #name:valueFrom:!public! !

