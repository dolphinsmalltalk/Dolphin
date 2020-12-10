"Filed out from Dolphin Smalltalk 7"!

Tools.SmalltalkStyler subclass: #'Tools.SmalltalkExpressionStyler'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!
Tools.SmalltalkExpressionStyler guid: (Core.GUID fromString: '{a79e3e47-8adc-4b02-b7a5-4b473ad6c632}')!
Tools.SmalltalkExpressionStyler comment: 'SmalltalkExpressionStyler is a <SmalltalkStyler> specialised for colouring Smalltalk expressions (as opposed to methods) in workspaces.'!
!Tools.SmalltalkExpressionStyler categoriesForClass!Kernel-Objects! !
!Tools.SmalltalkExpressionStyler methodsFor!

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
!Tools.SmalltalkExpressionStyler categoriesFor: #initialBinaryStyle:!constants!private! !
!Tools.SmalltalkExpressionStyler categoriesFor: #initialKeywordStyle!constants!private! !
!Tools.SmalltalkExpressionStyler categoriesFor: #initialUnaryStyle!constants!private! !

