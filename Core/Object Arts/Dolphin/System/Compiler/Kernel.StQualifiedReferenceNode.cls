"Filed out from Dolphin Smalltalk"!

Kernel.StLiteralNode subclass: #'Kernel.StQualifiedReferenceNode'
	instanceVariableNames: 'pathString flags private start stop'
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {
		'MetaMask' -> 16r1.
		'PrivateMask' -> 16r2
	}!
Kernel.StQualifiedReferenceNode guid: (Core.GUID fromString: '{48916d12-a942-4b84-b786-71ba3d982f2e}')!
Kernel.StQualifiedReferenceNode comment: '`StQualifiedReferenceNode` is a kind of `StLiteralNode` to represent qualified reference literals.

## Instance Variables:
  `pathString`		`<readableString>` fully qualified name
  `start`		`<integer>` position of the start of the opening token
  `stop`		`<integer>` position of the closing token

'!
!Kernel.StQualifiedReferenceNode categoriesForClass!System-Compiler! !
!Kernel.StQualifiedReferenceNode methodsFor!

= anObject
	self == anObject ifTrue: [^true].
	^self class == anObject class and: [self value = anObject value]!

acceptVisitor: aProgramNodeVisitor
	^aProgramNodeVisitor visitQualifiedReferenceNode: self!

isMeta
	^flags allMask: MetaMask!

isMeta: aBoolean
	flags := flags mask: MetaMask set: aBoolean!

isPrivate
	^flags allMask: PrivateMask!

isPrivate: aBoolean
	flags := flags mask: PrivateMask set: aBoolean!

isQualifiedReference
	^true!

pathString
	^pathString!

pathString: aString start: startInteger
	pathString := aString.
	flags := 0.
	start := startInteger.
	stop := -1.
	^self!

startWithoutParentheses
	^start!

stop: anInteger
	stop := anInteger!

stopWithoutParentheses
	^stop!

value
	^self valueClass
		pathString: self pathString
		scope: nil
		flags: flags!

valueClass
	^BindingReference! !
!Kernel.StQualifiedReferenceNode categoriesForMethods!
=!public! !
acceptVisitor:!public!visitor! !
isMeta!public!testing! !
isMeta:!accessing!public!testing! !
isPrivate!public!testing! !
isPrivate:!accessing!public!testing! !
isQualifiedReference!public!testing! !
pathString!accessing!public! !
pathString:start:!initializing!private! !
startWithoutParentheses!accessing!public! !
stop:!accessing!public! !
stopWithoutParentheses!accessing!public! !
value!accessing!public! !
valueClass!accessing!public! !
!

!Kernel.StQualifiedReferenceNode class methodsFor!

pathString: aString start: startInteger
	^self new pathString: aString start: startInteger! !
!Kernel.StQualifiedReferenceNode class categoriesForMethods!
pathString:start:!instance creation!public! !
!

