"Filed out from Dolphin Smalltalk X6"!

SmalltalkStyler subclass: #SmalltalkMethodStyler
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
SmalltalkMethodStyler guid: (GUID fromString: '{B4E52620-CC73-45AD-8F07-20A71BB2E287}')!
SmalltalkMethodStyler comment: 'SmalltalkMethodStyler is a <SmalltalkStyler> specialised to colour method definitions. It differs in recognising the method signature, which is not itself a valid Smalltalk expression.'!
!SmalltalkMethodStyler categoriesForClass!Kernel-Objects! !
!SmalltalkMethodStyler methodsFor!

initialBinaryStyle: aStBinarySelectorToken 
	^#binarySelector!

initialKeywordStyle
	^#keywordSelector!

initialLiteralStyle: aStLiteralToken 
	| style |
	style := aStLiteralToken value literalTextStyle.
	^style == #literalPseudo ifTrue: [#unarySelector] ifFalse: [style]!

initialUnaryStyle
	^#unarySelector! !
!SmalltalkMethodStyler categoriesFor: #initialBinaryStyle:!constants!private! !
!SmalltalkMethodStyler categoriesFor: #initialKeywordStyle!constants!private! !
!SmalltalkMethodStyler categoriesFor: #initialLiteralStyle:!helpers!private! !
!SmalltalkMethodStyler categoriesFor: #initialUnaryStyle!constants!private! !

