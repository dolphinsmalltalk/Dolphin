"Filed out from Dolphin Smalltalk X6.1"!

HtmlContainer subclass: #HtmlLink
	instanceVariableNames: 'target attributes targetFrame javascript onClick linkTitle'
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
HtmlLink guid: (GUID fromString: '{B578E429-9A7A-4B84-96E6-61FD8494EC56}')!
HtmlLink comment: ''!
!HtmlLink categoriesForClass!Unclassified! !
!HtmlLink methodsFor!

addAttribute: aStringOrSymbol value: anObject

	| str |
	str := anObject isString ifTrue: [anObject] ifFalse: [anObject printString].
	attributes := attributes isNil
		ifTrue: [aStringOrSymbol,'=', str]
		ifFalse: [attributes, '&', aStringOrSymbol, '=', str].!

generateOn: aStream 
	aStream nextPutAll: '<a '.
	self cssClass isNil ifFalse: [aStream nextPutAll: 'class = "' , self cssClass , '" '].
	cssStyle notNil ifTrue: [aStream nextPutAll: 'style="' , cssStyle , '" '].
	targetFrame notNil ifTrue: [aStream nextPutAll: 'target="' , targetFrame , '"'].
	javascript notNil ifTrue: [aStream nextPutAll: javascript].
	aStream nextPutAll: ' href="'.
	target printWebUrlOn: aStream.
	attributes isNil 
		ifFalse: 
			[(target isString and: [target includes: $?]) 
				ifFalse: [aStream nextPut: $?]
				ifTrue: [aStream nextPut: $&].
			aStream nextPutAll: attributes].
	aStream nextPut: $".
	onClick notNil ifTrue: [aStream nextPutAll: ' onclick="' , onClick , '"'].
	linkTitle isNilOrEmpty 
		ifFalse: [aStream nextPutAll: ' title="' , linkTitle webHtmlEncodedForForm , '"'].
	aStream nextPut: $>.
	(self cssClass isNil and: [color notNil]) 
		ifTrue: [aStream nextPutAll: '<font color="' , color , '">'].
	super generateOn: aStream.
	(self cssClass isNil and: [color notNil]) ifTrue: [aStream nextPutAll: '</font>'].
	aStream nextPutAll: '</a>'!

javascript: aString

	javascript := aString!

linkTitle: string 
	linkTitle := string!

onClick: string

	onClick := string!

target: aWebServletClassOrString

	target := aWebServletClassOrString!

targetFrame: frameName

	targetFrame := frameName! !
!HtmlLink categoriesFor: #addAttribute:value:!public! !
!HtmlLink categoriesFor: #generateOn:!public! !
!HtmlLink categoriesFor: #javascript:!public! !
!HtmlLink categoriesFor: #linkTitle:!public! !
!HtmlLink categoriesFor: #onClick:!public! !
!HtmlLink categoriesFor: #target:!public! !
!HtmlLink categoriesFor: #targetFrame:!public! !

!HtmlLink class methodsFor!

on: aWebServletClassOrString

	^self new target: aWebServletClassOrString!

on: aWebServletClassOrString text: aString

	^self new
		target: aWebServletClassOrString;
		add: aString!

on: aWebServletClassOrString text: aString into: frameName

	^self new
		target: aWebServletClassOrString;
		targetFrame: frameName;
		add: aString! !
!HtmlLink class categoriesFor: #on:!public! !
!HtmlLink class categoriesFor: #on:text:!public! !
!HtmlLink class categoriesFor: #on:text:into:!public! !

