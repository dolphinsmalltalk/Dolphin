"Filed out from Dolphin Smalltalk 7"!

Tools.SmalltalkStyler subclass: #'Tools.SmalltalkMethodStyler'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!
Tools.SmalltalkMethodStyler guid: (Core.GUID fromString: '{b4e52620-cc73-45ad-8f07-20a71bb2e287}')!
Tools.SmalltalkMethodStyler comment: 'SmalltalkMethodStyler is a <SmalltalkStyler> specialised to colour method definitions. It differs in recognising the method signature, which is not itself a valid Smalltalk expression.'!
!Tools.SmalltalkMethodStyler categoriesForClass!Kernel-Objects! !
!Tools.SmalltalkMethodStyler methodsFor!

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
!Tools.SmalltalkMethodStyler categoriesFor: #initialBinaryStyle:!constants!private! !
!Tools.SmalltalkMethodStyler categoriesFor: #initialKeywordStyle!constants!private! !
!Tools.SmalltalkMethodStyler categoriesFor: #initialLiteralStyle:!helpers!private! !
!Tools.SmalltalkMethodStyler categoriesFor: #initialUnaryStyle!constants!private! !

