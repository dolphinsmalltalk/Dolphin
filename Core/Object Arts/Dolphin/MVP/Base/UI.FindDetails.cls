"Filed out from Dolphin Smalltalk"!

Core.Object
	subclass: #'UI.FindDetails'
	instanceVariableNames: 'pattern replaceWith searchMode flags action'
	classVariableNames: 'IgnoreCaseMask UpMask WholeWordMask WrapMask'
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!
UI.FindDetails guid: (Core.GUID fromString: '{ec9a373c-74cf-4a2c-b29c-227014e985f9}')!
UI.FindDetails comment: ''!
!UI.FindDetails categoriesForClass!Kernel-Objects! !
!UI.FindDetails methodsFor!

action
	"Answer the find/replace action. One of #find, #replace, #replaceAll."

	^action!

action: aSymbol 
	action := aSymbol!

findIn: aView range: anIntervalOfInteger
	^aView findMatch: self inRange: anIntervalOfInteger!

findWhat
	^pattern!

hasValidRegularExpression
	^false!

initialize
	pattern := replaceWith := ''.
	flags := 0.
	action := #findNext.
	searchMode := #text!

isCaseSensitive
	"Answer true if this is a case-sensitive search."

	^flags noMask: IgnoreCaseMask!

isCaseSensitive: aBoolean 
	"Set whether this is a case-sensitive search."

	flags := flags mask: IgnoreCaseMask set: aBoolean not!

isForwards
	"Answerwhether this is a forward search."

	^flags noMask: UpMask!

isForwards: aBoolean 
	"Set whether this is a forward search."

	flags := flags mask: UpMask set: aBoolean not!

isRegularExpression
	"Answer true if this is a regular expression search."

	^false!

isValid
	^pattern notEmpty!

isWholeWord
	"Answer true if this is a whole word match operation"

	^flags anyMask: WholeWordMask!

isWholeWord: aBoolean 
	"Set whether this is a whole word match operation"

	flags := flags mask: WholeWordMask set: aBoolean!

isWildcard
	"Answer true if this is a wildcard search."

	^self searchMode == #wildcardExpression!

isWildcard: aBoolean 
	"Set whether this is a wildcard search."

	self searchMode: (aBoolean ifTrue: [#wildcardExpression] ifFalse: [#text])!

isWrapAround
	"Answer whether the search should wrap-around at end/beginning of the text."

	^flags anyMask: WrapMask!

isWrapAround: aBoolean 
	"Set whether the search should wrap-around at end/beginning of the text."

	flags := flags mask: WrapMask set: aBoolean!

pattern
	^pattern!

pattern: aString
	pattern := aString ?? ''!

regularExpression
	^self error: 'Regular expression search not supported'!

replaceWith
	^replaceWith!

replaceWith: aString 
	replaceWith := aString!

searchMode
	"Answer the receiver's current search mode (see class #searchModes for possible values)."

	^searchMode!

searchMode: aSymbol 
	(self class searchModes includes: aSymbol) ifFalse: [self error: 'Invalid search mode: ' , aSymbol].
	searchMode := aSymbol! !
!UI.FindDetails categoriesForMethods!
action!accessing!public! !
action:!accessing!public! !
findIn:range:!operations!public! !
findWhat!accessing!public! !
hasValidRegularExpression!public!testing! !
initialize!initializing!public! !
isCaseSensitive!public!testing! !
isCaseSensitive:!accessing!public! !
isForwards!public!testing! !
isForwards:!accessing!public! !
isRegularExpression!public!testing! !
isValid!public!testing! !
isWholeWord!public!testing! !
isWholeWord:!accessing!public! !
isWildcard!public!testing! !
isWildcard:!accessing!public! !
isWrapAround!public!testing! !
isWrapAround:!accessing!public! !
pattern!accessing!public! !
pattern:!accessing!public! !
regularExpression!accessing!public! !
replaceWith!accessing!public! !
replaceWith:!accessing!public! !
searchMode!accessing!public! !
searchMode:!accessing!public! !
!

!UI.FindDetails class methodsFor!

icon
	"Answers an Icon that can be used to represent this class"

	^Icon fromId: 'Find.ico'!

initialize
	IgnoreCaseMask := 1.
	WholeWordMask := 2.
	WrapMask := 4.
	UpMask := 1000.
!

new
	^super new initialize!

newPattern: aString 
	| pattern answer mode |
	answer := self new.
	(aString includesAnyOf: '*?#') 
		ifTrue: 
			[pattern := aString copyReplacing: $? withObject: $#.
			mode := #wildcardExpression]
		ifFalse: 
			[pattern := aString asSymbol.
			mode := #text].
	^answer
		pattern: pattern;
		searchMode: mode;
		yourself!

searchModes
	^#(#text #wildcardExpression)! !
!UI.FindDetails class categoriesForMethods!
icon!constants!public! !
initialize!development!initializing!public! !
new!instance creation!public! !
newPattern:!instance creation!public! !
searchModes!constants!public! !
!

