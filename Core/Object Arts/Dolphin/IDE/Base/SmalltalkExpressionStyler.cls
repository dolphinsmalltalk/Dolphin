"Filed out from Dolphin Smalltalk"!

SmalltalkStyler subclass: #SmalltalkExpressionStyler
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!

SmalltalkExpressionStyler guid: (GUID fromString: '{a79e3e47-8adc-4b02-b7a5-4b473ad6c632}')!

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

!SmalltalkExpressionStyler categoriesForMethods!
initialBinaryStyle:!constants!private! !
initialKeywordStyle!constants!private! !
initialUnaryStyle!constants!private! !
!

