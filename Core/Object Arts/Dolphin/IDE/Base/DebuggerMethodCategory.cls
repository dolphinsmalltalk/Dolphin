"Filed out from Dolphin Smalltalk"!

MethodCategory subclass: #DebuggerMethodCategory
	instanceVariableNames: 'mask'
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
DebuggerMethodCategory guid: (GUID fromString: '{424b6561-1ba5-4a45-b1e3-6936f126dcd5}')!
DebuggerMethodCategory comment: ''!
!DebuggerMethodCategory categoriesForClass!System-Support! !
!DebuggerMethodCategory methodsFor!

addMethodSilently: aCompiledMethod 
	super addMethodSilently: aCompiledMethod.
	Debugger 
		skipSelector: aCompiledMethod selector
		of: aCompiledMethod methodClass
		maskSet: mask!

mask
	^mask!

mask: anObject
	mask := anObject!

removeMethodSilently: aCompiledMethod 
	Debugger 
		skipSelector: aCompiledMethod selector
		of: aCompiledMethod methodClass
		maskClear: mask.
	super removeMethodSilently: aCompiledMethod! !
!DebuggerMethodCategory categoriesForMethods!
addMethodSilently:!adding!private! !
mask!accessing!public! !
mask:!accessing!private! !
removeMethodSilently:!private!removing! !
!

!DebuggerMethodCategory class methodsFor!

initialize
	| steppedThrough stepThrough stepOver steppedOver |
	stepThrough := (self newNamed: 'debugger-step through')
				mask: 1;
				yourself.
	stepOver := (self newNamed: 'debugger-step over') mask: 2 yourself.
	steppedThrough := (self name: stepThrough name) methods.
	steppedOver := (self name: stepOver name) methods.
	self
		removeCategory: stepThrough name;
		removeCategory: stepOver name.
	Table
		at: stepThrough name put: stepThrough;
		at: stepOver name put: stepOver.
	steppedThrough do: [:each | stepThrough addMethodSilently: each].
	steppedOver do: [:each | stepOver addMethodSilently: each]! !
!DebuggerMethodCategory class categoriesForMethods!
initialize!public! !
!

