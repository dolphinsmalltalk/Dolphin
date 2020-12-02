"Filed out from Dolphin Smalltalk 7"!

AddMethodChange subclass: #DolphinAddMethodChange
	instanceVariableNames: 'packageName compilationFlags method'
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''
	classConstants: {}!
DolphinAddMethodChange guid: (GUID fromString: '{13f8e696-5138-421f-be85-426d5a1a603d}')!
DolphinAddMethodChange comment: 'DolphinAddMethodChange is a specialised AddMethodChange object that overrides the latters behaviour to support Dolphin''s different compiler interface, to maintain Dolphin''s multiple categories, and to maintain the package of loose methods.'!
!DolphinAddMethodChange categoriesForClass!Unclassified! !
!DolphinAddMethodChange methodsFor!

categories
	^protocols collect: [:each | each asMethodCategory]!

changeString
	^'<1s> <2s>>><3s>'
		expandMacrosWith: ((self changeClass includesSelector: self selector)
				ifTrue: ['Modify']
				ifFalse: ['Add'])
		with: self displayClassName
		with: self selector!

class: aClass protocol: aProtocol source: aString 
	super class: aClass protocol: aProtocol source: aString.
	self rememberCurrentPackage!

class: aClass source: aString 
	super class: aClass source: aString.
	self rememberCurrentPackage!

compilationFlags
	^compilationFlags ifNil: [self changeClass defaultCompilationFlags]!

compilationFlags: anInteger 
	compilationFlags := anInteger!

currentProtocols
	^BrowserEnvironment new whichProtocolsInclude: self selector
		in: self changeClass!

method
	"Answer the method resulting from the change. This will be nil if the change has not been
	performed yet, or was unsuccessful."

	^method!

package
	^packageName isNil 
		ifFalse: [Package manager packageNamed: packageName ifNone: []]!

package: aPackage 
	packageName := aPackage isNil ifFalse: [aPackage name]!

primitiveExecute
	"Dolphin's compiler interface is different, plus we need to maintain the package relationship"

	method := self changeClass 
				compile: source
				categories: self categories
				package: self package
				flags: self compilationFlags!

rememberCurrentPackage
	self changeClass ifNotNil: [:class |
		self package: (class compiledMethodAt: self selector ifAbsent: [class]) owningPackage]!

source
	^source! !
!DolphinAddMethodChange categoriesFor: #categories!accessing!public! !
!DolphinAddMethodChange categoriesFor: #changeString!printing!public! !
!DolphinAddMethodChange categoriesFor: #class:protocol:source:!initialize/release!public! !
!DolphinAddMethodChange categoriesFor: #class:source:!initialize/release!public! !
!DolphinAddMethodChange categoriesFor: #compilationFlags!accessing!public! !
!DolphinAddMethodChange categoriesFor: #compilationFlags:!accessing!public! !
!DolphinAddMethodChange categoriesFor: #currentProtocols!converting!public! !
!DolphinAddMethodChange categoriesFor: #method!accessing!public! !
!DolphinAddMethodChange categoriesFor: #package!accessing!public! !
!DolphinAddMethodChange categoriesFor: #package:!accessing!public! !
!DolphinAddMethodChange categoriesFor: #primitiveExecute!operations!private! !
!DolphinAddMethodChange categoriesFor: #rememberCurrentPackage!accessing!private! !
!DolphinAddMethodChange categoriesFor: #source!accessing!public! !

!DolphinAddMethodChange class methodsFor!

compile: aString in: aClass 
	^self new class: aClass source: aString!

compile: aString in: aClass categories: aSequenceableCollection 
	"N.B. The new method will be assigned to its existing package (if a modification) or the
	class' package (if an addition)."

	^self 
		compile: aString
		in: aClass
		categories: aSequenceableCollection
		package: nil!

compile: aString in: aClass categories: aSequenceableCollection package: aPackage 
	| change |
	change := self compile: aString in: aClass.
	aSequenceableCollection notNil 
		ifTrue: [change protocols: (aSequenceableCollection collect: [:each | each asString])].
	change package: aPackage.
	^change! !
!DolphinAddMethodChange class categoriesFor: #compile:in:!instance creation!public! !
!DolphinAddMethodChange class categoriesFor: #compile:in:categories:!instance creation!public! !
!DolphinAddMethodChange class categoriesFor: #compile:in:categories:package:!instance creation!public! !

