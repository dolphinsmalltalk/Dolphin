"Filed out from Dolphin Smalltalk 7"!

Object subclass: #FindDetails
	instanceVariableNames: 'pattern replaceWith searchMode flags action'
	classVariableNames: 'IgnoreCaseMask UpMask WholeWordMask WrapMask'
	poolDictionaries: ''
	classInstanceVariableNames: ''!
FindDetails guid: (GUID fromString: '{ec9a373c-74cf-4a2c-b29c-227014e985f9}')!
FindDetails comment: ''!
!FindDetails categoriesForClass!Kernel-Objects! !
!FindDetails methodsFor!

action
	"Answer the find/replace action. One of #find, #replace, #replaceAll."

	^action!

action: aSymbol 
	action := aSymbol!

findWhat
	^pattern!

hasValidRegularExpression
	^
	[self regularExpression test: ''.
	true] on: HRESULTError do: [:ex | false]!

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

	^self searchMode == #regularExpression!

isRegularExpression: aBoolean 
	"Set whether this is a regular expression search."

	self searchMode: (aBoolean ifTrue: [#regularExpression] ifFalse: [#text])!

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
	pattern := aString ifNil: ['']!

regularExpression
	| regexp |
	regexp := self class regexpClass 
				ifNil: [self error: 'Regular expression search not supported']
				ifNotNil: [:class | class new].
	regexp pattern: self pattern asString.
	regexp ignoreCase: self isCaseSensitive not.
	"	regexp
		multiline: true;
		global: true."
	^regexp!

replaceWith
	^replaceWith!

replaceWith: aString 
	replaceWith := aString!

searchMode
	"Answer the receiver's current search mode (see class #searchModes for possible values)."

	^searchMode!

searchMode: aSymbol 
	(self class searchModes includes: aSymbol) ifFalse: [self error: 'Invalid search mode: ' , aSymbol].
	searchMode := aSymbol!

wildcardExpression
	! !
!FindDetails categoriesFor: #action!accessing!public! !
!FindDetails categoriesFor: #action:!accessing!public! !
!FindDetails categoriesFor: #findWhat!accessing!public! !
!FindDetails categoriesFor: #hasValidRegularExpression!public!testing! !
!FindDetails categoriesFor: #initialize!initializing!public! !
!FindDetails categoriesFor: #isCaseSensitive!public!testing! !
!FindDetails categoriesFor: #isCaseSensitive:!accessing!public! !
!FindDetails categoriesFor: #isForwards!public!testing! !
!FindDetails categoriesFor: #isForwards:!accessing!public! !
!FindDetails categoriesFor: #isRegularExpression!public!testing! !
!FindDetails categoriesFor: #isRegularExpression:!accessing!public! !
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
!FindDetails categoriesFor: #wildcardExpression!accessing!public! !

!FindDetails class methodsFor!

icon
	"Answers an Icon that can be used to represent this class"

	^Icon fromId: 23 in: (ExternalResourceLibrary open: 'Shell32')!

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

regexpClass
	^Smalltalk lookup: #IRegExp2!

searchModes
	^#(#text #wildcardExpression #regularExpression)! !
!FindDetails class categoriesFor: #icon!constants!public! !
!FindDetails class categoriesFor: #initialize!initializing!public! !
!FindDetails class categoriesFor: #new!instance creation!public! !
!FindDetails class categoriesFor: #newPattern:!instance creation!public! !
!FindDetails class categoriesFor: #regexpClass!constants!public! !
!FindDetails class categoriesFor: #searchModes!constants!public! !

