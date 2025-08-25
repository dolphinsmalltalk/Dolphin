!Core.Character methodsFor!

isIdentifierFirst
	^self isEnglishLetter or: [self == $_]!

isIdentifierSecondary
	^self isIdentifierFirst or: [self isDigit]! !