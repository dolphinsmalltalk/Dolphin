"Filed out from Dolphin Smalltalk"!

SmalltalkStyler subclass: #SmalltalkMethodStyler
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
SmalltalkMethodStyler guid: (GUID fromString: '{b4e52620-cc73-45ad-8f07-20a71bb2e287}')!
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
!SmalltalkMethodStyler categoriesForMethods!
initialBinaryStyle:!constants!private! !
initialKeywordStyle!constants!private! !
initialLiteralStyle:!helpers!private! !
initialUnaryStyle!constants!private! !
!

