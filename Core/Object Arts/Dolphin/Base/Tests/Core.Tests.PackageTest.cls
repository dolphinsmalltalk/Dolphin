"Filed out from Dolphin Smalltalk 7"!

Core.Tests.DolphinTest subclass: #'Core.Tests.PackageTest'
	instanceVariableNames: 'loadedPackages checkTimestamps'
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!
Core.Tests.PackageTest guid: (Core.GUID fromString: '{0bcde90d-a936-43ee-9e4a-2bdec39abf2a}')!
Core.Tests.PackageTest comment: ''!
!Core.Tests.PackageTest categoriesForClass!Unclassified! !
!Core.Tests.PackageTest methodsFor!

checkNoTestPackageContents
	| scribbleClass |
	self deny: #{Smalltalk.ScribbleTest} isDefined.
	scribbleClass := #{Smalltalk.Scribble} value.
	self assertIsNil: (scribbleClass compiledMethodAt: #looseA ifAbsent: []).
	self assertIsNil: (scribbleClass compiledMethodAt: #looseC ifAbsent: []).
	self assertIsNil: (scribbleClass class compiledMethodAt: #resource_Scribble_test ifAbsent: []).
	self deny: (SharedPool allSubclasses anySatisfy: [:each | each name = #ScribbleTestSourceGlobal])!

checkTestPackageContents
	| scribbleTestPackage scribbleTestClass scribbleTest scribbleTestResourceMethod scribbleTestDefaultViewId scribbleTestViewId scribbleClass resourceIds |
	scribbleTestPackage := loadedPackages first.
	self assert: (scribbleTestPackage name beginsWith: 'ScribbleTest').
	self verifyPackageElementNamesAreAbsolute: scribbleTestPackage.
	scribbleTestClass := #{Smalltalk.ScribbleTest} value.
	self assert: (scribbleTestPackage classes identityIncludes: scribbleTestClass).
	scribbleTestResourceMethod := scribbleTestClass class
				compiledMethodAt: #resource_Default_scribble_test_view.
	self assert: scribbleTestResourceMethod owningPackage equals: scribbleTestPackage.
	scribbleClass := #{Smalltalk.Scribble} value.
	self assert: (scribbleClass compiledMethodAt: #looseA) owningPackage equals: scribbleTestPackage.
	self assert: (scribbleClass compiledMethodAt: #looseC) owningPackage equals: scribbleTestPackage.
	self assert: (scribbleClass class compiledMethodAt: #resource_Scribble_test) owningPackage
		equals: scribbleTestPackage.
	resourceIds := scribbleTestPackage allResourceIdentifiers.
	self assert: resourceIds size equals: 2.
	scribbleTestDefaultViewId := UI.ResourceIdentifier class: scribbleTestClass
				name: 'Default scribble test view'.
	self assert: (resourceIds includes: scribbleTestDefaultViewId).
	self assert: scribbleTestDefaultViewId owningPackage equals: scribbleTestPackage.
	scribbleTestViewId := UI.ResourceIdentifier class: scribbleClass name: 'Scribble test'.
	self assert: (resourceIds includes: scribbleTestViewId).
	self assert: scribbleTestViewId owningPackage equals: scribbleTestPackage.
	
	[scribbleTest := scribbleTestClass show.
	self assert: scribbleTest a equals: 'A']
			ensure: [scribbleTest view topView destroy]!

d5ForwardRefTestPacContents
	^'| package |
package := Package name: ''D5LoadTest''.
package paxVersion: 0;
	basicComment: ''''.


package resourceNames
	add: #Presenter -> ''D6'';
	add: #Shell -> ''D6'';
	add: #Toolbar -> ''D6'';
	yourself.

package binaryGlobalNames: (Set new
	yourself).

package globalAliases: (Set new
	yourself).

package allResourceNames: (Set new
	add: #Presenter -> ''D6'';
	add: #Shell -> ''D6'';
	add: #Toolbar -> ''D6'';
	yourself).

package setPrerequisites: (IdentitySet new
	add: ''Object Arts\Dolphin\Base\Dolphin'';
	add: ''Object Arts\Dolphin\MVP\Views\Common Controls\Dolphin Common Controls'';
	add: ''Object Arts\Dolphin\MVP\Views\Control Bars\Dolphin Control Bars'';
	add: ''Object Arts\Dolphin\MVP\Base\Dolphin MVP Base'';
	yourself).

package!!

"Class Definitions"!!


"Global Aliases"!!


"Loose Methods"!!

"End of package definition"!!

"Source Globals"!!

"Classes"!!

"Binary Globals"!!

"Resources"!!

(ResourceIdentifier class: Presenter name: ''D6'') assign: (Object fromBinaryStoreBytes:
(ByteArray fromBase64String: ''IVNUQiAxIEYCDAABAAAAVmlld1Jlc291cmNlAAAAAA4BJABTVEJSZXNvdXJjZVNUQkJ5dGVBcnJh
eUFjY2Vzc29yUHJveHkAAAAAcgAAALoGAAAhU1RCIDEgTggMAAoAAABTVEJWaWV3UHJveHkAAAAA
mgAAAAAAAABSAAAAEAAAAERvbHBoaW4gTVZQIEJhc2VSAAAADQAAAENvbnRhaW5lclZpZXdiAAAA
DwAAAAAAAAAAAAAAYgAAAAIAAACCAAAABAAAAAAAAEQBAAIAoAEAAAAAAAAAAAAAAAAAAAcAAAAA
AAAAAAAAAAAAAACgAQAAAAAAAOoAAAAAAAAAAAEAAGIAAAAAAAAAAAAAAAYBDwBNZXNzYWdlU2Vx
dWVuY2UAAAAAygAAAAAAAADQAAAAYgAAAAEAAAAGAwsATWVzc2FnZVNlbmQAAAAAugAAAAAAAABS
AAAAEAAAAGNyZWF0ZUF0OmV4dGVudDpiAAAAAgAAAAYCBQBQb2ludAAAAAALAAAACwAAAMICAAAA
AAAAvQIAAPUBAACgAQAABgEPAFdJTkRPV1BMQUNFTUVOVAAAAAByAAAALAAAACwAAAAAAAAAAAAA
AP////////////////////8FAAAABQAAAGMBAAD/AAAAygAAAAAAAADQAAAAYgAAAAIAAACaAQAA
AAAAAJoAAAAAAAAAUgAAABcAAABEb2xwaGluIENvbW1vbiBDb250cm9sc1IAAAAZAAAATXVsdGlw
bGVTZWxlY3Rpb25MaXN0Vmlld2IAAAAeAAAAAAAAAKABAABiAAAAAgAAAIIAAAAEAAAASRABRAEE
AABAAwAARgMJAAIAAABMaXN0TW9kZWwAAAAAygAAAAAAAADQAAAAIAIAAAAAAAAOAhEAU1RCU2lu
Z2xldG9uUHJveHkAAAAAmgAAAAAAAABSAAAABwAAAERvbHBoaW5SAAAADAAAAFNlYXJjaFBvbGlj
eboAAAAAAAAAUgAAAAgAAABpZGVudGl0eQAAAAAAAAAABwAAAAAAAAAAAAAAAAAAAEADAAAAAAAA
ggAAAAgAAAAzA///AAAAAJoAAAAAAAAAwAEAAFIAAAARAAAAQmFzaWNMaXN0QWJzdHJhY3SaAAAA
AAAAAGADAABSAAAAEgAAAEljb25pY0xpc3RBYnN0cmFjdOoDAAAAAAAAmgAAAAAAAADAAQAAUgAA
ABAAAABJY29uSW1hZ2VNYW5hZ2VyugAAAAAAAABSAAAABwAAAGN1cnJlbnQAAAAAAAAAAAAAAAAA
AAAAAAAAAAAAAADKAAAAAAAAANAAAABiAAAAAQAAAEYMDgAFAAAATGlzdFZpZXdDb2x1bW4AAAAA
UgAAAAgAAABDb2x1bW4gMckAAAC6AAAAAAAAAFIAAAAEAAAAbGVmdGAEAACaAAAAAAAAABAEAABS
AAAAEAAAAFNvcnRlZENvbGxlY3Rpb24AAAAAAAAAAEADAAAAAAAAAQAAAAAAAAAAAAAAugAAAAAA
AABSAAAABgAAAHJlcG9ydGIAAAAAAAAAAAAAAGEAAAAAAAAAAAAAADICAAAAAAAAygAAAAAAAADQ
AAAAYgAAAAIAAAByAgAAAAAAAJACAABiAAAAAgAAAMICAAAAAAAAbwAAAEcAAADCAgAAAAAAAJEB
AACNAQAAQAMAAHICAAAAAAAAugAAAAAAAABSAAAABQAAAHRleHQ6YgAAAAEAAABSAAAACAAAAENv
bHVtbiAxQAMAAPICAAAAAAAAcgAAACwAAAAsAAAAAAAAAAEAAAD/////////////////////NwAA
ACMAAAD/AAAA6QAAAMoAAAAAAAAA0AAAACACAADCAgAAAAAAAMEAAADBAAAAAAAAABcAAACaAQAA
AAAAAJoAAAAAAAAAwAEAAFIAAAANAAAAUmVmZXJlbmNlVmlld2IAAAAOAAAAAAAAAKABAABiAAAA
AgAAAIIAAAAEAAAAAAAARAEAAgCwBgAAAAAAAAAAAAAAAAAABwAAAAAAAAAAAAAAAAAAALAGAAAG
AhIAUmVzb3VyY2VJZGVudGlmaWVyAAAAAJoAAAAAAAAAUgAAABQAAABEb2xwaGluIENvbnRyb2wg
QmFyc1IAAAAHAAAAVG9vbGJhclIAAAACAAAARDYAAAAAMgIAAAAAAADKAAAAAAAAANAAAABiAAAA
AQAAAHICAAAAAAAAkAIAAGIAAAACAAAAwgIAAAAAAABRAAAACwAAAMICAAAAAAAA4QEAAFEAAACw
BgAA8gIAAAAAAAByAAAALAAAACwAAAAAAAAAAQAAAP////////////////////8oAAAABQAAABgB
AAAtAAAAYgAAAAAAAACgBgAAAAAAABUAAACgBgAAAAAAABMAAABGBQQAAwAAAEljb24AAAAAAAAA
ABAAAAAOAhEAU1RCU2luZ2xldG9uUHJveHkAAAAAmgAAAAAAAABSAAAABwAAAERvbHBoaW5SAAAA
GAAAAEltYWdlUmVsYXRpdmVGaWxlTG9jYXRvcroAAAAAAAAAUgAAAAcAAABjdXJyZW50UgAAABEA
AABDb250YWluZXJWaWV3Lmljbw4CHwBTVEJFeHRlcm5hbFJlc291cmNlTGlicmFyeVByb3h5AAAA
AFIAAAAQAAAAZG9scGhpbmRyMDA1LmRsbAAAAAA=''))!!

(ResourceIdentifier class: Shell name: ''D6'') assign: (Object fromBinaryStoreBytes:
(ByteArray fromBase64String: ''IVNUQiAxIEYCDAABAAAAVmlld1Jlc291cmNlAAAAAA4BJABTVEJSZXNvdXJjZVNUQkJ5dGVBcnJh
eUFjY2Vzc29yUHJveHkAAAAAcgAAALUEAAAhU1RCIDEgTggMAAoAAABTVEJWaWV3UHJveHkAAAAA
mgAAAAAAAABSAAAAEAAAAERvbHBoaW4gTVZQIEJhc2VSAAAACQAAAFNoZWxsVmlld2IAAAAbAAAA
AAAAAAAAAABiAAAAAgAAAAEAngEBAAIAoAEAAAAAAAAAAAAAAAAAAAcCAAAAAAAAAAAAAAAAAACg
AQAAAAAAAOoAAAAAAAAAAAEAAGIAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAABAAAAAAAAAAAA
AAAAAAAAAAAAAAEAAAAAAAAAAAAAAAYBDwBNZXNzYWdlU2VxdWVuY2UAAAAAygAAAAAAAADQAAAA
YgAAAAIAAAAGAwsATWVzc2FnZVNlbmQAAAAAugAAAAAAAABSAAAAEAAAAGNyZWF0ZUF0OmV4dGVu
dDpiAAAAAgAAAAYCBQBQb2ludAAAAAALAAAACwAAALICAAAAAAAATQMAAOcCAACgAQAAYgIAAAAA
AAC6AAAAAAAAAFIAAAAIAAAAbWVudUJhcjpiAAAAAQAAAAAAAACgAQAABgEPAFdJTkRPV1BMQUNF
TUVOVAAAAAByAAAALAAAACwAAAAAAAAAAAAAAP////////////////////8FAAAABQAAAKsBAAB4
AQAAygAAAAAAAADQAAAAYgAAAAIAAACaAQAAAAAAAJoAAAAAAAAAwAEAAFIAAAANAAAAUmVmZXJl
bmNlVmlld2IAAAAOAAAAAAAAAKABAABiAAAAAgAAAIIAAAAEAAAAAAAARAEAAgBwAwAAAAAAAAAA
AAAAAAAABwAAAAAAAAAAAAAAAAAAAHADAAAGAhIAUmVzb3VyY2VJZGVudGlmaWVyAAAAAJoAAAAA
AAAAwAEAAFIAAAAJAAAAUHJlc2VudGVyUgAAAAIAAABENgAAAAAiAgAAAAAAAMoAAAAAAAAA0AAA
AGIAAAABAAAAYgIAAAAAAACAAgAAYgAAAAIAAACyAgAAAAAAAHkAAACDAAAAsgIAAAAAAAB3AgAA
dwIAAHADAAAiAwAAAAAAAHIAAAAsAAAALAAAAAAAAAABAAAA/////////////////////zwAAABB
AAAAdwEAAHwBAABiAAAAAAAAALICAAAAAAAAwQAAAMEAAAAAAAAAFQAAAJoBAAAAAAAAgAMAAGIA
AAAOAAAAAAAAAKABAABiAAAAAgAAAIIAAAAEAAAAAAAARAEAAgDQBAAAAAAAAAAAAAAAAAAABwAA
AAAAAAAAAAAAAAAAANAEAADSAwAAAAAAAJoAAAAAAAAAUgAAABQAAABEb2xwaGluIENvbnRyb2wg
QmFyc1IAAAAHAAAAVG9vbGJhclIAAAACAAAARDYAAAAAIgIAAAAAAADKAAAAAAAAANAAAABiAAAA
AQAAAGICAAAAAAAAgAIAAGIAAAACAAAAsgIAAAAAAAApAAAACwAAALICAAAAAAAA9QEAAFsAAADQ
BAAAIgMAAAAAAAByAAAALAAAACwAAAAAAAAAAQAAAP////////////////////8UAAAABQAAAA4B
AAAyAAAAsAQAAMAEAAAAAAAAFQAAAMAEAAAAAAAAFQAAAEYFBAADAAAASWNvbgAAAAAAAAAAEAAA
AA4CEQBTVEJTaW5nbGV0b25Qcm94eQAAAACaAAAAAAAAAFIAAAAHAAAARG9scGhpblIAAAAYAAAA
SW1hZ2VSZWxhdGl2ZUZpbGVMb2NhdG9yugAAAAAAAABSAAAABwAAAGN1cnJlbnRSAAAADQAAAFNo
ZWxsVmlldy5pY28OAh8AU1RCRXh0ZXJuYWxSZXNvdXJjZUxpYnJhcnlQcm94eQAAAABSAAAAEAAA
AGRvbHBoaW5kcjAwNS5kbGwAAAAA''))!!

(ResourceIdentifier class: Toolbar name: ''D6'') assign: (Object fromBinaryStoreBytes:
(ByteArray fromBase64String: ''IVNUQiAxIEYCDAABAAAAVmlld1Jlc291cmNlAAAAAA4BJABTVEJSZXNvdXJjZVNUQkJ5dGVBcnJh
eUFjY2Vzc29yUHJveHkAAAAAcgAAAFUFAAAhU1RCIDEgTggMAAoAAABTVEJWaWV3UHJveHkAAAAA
mgAAAAAAAABSAAAAFAAAAERvbHBoaW4gQ29udHJvbCBCYXJzUgAAAAcAAABUb29sYmFyYgAAABkA
AAAAAAAAAAAAAGIAAAACAAAAggAAAAQAAAAECwBEAQACAKABAAAAAAAABgELAFN5c3RlbUNvbG9y
AAAAAB8AAAAAAAAABwIAAAAAAAAGBAQARm9udAAAAAAAAAAAEAAAAAYBBwBMT0dGT05UAAAAAHIA
AAA8AAAA8////wAAAAAAAAAAAAAAAJABAAAAAAAAAwIBIkFyaWFsAAAAAAAAAAAAAAAAAAAAAAAA
AAAAAAAAAAAABgIFAFBvaW50AAAAAMEAAADBAAAAAAAAAKABAAAAAAAAggAAAAgAAADdA///AAAA
AOoAAAAAAAAAAAEAAGIAAAAAAAAA6gAAAAAAAAAAAQAAYgAAAAYAAADLvgAABgcNAFRvb2xiYXJC
dXR0b24AAAAAy74AAAAAAACgAQAAAQAAAEYFEgAEAAAAQ29tbWFuZERlc2NyaXB0aW9uAAAAALoA
AAAAAAAAUgAAAAkAAABub0NvbW1hbmRSAAAACgAAAE5vIGNvbW1hbmQBAAAAAQAAAAAAAABGCAYA
AwAAAEJpdG1hcAAAAAAAAAAAEAAAAA4CEQBTVEJTaW5nbGV0b25Qcm94eQAAAACaAAAAAAAAAFIA
AAAHAAAARG9scGhpblIAAAAYAAAASW1hZ2VSZWxhdGl2ZUZpbGVMb2NhdG9yugAAAAAAAABSAAAA
BwAAAGN1cnJlbnRSAAAACQAAAFRvb2xzLmJtcA4CHwBTVEJFeHRlcm5hbFJlc291cmNlTGlicmFy
eVByb3h5AAAAAFIAAAAQAAAAZG9scGhpbmRyMDA1LmRsbAAAAAAAAAAABwAAAIICAAAAAAAAIQcA
ACEAAABHAAAAzb4AAPICAAAAAAAAzb4AAAAAAACgAQAAAQAAABIDAAAAAAAAMAMAAFADAAABAAAA
AQAAAAAAAABiAwAAAAAAAAAAAAAQAAAAkAMAAPADAAAQBAAAAAAAAAUAAAAAAAAARwAAAM++AADy
AgAAAAAAAM++AAAAAAAAoAEAAAEAAAASAwAAAAAAADADAABQAwAAAQAAAAEAAAAAAAAAYgMAAAAA
AAAAAAAAEAAAAJADAADwAwAAEAQAAAAAAAAFAAAAAAAAAEcAAABiAAAAAwAAAAADAABABAAAcAQA
AOoAAAAAAAAA8AAAAGIAAAACAAAAcAMAAAEAAAAAAAAAIAAAAAAAAACCAgAAAAAAACEAAAAhAAAA
ggIAAAAAAAAtAAAALQAAAAAAAAAGAwoARmxvd0xheW91dAAAAAABAAAAAQAAALoAAAAAAAAAUgAA
AAQAAABsZWZ0BgEPAE1lc3NhZ2VTZXF1ZW5jZQAAAADKAAAAAAAAANAAAABiAAAAAgAAAAYDCwBN
ZXNzYWdlU2VuZAAAAAC6AAAAAAAAAFIAAAAQAAAAY3JlYXRlQXQ6ZXh0ZW50OmIAAAACAAAAggIA
AAAAAAALAAAACwAAAIICAAAAAAAAvQIAADMAAACgAQAAcgUAAAAAAAC6AAAAAAAAAFIAAAAKAAAA
dXBkYXRlU2l6ZWIAAAAAAAAAoAEAAAYBDwBXSU5ET1dQTEFDRU1FTlQAAAAAcgAAACwAAAAsAAAA
AAAAAAAAAAD/////////////////////BQAAAAUAAABjAQAAHgAAAMoAAAAAAAAA0AAAAMACAACC
AgAAAAAAAMEAAADBAAAAAAAAABMAAABGBQQAAwAAAEljb24AAAAAAAAAABAAAAAOAhEAU1RCU2lu
Z2xldG9uUHJveHkAAAAAmgAAAAAAAABSAAAABwAAAERvbHBoaW5SAAAAGAAAAEltYWdlUmVsYXRp
dmVGaWxlTG9jYXRvcroAAAAAAAAAUgAAAAcAAABjdXJyZW50UgAAABYAAABDb250cm9sQmFyQWJz
dHJhY3QuaWNvDgIfAFNUQkV4dGVybmFsUmVzb3VyY2VMaWJyYXJ5UHJveHkAAAAAUgAAABAAAABk
b2xwaGluZHIwMDUuZGxsAAAAAA==''))!!


'!

filenameFor: aString
	^FileLocator installRelative localFileSpecFor: 'Resources\Tests\' , aString!

loadAndTestPackage: filename
	self checkNoTestPackageContents.
	loadedPackages := Package manager install: (self filenameFor: filename).
	self checkTestPackageContents
!

loadTestAndUninstallPackage: filename
	self loadAndTestPackage: filename.
	self uninstallTestPackages.
	self checkNoTestPackageContents!

setUp
	| var |
	var := Package classPool associationAt: 'CheckTimestamps'.
	checkTimestamps := var value.
	var value: true!

tearDown
	| scribbleClass |
	Package classPool at: 'CheckTimestamps' put: checkTimestamps.
	self uninstallTestPackages.
	"Manually remove the test components in case the uninstall failed or the test package didn't load correctly."
	#{Smalltalk.ScribbleTest} ifDefined: [:class | class removeFromSystem].
	scribbleClass := #{Smalltalk.Scribble} value.
	#(#looseA #looseC) do: [:each | scribbleClass removeSelector: each ifAbsent: []].
	#(#resource_Scribble_test) do: [:each | scribbleClass class removeSelector: each ifAbsent: []]!

testBehaviorFromName
	"Regression test for fix of bug handling class names containing non-ASCII characters. Note that such names are not syntactically valid in ANSI Smalltalk syntax, but they can easily be generated programmatically, and in future we may want to modernise the syntax to allow these."

	| subject |
	subject := (ClassBuilder forAnonymousSubclassOf: Package) createNewClass new.
	subject class compile: 'classFromName: aString ifAbsent: aBlock ^aString = ''Camión'''.
	self assert: (subject behaviorFromName: 'Camión class' ifAbsent: []) equals: true class!

testForwardRefLoadPac
	"#1720: Test loading and converting of old packages with forward reference view referereces"

	| pacName |
	pacName := self filenameFor: 'D5LoadTest.pac'.
	(FileStream write: pacName)
		nextPutAll: self d5ForwardRefTestPacContents;
		close.
	[loadedPackages := Package manager install: pacName] ensure: [File delete: pacName]!

testLoad21Pac
	self loadTestAndUninstallPackage: 'ScribbleTestPackages\2.1\ScribbleTest21.pac'!

testLoad40Pac
	self loadTestAndUninstallPackage: 'ScribbleTestPackages\4.0\ScribbleTest4.pac'!

testLoad40Pax
	self loadTestAndUninstallPackage: 'ScribbleTestPackages\4.0\ScribbleTest4.pax'!

testLoad51Pac
	self loadTestAndUninstallPackage: 'ScribbleTestPackages\5.1\ScribbleTest51.pac'!

testLoad51Pax
	self loadTestAndUninstallPackage: 'ScribbleTestPackages\5.1\ScribbleTest51.pax'!

testLoad60Pac
	self loadTestAndUninstallPackage: 'ScribbleTestPackages\6.0\ScribbleTest6.pac'!

testLoad60Pax
	self loadTestAndUninstallPackage: 'ScribbleTestPackages\6.0\ScribbleTest6.pax'!

testLoad70Pax
	| scribbleTestPackage aliasName binaryVariableName sourceVariableName testPool |
	self loadAndTestPackage: 'ScribbleTestPackages\7.0\ScribbleTest7.pax'.
	scribbleTestPackage := loadedPackages first.
	aliasName := 'Smalltalk.AliasToScribbleTest' asQualifiedReference.
	self assert: scribbleTestPackage aliasVariableNames asArray equals: {aliasName}.
	self assert: aliasName value identicalTo: #{Smalltalk.ScribbleTest} value.
	self assert: (scribbleTestPackage manager packageOfVariableNamed: aliasName)
		identicalTo: scribbleTestPackage.
	binaryVariableName := 'Smalltalk.ScribbleTestBinaryGlobal' asQualifiedReference.
	self assert: scribbleTestPackage binaryVariableNames asArray equals: {binaryVariableName}.
	self assert: (scribbleTestPackage manager packageOfVariableNamed: binaryVariableName)
		identicalTo: scribbleTestPackage.
	self assert: binaryVariableName value equals: #('Scribble').
	self assert: scribbleTestPackage sourceVariableNames asArray equals: #().
	sourceVariableName := 'Smalltalk.ScribbleTestSourceGlobal' asQualifiedReference.
	"We should still find the class binding among the packaged variables"
	self assert: (scribbleTestPackage manager packageOfVariableNamed: sourceVariableName) identicalTo: scribbleTestPackage.
	self assert: (scribbleTestPackage classNames includes: sourceVariableName).
	testPool := sourceVariableName value.
	self assert: testPool isKindOf: SharedPool class.
	self uninstallTestPackages.
	self checkNoTestPackageContents!

testLoad72Pax
	| scribbleTestPackage aliasName binaryVariableName sourceVariableName testPool |
	self loadAndTestPackage: 'ScribbleTestPackages\7.2\ScribbleTest72.pax'.
	scribbleTestPackage := loadedPackages first.
	aliasName := 'Smalltalk.AliasToScribbleTest' asQualifiedReference.
	self assert: scribbleTestPackage aliasVariableNames asArray equals: {aliasName}.
	self assert: aliasName value identicalTo: #{Smalltalk.ScribbleTest} value.
	binaryVariableName := 'Smalltalk.ScribbleTestBinaryGlobal' asQualifiedReference.
	self assert: scribbleTestPackage binaryVariableNames asArray equals: {binaryVariableName}.
	self assert: binaryVariableName value equals: #('Scribble').
	sourceVariableName := 'Smalltalk.ScribbleTestSourceGlobal' asQualifiedReference.
	self assert: scribbleTestPackage sourceVariableNames asArray equals: #().
	self assert: (scribbleTestPackage classNames includes: sourceVariableName).
	testPool := sourceVariableName value.
	self assert: testPool isKindOf: SharedPool class.
	self uninstallTestPackages.
	self checkNoTestPackageContents!

testLoadedPackagesAreWellFormed
	Package manager packages do: 
			[:each |
			self verifyPackageElementNamesAreAbsolute: each.
			self verifyPackageElementsExist: each]!

testLooseResourceIdentifiers
	| all loose notLoose |
	loose := Package manager looseResourceIdentifiers.
	self assert: (loose allSatisfy: [:each | each owningClass owningPackage ~= each owningPackage]).
	all := Smalltalk developmentSystem allResourceIdentifiers.
	self assert: (loose difference: all) isEmpty.
	notLoose := all difference: loose.
	self assert: (notLoose allSatisfy: [:each | each owningClass owningPackage = each owningPackage])!

testTimestampInitialized
	self assert: Package new timestamp asInteger equals: 0!

uninstallTestPackages
	loadedPackages notNil
		ifTrue: 
			[loadedPackages do: [:each | Package manager basicUninstall: each].
			loadedPackages := nil]!

verifyPackageElementNamesAreAbsolute: aPackage
	aPackage classNames do: [:each | self assert: each context isNil].
	aPackage methodNames do: [:each | self assert: each className context isNil].
	aPackage variableNames do: [:each | self assert: each context isNil].
	aPackage untracedVariables do: [:each | self assert: each context isNil]!

verifyPackageElementsExist: aPackage
	aPackage classNames do: [:each | | class |
		class := each valueOrNil.
		self assert: class notNil.
		self assert: class owningPackage identicalTo: aPackage].
	aPackage methodNames do: [:each | | method |
		method := each valueOrNil.
		self assert: method notNil.
		self assert: method owningPackage identicalTo: aPackage].
	aPackage variableNames do: [:each | self assert: each isDefined].
	aPackage sourceVariableNames do: [:each |
		| value |
		value := each value.
		self assert: value owningPackage identicalTo: aPackage].
	aPackage untracedVariables do: [:each | self assert: each isDefined]! !
!Core.Tests.PackageTest categoriesFor: #checkNoTestPackageContents!helpers!private! !
!Core.Tests.PackageTest categoriesFor: #checkTestPackageContents!helpers!private! !
!Core.Tests.PackageTest categoriesFor: #d5ForwardRefTestPacContents!constants!private! !
!Core.Tests.PackageTest categoriesFor: #filenameFor:!helpers!private! !
!Core.Tests.PackageTest categoriesFor: #loadAndTestPackage:!helpers!private! !
!Core.Tests.PackageTest categoriesFor: #loadTestAndUninstallPackage:!helpers!private! !
!Core.Tests.PackageTest categoriesFor: #setUp!private!running! !
!Core.Tests.PackageTest categoriesFor: #tearDown!private!running! !
!Core.Tests.PackageTest categoriesFor: #testBehaviorFromName!public!unit tests! !
!Core.Tests.PackageTest categoriesFor: #testForwardRefLoadPac!public!unit tests! !
!Core.Tests.PackageTest categoriesFor: #testLoad21Pac!public!unit tests! !
!Core.Tests.PackageTest categoriesFor: #testLoad40Pac!public!unit tests! !
!Core.Tests.PackageTest categoriesFor: #testLoad40Pax!public!unit tests! !
!Core.Tests.PackageTest categoriesFor: #testLoad51Pac!public!unit tests! !
!Core.Tests.PackageTest categoriesFor: #testLoad51Pax!public!unit tests! !
!Core.Tests.PackageTest categoriesFor: #testLoad60Pac!public!unit tests! !
!Core.Tests.PackageTest categoriesFor: #testLoad60Pax!public!unit tests! !
!Core.Tests.PackageTest categoriesFor: #testLoad70Pax!public!unit tests! !
!Core.Tests.PackageTest categoriesFor: #testLoad72Pax!public!unit tests! !
!Core.Tests.PackageTest categoriesFor: #testLoadedPackagesAreWellFormed!public!unit tests! !
!Core.Tests.PackageTest categoriesFor: #testLooseResourceIdentifiers!public! !
!Core.Tests.PackageTest categoriesFor: #testTimestampInitialized!public!unit tests! !
!Core.Tests.PackageTest categoriesFor: #uninstallTestPackages!private!running! !
!Core.Tests.PackageTest categoriesFor: #verifyPackageElementNamesAreAbsolute:!helpers!private! !
!Core.Tests.PackageTest categoriesFor: #verifyPackageElementsExist:!helpers!private! !

