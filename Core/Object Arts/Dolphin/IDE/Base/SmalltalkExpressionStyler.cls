"Filed out from Dolphin Smalltalk X6"!

SmalltalkStyler subclass: #SmalltalkExpressionStyler
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
SmalltalkExpressionStyler guid: (GUID fromString: '{A79E3E47-8ADC-4B02-B7A5-4B473AD6C632}')!
SmalltalkExpressionStyler comment: 'SmalltalkExpressionStyler is a <SmalltalkStyler> specialised for colouring Smalltalk expressions (as opposed to methods) in workspaces.'!
!SmalltalkExpressionStyler categoriesForClass!Kernel-Objects! !
!SmalltalkExpressionStyler methodsFor!

initialBinaryStyle: aStBinarySelectorToken 
	aStBinarySelectorToken value = #'||' 
		ifTrue: 
			[self applyStyle: #tempOpenBar toNext: 1.
			aStBinarySelectorToken start: aStBinarySelectorToken start + 1.
			^#tempCloseBar].
	aStBinarySelectorToken value = #| ifTrue: [^#tempOpenBar].
	^#binaryMessage!

initialKeywordStyle
	^#keywordMessage!

initialUnaryStyle
	^#identifier! !
!SmalltalkExpressionStyler categoriesFor: #initialBinaryStyle:!constants!private! !
!SmalltalkExpressionStyler categoriesFor: #initialKeywordStyle!constants!private! !
!SmalltalkExpressionStyler categoriesFor: #initialUnaryStyle!constants!private! !

