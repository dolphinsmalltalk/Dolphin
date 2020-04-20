"Filed out from Dolphin Smalltalk 7"!

StLiteralNode subclass: #StQualifiedReferenceNode
	instanceVariableNames: 'pathString start stop'
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
StQualifiedReferenceNode guid: (GUID fromString: '{48916d12-a942-4b84-b786-71ba3d982f2e}')!
StQualifiedReferenceNode comment: '`StQualifiedReferenceNode` is a kind of `StLiteralNode` to represent qualified reference literals.

## Instance Variables:
  `pathString`		`<readableString>` fully qualified name
  `start`		`<integer>` position of the start of the opening token
  `stop`		`<integer>` position of the closing token

'!
!StQualifiedReferenceNode categoriesForClass!System-Compiler! !
!StQualifiedReferenceNode methodsFor!

acceptVisitor: aProgramNodeVisitor
	^aProgramNodeVisitor visitQualifiedReferenceNode: self!

isQualifiedReference
	^true!

pathString
	^pathString!

pathString: aString start: startInteger stop: stopInteger
	pathString := aString.
	start := startInteger.
	stop := stopInteger.
	^self!

startWithoutParentheses
	^start!

stopWithoutParentheses
	^stop!

value
	^self valueClass pathString: self pathString!

valueClass
	^LiteralBindingReference! !
!StQualifiedReferenceNode categoriesFor: #acceptVisitor:!public!visitor! !
!StQualifiedReferenceNode categoriesFor: #isQualifiedReference!public!testing! !
!StQualifiedReferenceNode categoriesFor: #pathString!accessing!public! !
!StQualifiedReferenceNode categoriesFor: #pathString:start:stop:!initializing!private! !
!StQualifiedReferenceNode categoriesFor: #startWithoutParentheses!accessing!public! !
!StQualifiedReferenceNode categoriesFor: #stopWithoutParentheses!accessing!public! !
!StQualifiedReferenceNode categoriesFor: #value!accessing!public! !
!StQualifiedReferenceNode categoriesFor: #valueClass!accessing!public! !

!StQualifiedReferenceNode class methodsFor!

pathString: aString start: startInteger stop: stopInteger
	^self new
		pathString: aString
		start: startInteger
		stop: stopInteger! !
!StQualifiedReferenceNode class categoriesFor: #pathString:start:stop:!instance creation!public! !

