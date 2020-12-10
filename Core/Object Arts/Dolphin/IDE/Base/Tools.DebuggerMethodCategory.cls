"Filed out from Dolphin Smalltalk 7"!

Core.MethodCategory subclass: #'Tools.DebuggerMethodCategory'
	instanceVariableNames: 'mask'
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!
Tools.DebuggerMethodCategory guid: (Core.GUID fromString: '{424b6561-1ba5-4a45-b1e3-6936f126dcd5}')!
Tools.DebuggerMethodCategory comment: ''!
!Tools.DebuggerMethodCategory categoriesForClass!System-Support! !
!Tools.DebuggerMethodCategory methodsFor!

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
!Tools.DebuggerMethodCategory categoriesFor: #addMethodSilently:!adding!private! !
!Tools.DebuggerMethodCategory categoriesFor: #mask!accessing!public! !
!Tools.DebuggerMethodCategory categoriesFor: #mask:!accessing!private! !
!Tools.DebuggerMethodCategory categoriesFor: #removeMethodSilently:!private!removing! !

!Tools.DebuggerMethodCategory class methodsFor!

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
!Tools.DebuggerMethodCategory class categoriesFor: #initialize!public! !

