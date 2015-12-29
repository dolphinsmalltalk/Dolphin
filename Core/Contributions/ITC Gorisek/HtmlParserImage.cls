"Filed out from Dolphin Smalltalk X6.2"!

HtmlParserElement subclass: #HtmlParserImage
	instanceVariableNames: 'fileName width height toolTip'
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
HtmlParserImage guid: (GUID fromString: '{DCF11741-4DE6-4D8A-979E-AB7451ED0C55}')!
HtmlParserImage comment: ''!
!HtmlParserImage categoriesForClass!Unclassified! !
!HtmlParserImage methodsFor!

fileName
	^fileName!

fileName: anObject
	fileName := anObject!

height
	^height!

height: anObject
	height := anObject!

parseFrom: tagAttributesString 
	| stream assoc |
	stream := HtmlParserReadStream new on: (ReadStream on: tagAttributesString).
	[(assoc := stream nextAttributeAndValue) isNil] whileFalse: 
			[assoc key = 'SRC' ifTrue: [fileName := assoc value].
			assoc key = 'HEIGHT' ifTrue: [height := assoc value].
			assoc key = 'WIDTH' ifTrue: [width := assoc value].
			assoc key = 'ALT' ifTrue: [toolTip := assoc value]]!

printOn: aStream 
	aStream nextPutAll: '<IMG ' , fileName asWebString , '>'!

toolTip
	^toolTip!

toolTip: anObject
	toolTip := anObject!

widht
	^width!

widht: anObject 
	width := anObject! !
!HtmlParserImage categoriesFor: #fileName!accessing!private! !
!HtmlParserImage categoriesFor: #fileName:!accessing!private! !
!HtmlParserImage categoriesFor: #height!accessing!private! !
!HtmlParserImage categoriesFor: #height:!accessing!private! !
!HtmlParserImage categoriesFor: #parseFrom:!accessing!private! !
!HtmlParserImage categoriesFor: #printOn:!accessing!private! !
!HtmlParserImage categoriesFor: #toolTip!accessing!private! !
!HtmlParserImage categoriesFor: #toolTip:!accessing!private! !
!HtmlParserImage categoriesFor: #widht!accessing!private! !
!HtmlParserImage categoriesFor: #widht:!accessing!private! !

