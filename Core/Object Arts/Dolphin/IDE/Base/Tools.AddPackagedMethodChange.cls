"Filed out from Dolphin Smalltalk"!

Refactory.Browser.AddMethodChange subclass: #'Tools.AddPackagedMethodChange'
	instanceVariableNames: 'environment packageName compilationFlags method'
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!
Tools.AddPackagedMethodChange guid: (Core.GUID fromString: '{13f8e696-5138-421f-be85-426d5a1a603d}')!
Tools.AddPackagedMethodChange comment: 'DolphinAddMethodChange is a specialised AddMethodChange object that overrides the latters behaviour to support Dolphin''s different compiler interface, to maintain Dolphin''s multiple categories, and to maintain the package of loose methods.'!
!Tools.AddPackagedMethodChange categoriesForClass!Unclassified! !
!Tools.AddPackagedMethodChange methodsFor!

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
	^Refactory.Browser.BrowserEnvironment new whichProtocolsInclude: self selector in: self changeClass!

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
!Tools.AddPackagedMethodChange categoriesFor: #captureCurrentState!accessing!private! !
!Tools.AddPackagedMethodChange categoriesFor: #categories!accessing!public! !
!Tools.AddPackagedMethodChange categoriesFor: #changeString!printing!public! !
!Tools.AddPackagedMethodChange categoriesFor: #class:protocol:source:!initialize/release!private! !
!Tools.AddPackagedMethodChange categoriesFor: #class:source:!initialize/release!private! !
!Tools.AddPackagedMethodChange categoriesFor: #compilationFlags!accessing!public! !
!Tools.AddPackagedMethodChange categoriesFor: #compilationFlags:!accessing!public! !
!Tools.AddPackagedMethodChange categoriesFor: #currentProtocols!converting!public! !
!Tools.AddPackagedMethodChange categoriesFor: #environment!accessing!public! !
!Tools.AddPackagedMethodChange categoriesFor: #environment:!accessing!private! !
!Tools.AddPackagedMethodChange categoriesFor: #method!accessing!public! !
!Tools.AddPackagedMethodChange categoriesFor: #package!accessing!public! !
!Tools.AddPackagedMethodChange categoriesFor: #package:!accessing!public! !
!Tools.AddPackagedMethodChange categoriesFor: #primitiveExecute!operations!private! !
!Tools.AddPackagedMethodChange categoriesFor: #source!accessing!public! !

