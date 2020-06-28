"Filed out from Dolphin Smalltalk 7"!

Object subclass: #FindDetails
	instanceVariableNames: 'pattern replaceWith searchMode flags action'
	classVariableNames: 'IgnoreCaseMask UpMask WholeWordMask WrapMask'
	poolDictionaries: ''
	classInstanceVariableNames: ''
	classConstants: {}!
FindDetails guid: (GUID fromString: '{ec9a373c-74cf-4a2c-b29c-227014e985f9}')!
FindDetails comment: ''!
!FindDetails categoriesForClass!Kernel-Objects! !
!FindDetails methodsFor!

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
!FindDetails categoriesFor: #action!accessing!public! !
!FindDetails categoriesFor: #action:!accessing!public! !
!FindDetails categoriesFor: #findIn:range:!public! !
!FindDetails categoriesFor: #findWhat!accessing!public! !
!FindDetails categoriesFor: #hasValidRegularExpression!public!testing! !
!FindDetails categoriesFor: #initialize!initializing!public! !
!FindDetails categoriesFor: #isCaseSensitive!public!testing! !
!FindDetails categoriesFor: #isCaseSensitive:!accessing!public! !
!FindDetails categoriesFor: #isForwards!public!testing! !
!FindDetails categoriesFor: #isForwards:!accessing!public! !
!FindDetails categoriesFor: #isRegularExpression!public!testing! !
!FindDetails categoriesFor: #isWholeWord!public!testing! !
!FindDetails categoriesFor: #isWholeWord:!accessing!public! !
!FindDetails categoriesFor: #isWildcard!public!testing! !
!FindDetails categoriesFor: #isWildcard:!accessing!public! !
!FindDetails categoriesFor: #isWrapAround!public!testing! !
!FindDetails categoriesFor: #isWrapAround:!accessing!public! !
!FindDetails categoriesFor: #pattern!accessing!public! !
!FindDetails categoriesFor: #pattern:!accessing!public! !
!FindDetails categoriesFor: #regularExpression!accessing!public! !
!FindDetails categoriesFor: #replaceWith!accessing!public! !
!FindDetails categoriesFor: #replaceWith:!accessing!public! !
!FindDetails categoriesFor: #searchMode!accessing!public! !
!FindDetails categoriesFor: #searchMode:!accessing!public! !

!FindDetails class methodsFor!

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
!FindDetails class categoriesFor: #icon!constants!public! !
!FindDetails class categoriesFor: #initialize!development!initializing!public! !
!FindDetails class categoriesFor: #new!instance creation!public! !
!FindDetails class categoriesFor: #newPattern:!instance creation!public! !
!FindDetails class categoriesFor: #searchModes!constants!public! !

