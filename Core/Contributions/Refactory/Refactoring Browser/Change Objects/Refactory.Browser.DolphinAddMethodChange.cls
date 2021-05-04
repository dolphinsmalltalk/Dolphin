"Filed out from Dolphin Smalltalk 7"!

Refactory.Browser.AddMethodChange subclass: #'Refactory.Browser.DolphinAddMethodChange'
	instanceVariableNames: 'environment packageName compilationFlags method'
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!
Refactory.Browser.DolphinAddMethodChange guid: (Core.GUID fromString: '{13f8e696-5138-421f-be85-426d5a1a603d}')!
Refactory.Browser.DolphinAddMethodChange comment: 'DolphinAddMethodChange is a specialised AddMethodChange object that overrides the latters behaviour to support Dolphin''s different compiler interface, to maintain Dolphin''s multiple categories, and to maintain the package of loose methods.'!
!Refactory.Browser.DolphinAddMethodChange categoriesForClass!Unclassified! !
!Refactory.Browser.DolphinAddMethodChange methodsFor!

captureCurrentState
	self changeClass
		ifNotNil: 
			[:class |
			| programObject |
			programObject := class compiledMethodAt: self selector ifAbsent: [class].
			self
				package: programObject owningPackage;
				environment: programObject environment]!

categories
	^protocols collect: [:each | each asMethodCategory]!

changeString
	^'<1s> <2s>>><3s>'
		expandMacrosWith: ((self changeClass
				ifNil: [false]
				ifNotNil: [:class | class includesSelector: self selector]) ifTrue: ['Modify'] ifFalse: ['Add'])
		with: self displayClassName
		with: self selector!

class: aClass protocol: aProtocol source: aString
	super
		class: aClass
		protocol: aProtocol
		source: aString.
	self captureCurrentState!

class: aClass source: aString
	super class: aClass source: aString.
	self captureCurrentState!

compilationFlags
	^compilationFlags ifNil: [self changeClass defaultCompilationFlags]!

compilationFlags: anInteger 
	compilationFlags := anInteger!

currentProtocols
	^BrowserEnvironment new whichProtocolsInclude: self selector in: self changeClass!

environment
	^environment!

environment: aNamespace
	environment := aNamespace!

method
	"Answer the method resulting from the change. This will be nil if the change has not been
	performed yet, or was unsuccessful."

	^method!

package
	^packageName isNil ifFalse: [Package manager packageNamed: packageName ifNone: []]!

package: aPackage 
	packageName := aPackage isNil ifFalse: [aPackage name]!

primitiveExecute
	"Dolphin's compiler interface is different, plus we need to maintain the package relationship"

	method := self changeClass
				compile: source
				environment: environment
				categories: self categories
				package: self package
				flags: self compilationFlags!

source
	^source! !
!Refactory.Browser.DolphinAddMethodChange categoriesFor: #captureCurrentState!accessing!private! !
!Refactory.Browser.DolphinAddMethodChange categoriesFor: #categories!accessing!public! !
!Refactory.Browser.DolphinAddMethodChange categoriesFor: #changeString!printing!public! !
!Refactory.Browser.DolphinAddMethodChange categoriesFor: #class:protocol:source:!initialize/release!private! !
!Refactory.Browser.DolphinAddMethodChange categoriesFor: #class:source:!initialize/release!private! !
!Refactory.Browser.DolphinAddMethodChange categoriesFor: #compilationFlags!accessing!public! !
!Refactory.Browser.DolphinAddMethodChange categoriesFor: #compilationFlags:!accessing!public! !
!Refactory.Browser.DolphinAddMethodChange categoriesFor: #currentProtocols!converting!public! !
!Refactory.Browser.DolphinAddMethodChange categoriesFor: #environment!public! !
!Refactory.Browser.DolphinAddMethodChange categoriesFor: #environment:!accessing!private! !
!Refactory.Browser.DolphinAddMethodChange categoriesFor: #method!accessing!public! !
!Refactory.Browser.DolphinAddMethodChange categoriesFor: #package!accessing!public! !
!Refactory.Browser.DolphinAddMethodChange categoriesFor: #package:!accessing!public! !
!Refactory.Browser.DolphinAddMethodChange categoriesFor: #primitiveExecute!operations!private! !
!Refactory.Browser.DolphinAddMethodChange categoriesFor: #source!accessing!public! !

!Refactory.Browser.DolphinAddMethodChange class methodsFor!

compile: aString in: aClass 
	^self new class: aClass source: aString!

compile: aString in: aClass categories: aSequenceableCollection
	"N.B. The new method will be assigned to its existing package (if a modification) or the
	class' package (if an addition)."

	| change |
	change := self compile: aString in: aClass.
	aSequenceableCollection notNil
		ifTrue: [change protocols: (aSequenceableCollection collect: [:each | each asString])].
	^change!

compile: aString in: aClass environment: aNamespace categories: aSequenceableCollection package: aPackage
	| change |
	change := self
				compile: aString
				in: aClass
				categories: aSequenceableCollection.
	change
		environment: aNamespace;
		package: aPackage.
	^change! !
!Refactory.Browser.DolphinAddMethodChange class categoriesFor: #compile:in:!instance creation!public! !
!Refactory.Browser.DolphinAddMethodChange class categoriesFor: #compile:in:categories:!instance creation!public! !
!Refactory.Browser.DolphinAddMethodChange class categoriesFor: #compile:in:environment:categories:package:!instance creation!public! !

