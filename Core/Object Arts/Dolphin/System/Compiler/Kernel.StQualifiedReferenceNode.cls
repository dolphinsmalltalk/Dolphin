"Filed out from Dolphin Smalltalk"!

Kernel.StLiteralNode subclass: #'Kernel.StQualifiedReferenceNode'
	instanceVariableNames: 'pathString flags start stop binding'
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!
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
	^(anObject isKindOf: self class)
		and: [pathString = anObject pathString and: [flags = anObject flags]]!

acceptVisitor: aProgramNodeVisitor
	^aProgramNodeVisitor visitQualifiedReferenceNode: self!

flags
	^flags!

flags: anInteger
	flags := anInteger!

isMeta
	^flags allMask: BindingReference.MetaMask!

isMeta: aBoolean
	flags := flags mask: BindingReference.MetaMask set: aBoolean!

isPrivate
	^flags allMask: BindingReference.PrivateMask!

isPrivate: aBoolean
	flags := flags mask: BindingReference.PrivateMask set: aBoolean!

isQualifiedReference
	^true!

isRelative
	^flags allMask: BindingReference.RelativeMask!

isRelative: aBoolean
	flags := flags mask: BindingReference.RelativeMask set: aBoolean!

path
	^BindingReference.PathSeparator split: pathString!

pathString
	^pathString!

pathString: aString
	pathString := aString!

pathString: aString start: startInteger flags: flagsInteger
	pathString := aString.
	flags := flagsInteger.
	(aString size > 0 and: [(aString at: 1) == $_ or: [(BindingReference isQualifiedName: aString) not]])
		ifTrue: [flags := flags bitOr: BindingReference.RelativeMask].
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
		scope: self methodClass
		flags: flags!

valueClass
	^BindingReference! !
!Kernel.StQualifiedReferenceNode categoriesForMethods!
=!comparing!public! !
acceptVisitor:!public!visitor! !
flags!accessing!public! !
flags:!accessing!public! !
isMeta!public!testing! !
isMeta:!accessing!public!testing! !
isPrivate!public!testing! !
isPrivate:!accessing!public!testing! !
isQualifiedReference!public!testing! !
isRelative!public!testing! !
isRelative:!accessing!public!testing! !
path!accessing!public! !
pathString!accessing!public! !
pathString:!accessing!private! !
pathString:start:flags:!initializing!private! !
startWithoutParentheses!accessing!public! !
stop:!accessing!public! !
stopWithoutParentheses!accessing!public! !
value!accessing!public! !
valueClass!accessing!public! !
!

!Kernel.StQualifiedReferenceNode class methodsFor!

pathString: aString start: startInteger flags: flagsInteger
	^self new pathString: aString start: startInteger flags: flagsInteger! !
!Kernel.StQualifiedReferenceNode class categoriesForMethods!
pathString:start:flags:!instance creation!public! !
!

