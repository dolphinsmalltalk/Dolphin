!Class class methodsFor!

allRoots
	| roots i |
	roots := self basicAllRoots select: [:each | (self environment lookup: each name) == each].
	i := roots identityIndexOf: Object.
	i ~~ 1
		ifFalse: 
			[roots at: i put: (roots at: 1).
			roots at: 1 put: Object].
	^roots! !
	
!Class class categoriesFor: #allRoots!class hierarchy-accessing!private! !
ResourceIdentifier addClassVariable: 'SelectorPrefix' value: ('resource_' asUtf8String
				isImmutable: true;
				yourself)!

!Character methodsFor!

split: aReadableString
	"Answer the sub-strings of the <readableString> argument separated by the receiver."

	"Implementation Note: Although this routine is rather more complex than it need be, the performance of #subStrings(:) is important, so it pays to optimize this routine. In particular we try to avoid performing any work in the common cases where the string is either empty, or does not contain the separator at all. However, we must be careful not to over optimize and prevent correct operation for wide (Unicode) strings."

	| start answer size end |
	size := aReadableString size.
	size == 0 ifTrue: [^{}].
	end := aReadableString
				nextIndexOf: self
				from: 1
				to: size.
	end == 0 ifTrue: [^{aReadableString}].
	answer := Array writeStream: 5.
	start := 1.
	
	[answer nextPut: (aReadableString copyFrom: start to: end - 1).
	start := end + 1.
	end := aReadableString
				nextIndexOf: self
				from: start
				to: size.
	end == 0]
			whileFalse.
	"Copy any remaining chars after the last separator"
	answer nextPut: (aReadableString copyFrom: start to: size).
	^answer contents! !
