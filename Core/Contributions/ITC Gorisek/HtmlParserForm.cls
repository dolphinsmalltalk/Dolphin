"Filed out from Dolphin Smalltalk X6.2"!

HtmlParserElement subclass: #HtmlParserForm
	instanceVariableNames: 'formFields name target action method'
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
HtmlParserForm guid: (GUID fromString: '{C07AB3E1-D20E-4855-8E56-FE1CE13B4B5A}')!
HtmlParserForm comment: ''!
!HtmlParserForm categoriesForClass!Unclassified! !
!HtmlParserForm methodsFor!

action
	^action!

action: anObject
	action := anObject!

formFields
	^formFields!

name
	^name!

parseFrom: htmlParserStream attributes: attributes 
	| stream assoc token fieldName fieldValue |
	stream := HtmlParserReadStream new on: (ReadStream on: attributes).
	formFields := LookupTable new.
	[(assoc := stream nextAttributeAndValue) isNil] whileFalse: 
			[assoc key = 'ACTION' ifTrue: [action := assoc value].
			assoc key = 'TARGET' ifTrue: [target := assoc value].
			assoc key = 'NAME' ifTrue: [name := assoc value].
			assoc key = 'METHOD' ifTrue: [method := assoc value]].
	token := htmlParserStream nextToken.
	[token isNil] whileFalse: 
			[token isString 
				ifTrue: [token := htmlParserStream nextToken]
				ifFalse: 
					[token first = 'FORM' ifTrue: [^self].
					(token first = 'INPUT' and: [token last == false]) 
						ifTrue: 
							["parse tag contents for field name and value"
							stream := HtmlParserReadStream new on: (ReadStream on: (token at: 2)).
							fieldName := nil.
							fieldValue := nil.
							[(assoc := stream nextAttributeAndValue) isNil] whileFalse: 
									[assoc key = 'NAME' ifTrue: [fieldName := assoc value].
									assoc key = 'VALUE' ifTrue: [fieldValue := assoc value]].
							fieldName isNil ifFalse: [formFields at: fieldName put: fieldValue].
							token := htmlParserStream nextToken]
						ifFalse: 
							[(token first = 'SELECT' and: [token last == false]) 
								ifTrue: 
									["parse tag contents for field name"
									stream := HtmlParserReadStream new on: (ReadStream on: (token at: 2)).
									fieldName := nil.
									fieldValue := nil.
									[(assoc := stream nextAttributeAndValue) isNil] 
										whileFalse: [assoc key = 'NAME' ifTrue: [fieldName := assoc value]].
									fieldName isNil ifFalse: [formFields at: fieldName put: fieldValue].
									
									[token := htmlParserStream nextToken.
									token isNil or: [token first = 'SELECT' and: [token last = true]]] 
											whileFalse: []]
								ifFalse: [token := htmlParserStream nextToken]]]]!

printOn: aStream 
	aStream nextPutAll: '<FORM'.
	name isNilOrEmpty ifFalse: [aStream nextPutAll: ' NAME="' , name , '"'].
	action isNilOrEmpty ifFalse: [aStream nextPutAll: ' ACTION="' , action , '"'].
	target isNilOrEmpty ifFalse: [aStream nextPutAll: ' TARGET="' , target , '"'].
	method isNilOrEmpty ifFalse: [aStream nextPutAll: ' METHOD="' , method , '"'].
	aStream
		nextPutAll: '>';
		cr.
	formFields keysAndValuesDo: 
			[:eachKey :eachValue | 
			aStream
				nextPutAll: eachKey , '=' , eachValue asWebString;
				cr]! !
!HtmlParserForm categoriesFor: #action!accessing!private! !
!HtmlParserForm categoriesFor: #action:!accessing!private! !
!HtmlParserForm categoriesFor: #formFields!public! !
!HtmlParserForm categoriesFor: #name!public! !
!HtmlParserForm categoriesFor: #parseFrom:attributes:!public! !
!HtmlParserForm categoriesFor: #printOn:!public! !

