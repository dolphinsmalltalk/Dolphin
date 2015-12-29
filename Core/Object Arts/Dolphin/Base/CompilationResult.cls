"Filed out from Dolphin Smalltalk X6"!

Object subclass: #CompilationResult
	instanceVariableNames: 'method _reserved rawTextMap rawTempsMap textMap tempsMap oldMethod package '
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
CompilationResult guid: (GUID fromString: '{87B4C46E-026E-11D3-9FD7-00A0CC3E4A32}')!
CompilationResult comment: ''!
!CompilationResult categoriesForClass!System-Support! !
!CompilationResult methodsFor!

buildTempsMap
	tempsMap := OrderedCollection new: rawTempsMap size.
	rawTempsMap do: 
			[:each | 
			| startIP stopIP temps |
			startIP := each at: 1.
			stopIP := each at: 2.
			temps := each at: 3.
			tempsMap addLast: (startIP to: stopIP) -> temps].
	"Discard the raw temps map built by the compiler to save space"
	rawTempsMap := nil!

buildTextMap
	| sz |
	sz := rawTextMap basicSize.
	textMap := OrderedCollection new: sz // 3.
	1 to: sz
		by: 3
		do: [:i | textMap add: (rawTextMap at: i) -> ((rawTextMap at: i + 1) to: (rawTextMap at: i + 2))].
	"Discard the raw text map built by the compiler to save space"
	rawTextMap := nil!

fireSystemUpdateEvent
	self method methodClass environment 
		trigger: (self isNew ifTrue: [#methodAdded:] ifFalse: [#methodUpdated:])
		with: self!

isNew
	^oldMethod isNil!

method
	"Answer the method resulting from a compilation, or nil if the compilation failed
	or the compilation was for the purpose of syntax checking only."

	^method!

method: aCompiledMethod
	"Private - Set the method."

	method := aCompiledMethod!

oldMethod
	^oldMethod!

oldMethod: aCompiledMethod
	oldMethod := aCompiledMethod!

package
	^package!

package: aPackage
	package := aPackage!

rawTempsMap: anObject
	rawTempsMap := anObject!

rawTextMap: anObject
	rawTextMap := anObject!

tempsAtIp: ip 
	| found |
	self tempsMap keysAndValuesDo: 
			[:i :each | 
			| range |
			range := each key.
			(range includes: ip) ifTrue: [found := each value]].
	^found ifNil: [Array new]!

tempsMap
	"Answer the map of ip ranges to temporaries if such was requested (if not, then nil).
	The map is an array of associations between IP positions and the temporaries which
	are in scope at that point up to the next entry in the map."

	tempsMap isNil ifTrue: [self buildTempsMap].
	^tempsMap!

textMap
	"Answer the map of ip's to source code ranges if such was requested (if not, then nil)."

	textMap isNil ifTrue: [self buildTextMap].
	^textMap! !
!CompilationResult categoriesFor: #buildTempsMap!development!private! !
!CompilationResult categoriesFor: #buildTextMap!development!private! !
!CompilationResult categoriesFor: #fireSystemUpdateEvent!helpers!private! !
!CompilationResult categoriesFor: #isNew!accessing!public! !
!CompilationResult categoriesFor: #method!accessing!public! !
!CompilationResult categoriesFor: #method:!accessing!private! !
!CompilationResult categoriesFor: #oldMethod!accessing!public! !
!CompilationResult categoriesFor: #oldMethod:!accessing!public! !
!CompilationResult categoriesFor: #package!accessing!public! !
!CompilationResult categoriesFor: #package:!accessing!public! !
!CompilationResult categoriesFor: #rawTempsMap:!accessing!private! !
!CompilationResult categoriesFor: #rawTextMap:!accessing!private! !
!CompilationResult categoriesFor: #tempsAtIp:!accessing!development!private! !
!CompilationResult categoriesFor: #tempsMap!accessing!development!public! !
!CompilationResult categoriesFor: #textMap!accessing!development!public! !

