"Filed out from Dolphin Smalltalk 7"!

UI.FindDetails subclass: #'UI.AdvancedFindDetails'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!
UI.AdvancedFindDetails guid: (Core.GUID fromString: '{6c4e30d4-924f-4c0a-be20-50f5ec823741}')!
UI.AdvancedFindDetails comment: ''!
!UI.AdvancedFindDetails categoriesForClass!Kernel-Objects! !
!UI.AdvancedFindDetails methodsFor!

findIn: aView range: anIntervalOfInteger
	^self isRegularExpression
		ifTrue: 
			[| regexp text matches range |
			regexp := self regularExpression.
			text := aView plainTextRange: anIntervalOfInteger.
			matches := regexp execute: text.
			range := matches isEmpty ifTrue: [1 to: 0] ifFalse: [matches first range].
			range + (anIntervalOfInteger start - 1)]
		ifFalse: [super findIn: aView range: anIntervalOfInteger]!

hasValidRegularExpression
	^
	[self regularExpression test: ''.
	true] on: HRESULTError do: [:ex | false]!

isRegularExpression
	"Answer true if this is a regular expression search."

	^self searchMode == #regularExpression!

isRegularExpression: aBoolean 
	"Set whether this is a regular expression search."

	self searchMode: (aBoolean ifTrue: [#regularExpression] ifFalse: [#text])!

regularExpression
	| regexp |
	regexp := self class regexpClass new.
	regexp pattern: self pattern asString.
	regexp ignoreCase: self isCaseSensitive not.
	"	regexp
		multiline: true;
		global: true."
	^regexp! !
!UI.AdvancedFindDetails categoriesFor: #findIn:range:!public! !
!UI.AdvancedFindDetails categoriesFor: #hasValidRegularExpression!public!testing! !
!UI.AdvancedFindDetails categoriesFor: #isRegularExpression!public!testing! !
!UI.AdvancedFindDetails categoriesFor: #isRegularExpression:!accessing!public! !
!UI.AdvancedFindDetails categoriesFor: #regularExpression!accessing!public! !

!UI.AdvancedFindDetails class methodsFor!

regexpClass
	^Smalltalk.IRegExp2!

searchModes
	^super searchModes copyWith: #regularExpression! !
!UI.AdvancedFindDetails class categoriesFor: #regexpClass!constants!public! !
!UI.AdvancedFindDetails class categoriesFor: #searchModes!constants!public! !

