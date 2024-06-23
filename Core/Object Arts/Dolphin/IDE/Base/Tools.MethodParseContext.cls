"Filed out from Dolphin Smalltalk"!

Tools.ParseContext
	subclass: #'Tools.MethodParseContext'
	instanceVariableNames: 'method'
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!

Tools.MethodParseContext guid: (Core.GUID fromString: '{c4b3295e-6292-4985-852f-e9a9f2fc2284}')!

Tools.MethodParseContext comment: ''!

!Tools.MethodParseContext methodsFor!

environment
	^method environment!

method: aCompiledMethod
	method := aCompiledMethod.
	^self!

methodClass
	^method methodClass!

owningPackage
	^method owningPackage!

printOn: aStream
	aStream
		print: self species;
		nextPutAll: ' method: ';
		print: method! !

!Tools.MethodParseContext categoriesForMethods!
environment!accessing!public! !
method:!initializing!private! !
methodClass!accessing!public! !
owningPackage!accessing!public! !
printOn:!printing!public! !
!

!Tools.MethodParseContext class methodsFor!

method: aCompiledMethod
	<primitive: 157>
	^self new method: aCompiledMethod! !

!Tools.MethodParseContext class categoriesForMethods!
method:!instance creation!public! !
!

