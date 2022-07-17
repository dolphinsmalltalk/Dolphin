"Filed out from Dolphin Smalltalk"!

Core.Tests.DolphinTest subclass: #'UI.Tests.PresenterTest'
	instanceVariableNames: 'presenter'
	classVariableNames: ''
	imports: #(#{OS.Win32Constants})
	classInstanceVariableNames: ''
	classConstants: {}!
UI.Tests.PresenterTest guid: (Core.GUID fromString: '{80e6f4ef-64d4-40f6-857c-5b74578eb87b}')!
UI.Tests.PresenterTest isNonInstantiable: true!
UI.Tests.PresenterTest comment: ''!
!UI.Tests.PresenterTest methodsFor!

classToTest
	^self subclassResponsibility!

destroyPresenter
	presenter isNil
		ifFalse: 
			[| shell |
			shell := presenter topShell.
			shell = View desktop ifTrue: [presenter destroy] ifFalse: [shell close].
			presenter := nil]!

initializePresenter
	self classToTest
		ifNotNil: 
			[:subjectClass |
			| shell |
			presenter := subjectClass show.
			shell := presenter topShell.
			shell = View desktop ifFalse: [shell text: self printString]]!

leftClickAt: aPoint 
	"Fire a left-click at the specified client coordinate of the tested presenter."

	"Implementation Note: Use the correct method of sending input (i.e. the SendInput API). This
	actually moves the mouse as if the user were generating the input, but note that the
	coordinates have to be mapped into normalised screen coordinates in the range 0..65535.
	Frankly it is a lot easier just to send a couple of messages, but I wanted to try this out
	as an experiment for future reference. Unforunately I can't get it to work except when
	evaluating the expression from the debugger. This suggests there is some timing related
	issue."

	| lParam |
	self waitForInputIdle.
	lParam := aPoint x << 16 | aPoint y.
	presenter view 
		sendMessage: WM_LBUTTONDOWN
		wParam: MK_LBUTTON
		lParam: lParam.
	presenter view 
		sendMessage: WM_LBUTTONUP
		wParam: 0
		lParam: lParam.
	^self.
!

oldDolphinVersionsForStbUpgrade
	"Answer an <sequencedReadableCollection> of <Integer>, being the Dolphin versions for which there is a test view binary resource in a .vu file to attempt to upgrade."

	^#()!

oldStlResources
	^self class resourceIdentifiers!

setUp
	self shouldSetupPresenter ifTrue: [self initializePresenter]!

shouldSetupPresenter
	^(self thisTestMethod hasAnnotation: #nocreate) not!

tearDown
	self destroyPresenter!

testStbUpgradeFromBinaryResources
	"Test upgrades of old STB version .vu resources. These were used in versions of Dolphin prior to 6.0, after which the STL format was introduced and the resources stored as literal arrays in class methods.
	In most cases the D5 resources are the same as the D4 version so are not tested. Later Dolphin versions had view resources in STL form, and these are tested separated."

	"In order to test a subclass:
		- Drop copies of the binary .vu resource files into appropriate subdirectories of the Resources\Tests\ViewResources folder for each relevant pre-D6 version.
		- Override the oldDolphinVersions method to return a collection of the major versions to be tested
		- Override the #verifyUpgradedView: method to add any further validation of the upgrade process, if required."

	<nocreate>
	self oldDolphinVersionsForStbUpgrade do: 
			[:each |
			self verifyStbUpgrade: each.
			self destroyPresenter]!

testStlUpgradesFromLiteralResources
	"Test upgrades of old STL versions in STL format, e.g. from D6 or 7."

	"In order to test a subclass:
		- drop a copy of a relevant STL view resource method on the class side of the test class.
		- Override the #verifyUpgradedView: method to add any further validation of the upgrade process, if required."

	<nocreate>
	self oldStlResources do: 
			[:each |
			self verifyStlUpgrade: each resource.
			self destroyPresenter]!

verifyStbUpgrade: anInteger
	| stream filer version |
	stream := self resourceStream: 'ViewResources/D<1p>/<2s>' << {anInteger. self vuFile} text: false.
	filer := STBInFiler on: stream.
	presenter := filer
				context: View desktop;
				basicNext.
	stream close.
	version := presenter version.
	filer evaluateDeferredActions.
	self verifyUpgradedView: version!

verifyStlUpgrade: anArray
	| version filer |
	filer := STLInFiler on: anArray readStream.
	presenter := filer
				context: View desktop;
				basicNext.
	version := presenter version.
	filer evaluateDeferredActions.
	self verifyUpgradedView: version!

verifyUpgradedView: anInteger
	| view |
	view := self view.
Transcript print: anInteger; nextPutAll: ': '; print: presenter; cr.
	self assert: view isKindOf: self viewClass.
	self assert: view isOpen!

view
	^presenter view!

viewClass
	^self classToTest!

vuFile
	^self shouldNotImplement!

waitForInputIdle
	SessionManager inputState pumpMessages! !
!UI.Tests.PresenterTest categoriesForMethods!
classToTest!constants!private! !
destroyPresenter!public!Running! !
initializePresenter!public!Running! !
leftClickAt:!helpers!private! !
oldDolphinVersionsForStbUpgrade!constants!private! !
oldStlResources!constants!private! !
setUp!public!Running! !
shouldSetupPresenter!helpers!private! !
tearDown!public!Running! !
testStbUpgradeFromBinaryResources!public!unit tests! !
testStlUpgradesFromLiteralResources!public!unit tests! !
verifyStbUpgrade:!helpers!private! !
verifyStlUpgrade:!helpers!private! !
verifyUpgradedView:!helpers!private! !
view!accessing!private! !
viewClass!constants!private! !
vuFile!constants!private! !
waitForInputIdle!helpers!private! !
!

