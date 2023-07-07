"Filed out from Dolphin Smalltalk"!

Kernel.StLexicalScope
	subclass: #'Kernel.StMethodScope'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!
Kernel.StMethodScope guid: (Core.GUID fromString: '{c3f6496d-702b-4c3b-91b9-3864d62dbca8}')!
Kernel.StMethodScope comment: ''!
!Kernel.StMethodScope categoriesForClass!Kernel-Objects! !
!Kernel.StMethodScope methodsFor!

environment
	^node environment!

environment: aNamespace
	super environment: aNamespace.
	node environment: aNamespace!

methodScope
	^self!

owningPackage
	| class |
	class := self methodClass.
	^(class compiledMethodAt: self selector ifAbsent: nil)
		ifNil: [class owningPackage]
		ifNotNil: [:method | method owningPackage]!

printOn: aPuttableStream
	self basicPrintOn: aPuttableStream.
	aPuttableStream
		nextPut: $(;
		print: self methodClass;
		nextPutAll: '>>';
		print: self selector;
		nextPut: $)!

selector
	^node selector! !
!Kernel.StMethodScope categoriesForMethods!
environment!accessing!public! !
environment:!accessing!public! !
methodScope!accessing!public! !
owningPackage!public! !
printOn:!printing!public! !
selector!accessing!public! !
!

Kernel.StMethodScope methodProtocol: #parseContext attributes: #(#readOnly) selectors: #(#environment #methodClass #owningPackage #resolveIdentifier:)!

!Kernel.StMethodScope class methodsFor!

forScopeNode: aStMethodNode outer: aStLexicalScope
	^self new
		node: aStMethodNode outer: aStLexicalScope;
		yourself! !
!Kernel.StMethodScope class categoriesForMethods!
forScopeNode:outer:!instance creation!public! !
!

